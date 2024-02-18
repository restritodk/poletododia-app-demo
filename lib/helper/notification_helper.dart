import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:untitled/controllers/notification_controller.dart';
import 'package:untitled/helper/route_helper.dart';
import '../data/model/enum/notification_type.dart';
import 'helpers.dart';

class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String? payload) async
    {

      var data = jsonDecode(payload ?? '{}');
      if(data.isNotEmpty){
        var payload = jsonDecode(data['payload']);
        var notificationType = NotificationType.values.byName(payload['notification_type'] ?? NotificationType.unknown.name);
         if(notificationType != NotificationType.unknown){
          switch(notificationType){

            case NotificationType.calendar:
            case NotificationType.comments:
            case NotificationType.class_post:
            Get.find<NotificationController>().selectedNotification(notificationType: notificationType, notificationID: payload['notification_id'], itemID: payload['id']);
            break;
            case NotificationType.push_custom:
              if(payload['link'] != null){
                Helpers.goBrowser(payload['link']);
              }else{
                Get.toNamed(RouteHelper.getNotificationPushRoute(notificationID: payload['notificationID']));
              }
              break;
            case NotificationType.unknown:
            case NotificationType.payment:
              break;
          }
        }
      }


    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{

      var title = message.notification!.title!;
      var body = message.notification!.body!;
      String channel = message.data['notification_channel'];
      int channelID = Helpers.toInt(message.data['notification_channel_id']);
      var bigImage = Platform.isAndroid ? message.notification!.android!.imageUrl : message.notification!.apple!.imageUrl;

      if(bigImage != null && bigImage.startsWith('http')){
        bigImage = await _downloadAndSaveFile(bigImage, '$channelID.png');
      }


      createNotification(channelID, title, body, bigImage, jsonEncode(message.data), flutterLocalNotificationsPlugin, (channel??'app_name'));
      Get.find<NotificationController>().saveNotificationDatabase(message, bigImage);
    });

    // FirebaseMessaging.onBackgroundMessage((message) => myBackgroundMessageHandler(message, flutterLocalNotificationsPlugin));


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var data = message.data;
      var payload = jsonDecode(data['payload']);

      var notificationType = NotificationType.values.byName(payload['notification_type'] ?? NotificationType.unknown.name);
      if(notificationType != NotificationType.unknown){
        switch(notificationType){

          case NotificationType.calendar:
          case NotificationType.comments:
          case NotificationType.class_post:
            Get.find<NotificationController>().selectedNotification(notificationType: notificationType, notificationID: payload['notification_id'], itemID: payload['id']);
            break;
          case NotificationType.push_custom:
            if(payload['link'] != null){
              Helpers.goBrowser(payload['link']);
            }else{
              Get.toNamed(RouteHelper.getNotificationPushRoute(notificationID: payload['notificationID']));
            }
            break;
          case NotificationType.unknown:
          case NotificationType.payment:
            break;
        }
      }

    });
  }


  static Future<void> showBigTextNotification(int uniqueId, String title, String message, String bigImage, String payload, FlutterLocalNotificationsPlugin fln, String channel) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel, channel, importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(uniqueId, title, message, platformChannelSpecifics, payload: payload);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(int uniqueId, String title, String message, String bigImage, String payload, FlutterLocalNotificationsPlugin fln, String channel) async{

    final String largeIconPath = await _downloadAndSaveFile(bigImage, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(bigImage, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: message, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel, channel,
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(uniqueId, title, message, platformChannelSpecifics, payload: payload);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName, {Duration expirationDuration = const Duration(days: 7)}) async {
    final Directory directoryRoot = await getApplicationDocumentsDirectory();
    final Directory directory = Directory('${directoryRoot.path}/notifications');
    if(!directory.existsSync()){
      directory.createSync();
    }
    final String filePath = '${directory.path}/$fileName';

    final File file = File(filePath);
    if (file.existsSync()) {
      final DateTime lastModified = file.lastModifiedSync();

      if (DateTime.now().difference(lastModified) > expirationDuration) {
        file.deleteSync();
      } else {
        return filePath;
      }
    }

    url = Helpers.uri(url);
    final http.Response response = await http.get(Uri.parse(url));
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static void createNotification(int uniqueId, String title, String message, String? bigImage, String payload, FlutterLocalNotificationsPlugin fln, String channel) async{
    if(bigImage != null && bigImage.isNotEmpty) {
        try{
          await showBigPictureNotificationHiddenLargeIcon(uniqueId, title, message, bigImage, payload, fln,channel);
        }catch(e) {
          await showBigTextNotification(uniqueId, title, message, bigImage, payload, fln, channel);
        }
      }else {
        await showBigTextNotification(uniqueId, title, message, '', payload, fln, channel);
      }
   // }
  }

  static  Future<dynamic> myBackgroundMessageHandler(RemoteMessage message, flutterLocalNotificationsPlugin) async {
    var title = message.notification!.title!;
    var body = message.notification!.body!;
    String channel = message.data['notification_channel'];
    int channelID = Helpers.toInt(message.data['notification_channel_id']);
    var bigImage = Platform.isAndroid ? message.notification!.android!.imageUrl : message.notification!.apple!.imageUrl;

    if(bigImage != null && bigImage.startsWith('http')){
      bigImage = await _downloadAndSaveFile(bigImage, '$channelID.png');
    }

    createNotification(channelID, title, body, bigImage, jsonEncode(message.data), flutterLocalNotificationsPlugin, (channel??'app_name'));
    Get.find<NotificationController>().saveNotificationDatabase(message, bigImage);
  }

}



import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/data/model/enum/notification_type.dart';
import 'package:untitled/helper/helpers.dart';
import 'package:untitled/helper/route_helper.dart';

import '../data/model/response/notification_model.dart';
import '../helper/notification_database.dart';
import '../interfaces/notifications/notification_interface.dart';

class NotificationController extends GetxController implements GetxService, NotificationInterface{

  final NotificationDatabase _notificationDB = NotificationDatabase();

  List<NotificationModel>? _notifications;
  int _countNotification = 0;

  List<NotificationModel>? get notifications => _notifications;
  int get countNotification => _countNotification;

  @override
  Future<void> loadingNotification() async{
    _notifications = await _notificationDB.loadingNotifications();

    _countNotification = _notifications!.where((notification) => !notification.isRead!).length;

    update();
  }

  @override
  Future<void> deleteNotification(NotificationModel notificationModel) async{
    Helpers.setLoading();
    if(notificationModel.image != ''){
      var file = File(notificationModel.image!);
      if(file.existsSync()){
        file.deleteSync();
      }
    }
    await _notificationDB.delete(notificationModel);
    await loadingNotification();
    Helpers.removeLoading();
  }

  @override
  Future<void> saveNotificationDatabase(RemoteMessage message, String? bigImage) async {
    var payload = jsonDecode(message.data['payload']);

    var notificationModel = NotificationModel(
        title: message.notification!.title,
        body: message.notification!.body,
        image: bigImage ?? '',
        link: payload['link'] ?? '',
        notificationID: payload['notification_id'],
        itemID: payload['id'] ?? '',
        notificationType: NotificationType.values.byName(payload['notification_type'])
    );

    await _notificationDB.add(notificationModel);
    await loadingNotification();
  }

  @override
  Future<void> cleanNotification() async{
    final Directory directoryRoot = await getApplicationDocumentsDirectory();
    final Directory directory = Directory('${directoryRoot.path}/notifications');
    if(directory.existsSync()){
      directory.deleteSync();
    }
    await _notificationDB.clear();
    await loadingNotification();
  }

  @override
  void selectedNotification({required NotificationType notificationType, required String itemID, required String notificationID}) {
    setReadNotification(notificationID: notificationID);
    if(notificationType == NotificationType.calendar){
      //Chamar uma funcao para ir ate o calendario
    }else if(notificationType == NotificationType.comments){
      Get.toNamed(RouteHelper.getCommentCommunityRoute(commentId: Helpers.toInt(itemID)));
    }else if(notificationType == NotificationType.class_post){
      //Ir ate a aula
    }else{
      Get.toNamed(RouteHelper.getPostCommunityRoute(postId: Helpers.toInt(itemID)));
    }
  }

  @override
  Future<void> setReadNotification({required String notificationID}) async{
    await _notificationDB.updated(notificationID, {
      'read': true
    });
    await loadingNotification();
  }

  @override
  Future<void> cleanReadNotifications() async{
    await _notificationDB.cleanReadNotifications();
    await loadingNotification();
  }
}
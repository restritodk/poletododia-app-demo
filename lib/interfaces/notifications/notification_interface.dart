import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:untitled/data/model/enum/notification_type.dart';
import 'package:untitled/data/model/response/notification_model.dart';

abstract class NotificationInterface{

  Future<void> loadingNotification();

  Future<void> deleteNotification(NotificationModel notificationModel);

  Future<void> saveNotificationDatabase(RemoteMessage message, String? bigImage);

  Future<void> cleanNotification();

  void selectedNotification({required NotificationType notificationType, required String itemID, required String notificationID});

  Future<void> setReadNotification({required String notificationID});

  Future<void> cleanReadNotifications();
}
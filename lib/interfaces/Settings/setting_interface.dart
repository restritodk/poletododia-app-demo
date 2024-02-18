import 'package:untitled/data/model/response/app_settings.dart';
import 'package:untitled/data/model/response/notification_model.dart';

import '../../data/model/response/user_model.dart';
import '../../data/model/response/user_settings.dart';

abstract class SettingInterface{

  void putAppSettings({required AppSettings appSettings});

  void putUserSettings({required UserSettings userSettings});

  Future<void> initializeFirebaseMessaging();

  Future<void> removeFirebaseMessaging();

  Future<void> changeNotificationOption(SettingItem settingItem);

  User? getUser();
}
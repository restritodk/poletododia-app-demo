import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/data/model/response/user_model.dart';

import '../../interfaces/Settings/setting_repo_interface.dart';
import '../../util/app_constants.dart';
import '../api/api_client.dart';

class SettingsRepo extends SettingRepoInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  SettingsRepo({required this.apiClient, required this.sharedPreferences});

  @override
  updateToken() async {
    String? deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    }else {
      deviceToken = await _saveDeviceToken();
    }
    return await apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "cm_firebase_token": deviceToken});

  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    if(!GetPlatform.isWeb) {
      try {
        deviceToken = await FirebaseMessaging.instance.getToken();
        // ignore: empty_catches
      }catch(e) {}
    }
    if (deviceToken != null) {
      if (kDebugMode) {
        print('--------Device Token---------- $deviceToken');
      }
    }
    return deviceToken;
  }

  @override
  Future<void> removeData() async{
    apiClient.updateHeader(null, AppConstants.LANGUAGE_CODE, null);
    apiClient.token = null;

    if(sharedPreferences.containsKey(AppConstants.TOKEN)){
      await sharedPreferences.remove(AppConstants.TOKEN);
    }
    if(sharedPreferences.containsKey(AppConstants.USER)){
      await sharedPreferences.remove(AppConstants.USER);
    }

  }

  @override
  changeNotificationOption(dynamic value, String? key) async{
    String payload = base64Encode(utf8.encode(jsonEncode({
      'key': key,
      'value': value
    })));
    return await apiClient.getData('${AppConstants.SETTING_CHANGE_URI}/$payload');
  }

  @override
  Future<void> saveToken(token) async{
    await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  @override
  User? getUser() {
    if(sharedPreferences.containsKey(AppConstants.USER)){
      return User.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.USER)!));
    }
    return null;
  }

  @override
  Future<void> saveUser(User user) async{
    await sharedPreferences.setString(AppConstants.USER, jsonEncode(user.toJson()));
  }

}
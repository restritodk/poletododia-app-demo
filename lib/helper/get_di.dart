import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/auth_controller.dart';
import 'package:untitled/data/model/response/user_model.dart';
import 'package:untitled/data/repository/auth_repo.dart';

import '../controllers/community_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/localization_controller.dart';
import '../controllers/root_controller.dart';
import '../controllers/splash_controller.dart';
import '../controllers/theme_controller.dart';
import '../data/api/api_client.dart';
import '../data/model/response/language_model.dart';
import '../data/repository/community_repo.dart';
import '../data/repository/settings_repo.dart';
import '../data/repository/splash_repo.dart';
import '../util/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  User? user;
  if(sharedPreferences.containsKey(AppConstants.USER)){
     user = User.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.USER)!));
  }
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, tokenApi: AppConstants.TOKEN_API, sharedPreferences: Get.find(), user: user));

  // Repository
  Get.lazyPut(() => SplashRepo(apiClient: Get.find()));
  Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => SettingsRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => CommunityRepo(apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => RootController());
  Get.lazyPut(() => NotificationController());
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SettingsController(settingsRepo: Get.find()));
  Get.lazyPut(() => CommunityController(communityRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> jsonLanguage = {};
    mappedJson.forEach((key, value) {
      jsonLanguage[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = jsonLanguage;
  }
  return languages;
}

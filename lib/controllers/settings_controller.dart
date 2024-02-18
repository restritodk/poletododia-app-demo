import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:untitled/data/model/response/app_settings.dart';
import 'package:untitled/data/model/response/notification_model.dart';
import 'package:untitled/data/model/response/user_model.dart';
import 'package:untitled/helper/helpers.dart';
import 'package:untitled/view/base/custom_snackbar.dart';
import '../data/model/response/user_settings.dart';
import '../data/repository/settings_repo.dart';
import '../interfaces/Settings/setting_interface.dart';

class SettingsController extends GetxController implements GetxService, SettingInterface{
  final SettingsRepo settingsRepo;
  SettingsController({required this.settingsRepo});

  AppSettings? _appSettings;
  UserSettings? _userSettings;

  AppSettings? get appSettings => _appSettings;
  UserSettings? get userSettings => _userSettings;

  @override
  void putAppSettings({required AppSettings appSettings}) {
    _appSettings = appSettings;
  }

  @override
  void putUserSettings({required UserSettings userSettings}) {
    _userSettings = userSettings;
  }

  @override
  Future<void> initializeFirebaseMessaging()async {
    if (_appSettings != null) {
      var topics = _appSettings?.topics;
      bool isUserNotNull = _userSettings != null;

      if (topics != null) {
        for (var topic in topics) {
          if (isUserNotNull) {
            List<SettingItem?>? items = _userSettings!.itemsSetting();

            if (items != null) {
              for (var setting in items) {
                if (setting != null && !setting.value! && setting.trigger != null && setting.trigger == topic) {
                  await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
                  continue;
                }
              }
            }
          }
          await FirebaseMessaging.instance.subscribeToTopic(topic);
        }
      }

      if (isUserNotNull) {
        await settingsRepo.updateToken();
      }
    }

  }

  @override
  Future<void> removeFirebaseMessaging() async{
    if(_appSettings != null){
      var topics = _appSettings!.topics;

      for (var topic in topics!){
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      }

    }
  }

  @override
  Future<void> changeNotificationOption(SettingItem settingItem) async {

    try {
      Helpers.setLoading();

      dynamic value = settingItem.value;

      if(value is bool){
        value = !value;
      }

      Response? response = await settingsRepo.changeNotificationOption(value, settingItem.key);

      if (response != null && response.statusCode == 200) {

        settingItem.value = value;

        String? trigger = settingItem.trigger;
        if (trigger != null) {
          if (value) {
            await FirebaseMessaging.instance.subscribeToTopic(trigger);
          } else {
            await FirebaseMessaging.instance.unsubscribeFromTopic(trigger);
          }
        }

        update();
      } else {
        showCustomSnackBar('Não foi possível salvar as alterações!');
      }
    } catch (e) {
      showCustomSnackBar('Ocorreu um erro ao processar a solicitação.');
    } finally {
      Helpers.removeLoading();
    }
  }

   @override
  User? getUser() {
    return settingsRepo.getUser();
  }

}

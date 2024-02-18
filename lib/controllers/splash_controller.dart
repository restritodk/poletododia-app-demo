import 'package:get/get.dart';
import 'package:untitled/controllers/community_controller.dart';
import 'package:untitled/controllers/settings_controller.dart';
import 'package:untitled/data/model/response/app_settings.dart';
import 'package:untitled/helper/route_helper.dart';
import 'package:untitled/view/base/custom_snackbar.dart';

import '../data/model/response/user_model.dart';
import '../data/model/response/user_settings.dart';
import '../data/repository/splash_repo.dart';
import '../interfaces/splash/splash_interface.dart';
import 'notification_controller.dart';

class SplashController extends GetxController implements GetxService, SplashInterface {
  final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  bool _isSuccess = true;
  bool get isSuccess => _isSuccess;

  @override
  Future<void> initializeApp({bool reload = false}) async {
    if(reload){
      _isSuccess = true;
      update();
    }

    Response? response = await splashRepo.initializeSettingsApp();
    _isSuccess = response != null && response.statusCode == 200;

    if (_isSuccess) {
      var settingsController = Get.find<SettingsController>();
      var notificationController = Get.find<NotificationController>();

      var data = response!.body['data'];
      bool isLogged = data!['is_logged'] as bool;

      AppSettings appConfig = AppSettings.fromJson(data['app_settings']);
      settingsController.putAppSettings(appSettings: appConfig);

      if (isLogged) {
        UserSettings userSettings = UserSettings.fromJson(data['user_settings']);
        settingsController.putUserSettings(userSettings: userSettings);
        settingsController.initializeFirebaseMessaging();
        await notificationController.loadingNotification();
        await settingsController.settingsRepo.saveUser(User.fromJson(data['user']));
        Get.find<CommunityController>().listenPosts();
        Get.offAndToNamed(RouteHelper.getHomePageRoute());
      } else {
        settingsController.removeFirebaseMessaging();
        await settingsController.settingsRepo.removeData();
        await notificationController.cleanNotification();
        Get.offAndToNamed(RouteHelper.getSignInRoute());
      }
    } else {
      showCustomSnackBar('Erro com a conexão, tente novamente!');
    }

    update();
  }

}

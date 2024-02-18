import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/settings_controller.dart';
import 'package:untitled/helper/helpers.dart';
import 'package:untitled/helper/route_helper.dart';
import 'package:untitled/interfaces/auth/auth_interface.dart';
import 'package:untitled/view/base/custom_snackbar.dart';

import '../data/model/response/app_settings.dart';
import '../data/model/response/user_model.dart';
import '../data/model/response/user_settings.dart';
import '../data/repository/auth_repo.dart';
import '../util/app_constants.dart';

class AuthController extends GetxController implements GetxService, AuthInterface {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Future<void> initializeLoginServer({required String email, required String password}) async{
    var validate = authRepo.validateCredentials(email: email, password: password);

    if(!validate.isValidated){
      showCustomSnackBar(validate.messageError);
      return;
    }
    Helpers.setLoading();

    Response? response = await authRepo.loginPlugin(email: email, password: password);
    bool isSuccess = response != null && response.statusCode == 200;

    if(isSuccess){
      showCustomSnackBar('Login realizado com sucesso!', isError: false);


      var settingsController = Get.find<SettingsController>();

      var data = response.body['data'];

      AppSettings appConfig = AppSettings.fromJson(data['app_settings']);
      settingsController.putAppSettings(appSettings: appConfig);

      UserSettings userSettings = UserSettings.fromJson(data['user_settings']);
      var user = User.fromJson(data['user']);
      await settingsController.settingsRepo.saveUser(user);
      settingsController.putUserSettings(userSettings: userSettings);

      settingsController.initializeFirebaseMessaging();

      await authRepo.putToken(token: data['token']);
      authRepo.apiClient.updateHeader(data['token'], authRepo.sharedPreferences.getString(AppConstants.LANGUAGE_CODE), user);

      Get.offAndToNamed(RouteHelper.getHomePageRoute());
      Helpers.removeLoading();
      return;
    }

    Helpers.removeLoading();
    showCustomSnackBar(response == null ? 'Não foi possivel realizar o login' : response.bodyString);

  }
}
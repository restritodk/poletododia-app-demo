import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/interfaces/auth/auth_repo_interface.dart';
import 'package:untitled/util/app_constants.dart';

import '../api/api_client.dart';

class AuthRepo implements AuthRepoInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  @override
  Validate validateCredentials({required String email, required String password}) {
    var validate = Validate(isValidated: true, messageError: '');

    if(email.isEmpty){
      validate = Validate(isValidated: false, messageError: 'Entre com o email');
    }
    if(password.isEmpty){
      validate = Validate(isValidated: false, messageError: 'Entre com a senha');
    }

    return validate;
  }

  @override
  Future<void> putToken({required String token}) async{
    await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  @override
  Future<Response?> loginPlugin({required String email, required String password})async {
    Response? response = await apiClient.postData(AppConstants.LOGIN_URI, {
      'email':email,
      'password':password
    });
    return response;
  }
}

class Validate{
  bool isValidated;
  String messageError;

  Validate({required this.isValidated, required this.messageError});
}

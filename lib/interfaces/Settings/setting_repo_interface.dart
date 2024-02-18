import 'package:http/http.dart';
import 'package:untitled/data/model/response/user_model.dart';

abstract class SettingRepoInterface{

  updateToken();

  changeNotificationOption(bool value, String? key);

  Future<void> removeData();

  Future<void> saveToken(token);

  User? getUser();

  Future<void> saveUser(User user);
}
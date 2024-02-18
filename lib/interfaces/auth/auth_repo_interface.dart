import 'package:get/get.dart';

import '../../data/repository/auth_repo.dart';

abstract class AuthRepoInterface{

  Validate validateCredentials({required String email, required String password});

  Future<void> putToken({required String token});

  Future<Response?> loginPlugin({required String email, required String password});
}
import '../../data/model/response/response_model.dart';

abstract class AuthInterface{

  Future<void> initializeLoginServer({required String email, required String password});

}
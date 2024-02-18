import 'package:untitled/data/api/api_client.dart';
import 'package:untitled/interfaces/splash/splash_repo_interface.dart';
import 'package:get/get.dart';
import '../../util/app_constants.dart';

class SplashRepo implements SplashRepoInterface{
  final ApiClient apiClient;
  SplashRepo({required this.apiClient});

  @override
  Future<Response?> initializeSettingsApp() async{
    return await apiClient.getData(AppConstants.INITIALIZE_APP);
  }

}

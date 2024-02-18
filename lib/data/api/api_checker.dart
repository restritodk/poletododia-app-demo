import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../helper/route_helper.dart';
import '../../view/base/custom_snackbar.dart';

class ApiChecker {
  static void checkApi(Response? response) {
    if(response != null && response.statusCode == 401) {
      Get.offAllNamed(RouteHelper.getHomePageRoute());
    }else {
      showCustomSnackBar(response == null ? 'Unable to establish an internet connection!'.tr:response.statusText);
    }
  }
}

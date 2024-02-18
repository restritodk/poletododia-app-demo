import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/splash_controller.dart';

import '../../util/dimensions.dart';
import '../../util/images.dart';
import '../../util/styles.dart';
import 'custom_button.dart';

class NoInternetScreen extends StatelessWidget {
  Function()? onRetry;

  NoInternetScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.no_internet, width: 150, height: 150),
            Text('Oops'.tr, style: robotoBold.copyWith(
              fontSize: 30,
              color:  Colors.white,
            )),
            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              'Sem internet, tente novamente.'.tr,
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 40),
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomButton(
                onPressed: () async {
                  if(onRetry != null){
                    onRetry!();
                    return;
                  }
                  await Get.find<SplashController>().initializeApp(reload: true);
                },
                buttonText: 'Tentar novamente'.tr,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:untitled/view/base/custom_snackbar.dart';
import '../../../controllers/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/cw_elevated_button.dart';
import '../../base/form_login_widget.dart';
import '../Loading_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _canExit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return LoadingScreen(
      onWillPop: ()async{

        if (_canExit) {
          if (GetPlatform.isAndroid) {
            SystemNavigator.pop();
          } else if (GetPlatform.isIOS) {
            exit(0);
          } else {
            Navigator.pushNamed(context, RouteHelper.getSplashRoute());
          }
          return Future.value(false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Back press again to exit!'.tr, style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          ));
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
          return false;
        }
      },
      child: GetBuilder<AuthController>(builder: (controller){

        return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(Images.desfocada_pole_dance).image,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Image.asset('assets/image/logo.png', width: 60, height: 60,),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Bem Vindo',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                FormLoginWidget(controller: controller),
                CwElevatedButton(
                  label: 'Entrar',
                  height: 50,
                  width: 260,
                  onTap: () {
                    controller.initializeLoginServer(email: controller.emailController.text.trim(), password: controller.passwordController.text.trim());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: const Text('Esqueci minha senha'),
                        onPressed: () async {
                          //await controller.redirectExternalPageForgotPassword();
                        },
                      ),
                      TextButton(
                        child: const Text('Me cadastrar'),
                        onPressed: () async {
                          //await controller.redirectExternalPageCreateAccount();
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
        );
      },),
    );
  }


}

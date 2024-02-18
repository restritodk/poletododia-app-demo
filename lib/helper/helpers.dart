import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:untitled/controllers/root_controller.dart';
import 'package:untitled/util/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers{
  static Widget loading({double size = 90, Color colorOne = Colors.deepOrange, Color colorTwo = Colors.orangeAccent, int? animationNumber}) {
    int type = animationNumber??Random().nextInt(20) + 1;
    Widget widget = Center(
      child: LoadingAnimationWidget.twistingDots(
        leftDotColor: colorOne,
        rightDotColor: colorTwo,
        size: size,
      ),
    );
    switch(type){
      case 1:
        widget = Center(
          child: LoadingAnimationWidget.twistingDots(
            leftDotColor: colorOne,
            rightDotColor: colorTwo,
            size: size,
          ),
        );
        break;
      case 2:
        widget = Center(
          child: LoadingAnimationWidget.threeArchedCircle(
    size: size, color: colorOne,
          ),
        );
        break;
      case 3:
        widget = Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            size: size, color: colorOne,
          ),
        );
        break;
      case 4:
        widget = Center(
          child: LoadingAnimationWidget.twoRotatingArc(
            size: size, color: colorOne,
          ),
        );
        break;
      case 5:
        widget = Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            size: size, color: colorOne,
          ),
        );
        break;
      case 6:
        widget = Center(
          child: LoadingAnimationWidget.hexagonDots(
            size: size, color: colorOne,
          ),
        );
        break;
      case 7:
        widget = Center(
          child: LoadingAnimationWidget.fallingDot(
            size: size, color: colorOne,
          ),
        );
        break;
      case 8:
        widget = Center(
          child: LoadingAnimationWidget.dotsTriangle(
            size: size, color: colorOne,
          ),
        );
        break;
      case 9:
        widget = Center(
          child: LoadingAnimationWidget.discreteCircle(
            size: size, color: colorOne,
          ),
        );
        break;
      case 10:
        widget = Center(
          child: LoadingAnimationWidget.bouncingBall(
            size: size, color: colorOne,
          ),
        );
        break;
      case 11:
        widget = Center(
          child: LoadingAnimationWidget.beat(
            size: size, color: colorOne,
          ),
        );
        break;
      case 12:
        widget = Center(
          child: LoadingAnimationWidget.flickr(
            size: size, leftDotColor: colorOne, rightDotColor: colorTwo,
          ),
        );
        break;
      case 13:
        widget = Center(
          child: LoadingAnimationWidget.halfTriangleDot(
            size: size, color: colorOne,
          ),
        );
        break;
      case 14:
        widget = Center(
          child: LoadingAnimationWidget.horizontalRotatingDots(
            size: size, color: colorOne,
          ),
        );
        break;
      case 15:
        widget = Center(
          child: LoadingAnimationWidget.inkDrop(
            size: size, color: colorOne,
          ),
        );
        break;
      case 16:
        widget = Center(
          child: LoadingAnimationWidget.newtonCradle(
            size: size, color: colorOne,
          ),
        );
        break;
      case 17:
        widget = Center(
          child: LoadingAnimationWidget.prograssiveDots(
            size: size, color: colorOne,
          ),
        );
        break;
      case 18:
        widget = Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            size: size, color: colorOne,
          ),
        );
        break;
      case 19:
        widget = Center(
          child: LoadingAnimationWidget.stretchedDots(
            size: size, color: colorOne,
          ),
        );
        break;
      case 20:
        widget = Center(
          child: LoadingAnimationWidget.waveDots(
            size: size, color: colorOne,
          ),
        );
        break;
    }

    return widget;
  }

  static void setLoading() {
    Get.find<RootController>().setLoading();
  }

  static void removeLoading() {
    Get.find<RootController>().removeLoading();
  }

  static replaceArray(String cnpj, List<String> list, replace) {
    for (var element in list) {
      cnpj = cnpj.replaceAll(element, replace);
    }
    return cnpj;
  }

  static bool? toBool(value) {
    if(value is int){
      return value == 1;
    }else if(value is String){
      return value == 'true';
    }else if(value is bool){
      return value;
    }else{
      return false;
    }
  }

  static int parseStringToInt(String qty) {
    if(qty.isEmpty){
      return -1;
    }

    RegExp regex = RegExp(r'\d+(\.\d+)?');
    Iterable<Match> matches = regex.allMatches(qty);

    List<int> numbers = [];
    for (Match match in matches) {
      String numberString = match.group(0)!;
      double number = double.parse(numberString);
      numbers.add(number.toInt());
    }

    return numbers.elementAt(0);
  }

  static formatNumber(String phone) {
    var _ = phone;
    var list = ['(', ')', ' ', '-'];
    for(var i = 0; i < list.length; i++){
      _ = _.replaceAll(list[i], '');
    }
    return _;
  }

  static String? cleanName(String element) {
    var split = [element];

    if(element.contains('_')){
      split = element.split('_');
    }

    var _ = '';
    for (var i=0; i<split.length;i++) {
      var name = split[i];
      if(i == 0){
        _+= '${name.substring(0, 1).toUpperCase()}${name.substring(1, name.length)}';
      }else{
        _+= ' ${name.substring(0, 1).toUpperCase()}${name.substring(1, name.length)}';

      }
    }

    return _;
  }

  static double? toDouble(value) {
    if(value is double){
      return value;
    }else if(value is int){
      return value.toDouble();
    }else if(value is String){
      return double.parse(value);
    }else{
      return 0.0;
    }
  }

  static int toInt(json) {
    if(json == null){
      return 1;
    }
    if(json is int){
      return json;
    }else if(json is double){
      return json.toInt();
    }else if(json is String){
      return int.parse(json);
    }else{
      return 1;
    }
  }

  static Future<String> redirectExternalPageForgotPassword() async {

    const String url = 'https://play.poletododia.com/wp-login.php?action=lostpassword&redirect_to=https%3A%2F%2Fplay.poletododia.com%2F';

    await launchUrl(Uri.parse(url));

    return '';

  }

  static Future<String> redirectExternalPageCreateAccount() async {
    const String url = 'https://poletododia.com/?utm_source=ESPERA_FEVEREIRO24_ORG_PLAY&utm_medium=ORG&utm_campaign=ESPERA_FEVEREIRO24&utm_content=PLAY';

    await launchUrl(Uri.parse(url));

    return '';
  }

  static String uri(String url) {
    return url.replaceAll('http://localhost:8000', AppConstants.BASE_URL);
  }

  static void goBrowser(uri) async{
    Uri url = Uri.parse(uri);
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      );
    }
  }
}
import 'package:get/get.dart';
import 'package:untitled/controllers/community_controller.dart';
import 'package:untitled/data/model/response/comment_model.dart';
import 'package:untitled/data/model/response/post_model.dart';
import 'package:untitled/helper/helpers.dart';
import 'package:untitled/view/screens/auth/sign_in_screen.dart';
import 'package:untitled/view/screens/community/new_post_community_screen.dart';
import 'package:untitled/view/screens/community/post_view_screen.dart';
import 'package:untitled/view/screens/home/home_page_screen.dart';
import 'package:untitled/view/screens/notification/notification_screen.dart';
import 'package:untitled/view/screens/settings/setting_screen.dart';

import '../view/screens/community/comment_view_screen.dart';
import '../view/screens/community/community_screen.dart';
import '../view/screens/splash/splash_screen.dart';

class RouteHelper {
  static const String init = '/';
  static const String splash = '/splash';
  static const String signIn = '/signIn';
  static const String notificationPush = '/notificationPush';
  static const String setting = '/settings';
  static const String community = '/community';
  static const String newPost = '/new-post';
  static const String post = '/post';
  static const String comment = '/comment';

  static String getSplashRoute() => splash;
  static String getHomePageRoute() => init;
  static String getSignInRoute() => signIn;
  static String getSettingsRoute() => setting;
  static String getCommunityRoute() => community;
  static String getNewPostCommunityRoute() => newPost;
  static String getPostCommunityRoute({Post? postModel, int? postId}) {
    if(postModel != null){
      Get.find<CommunityController>().putViewPost(post: postModel);
      return post;
    }
    return '$post?id=$postId';
  }
  static String getCommentCommunityRoute({Comment? commentModel, Post? post, int? commentId}) {
    if(commentModel != null && post != null){
      Get.find<CommunityController>().putViewComment(post: post!, comment: commentModel);
      return comment;
    }
    return '$comment?id=${(commentModel != null ? commentModel.id! : commentId)}';
  }
  static String getNotificationPushRoute({String? notificationID}) => '$notificationPush?notificationID=$notificationID';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: init, page: () => const HomePageScreen()),
    GetPage(name: signIn, page: () => const SignInScreen()),
    GetPage(name: setting, page: () => const SettingsScreen()),
    GetPage(name: community, page: () => const CommunityScreen()),
    GetPage(name: newPost, page: () => const NewPostCommunityScreen()),
    GetPage(name: post, page: () => PostViewScreen(postId: Helpers.toInt(Get.parameters['id'] ?? '0'))),
    GetPage(name: comment, page: () => CommentViewScreen(commentId: Helpers.toInt(Get.parameters['id'] ?? '0'))),
    GetPage(name: notificationPush, page: () => NotificationScreen(notificationID: Get.parameters['notificationID'],)),
  ];

  static String getHtmlRoute(String s) {return'';}
}
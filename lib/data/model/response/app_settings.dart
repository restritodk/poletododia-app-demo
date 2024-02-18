import 'category.dart';

class AppSettings{
  List<String>? topics;
  String? urlPageForgotPassword, urlPageCreateAccount;
  List<Category>? categories;

  AppSettings({required this.topics});

  AppSettings.fromJson(json){
    topics = List.from(json['topics_firebase']).map((e) => e.toString()).toList();
    urlPageCreateAccount = json['url_page_create_account'];
    urlPageForgotPassword = json['url_page_forgot_password'];
    if(json['categories'] != null){
      categories = List.from(json['categories']).map((e) => Category.fromJson(e)).toList();
    }
  }
}
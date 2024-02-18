import '../data/model/response/language_model.dart';
import 'images.dart';

class AppConstants {
  static const String APP_NAME = 'Pole Todo Dia';
  static const int APP_VERSION = 1;

  static const String BASE_URL = 'https://www.notifications.poletododia.com';
  static const String BASE_URL_WP = 'https://play.poletododia.com';
  static const String TOKEN_API = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3BsYXkucG9sZXRvZG9kaWEuY29tIiwiaWF0IjoxNzAzMzYzMDEzLCJuYmYiOjE3MDMzNjMwMTMsImV4cCI6MTcwMzk2NzgxMywiZGF0YSI6eyJ1c2VyIjp7ImlkIjoiMTE4NiJ9fX0.hn1k3GdZ3PMrcDXIPa2QdprJaXh_PuYza63zLOJ5U34';

  static const String LOGIN_URI = '/api/login/auth';
  static const String TOKEN_URI = '/api/customer/setting/cm-firebase-token';
  static const String INITIALIZE_APP = '/api/customer/setting/initialize-app';
  static const String SETTING_CHANGE_URI = '/api/customer/setting/change-setting-user';
  static const String LISTEN_POSTS = '/api/community/posts';
  static const String GET_POST = '/api/community/post';
  static const String LISTEN_COMMENTS = '/api/community/comments';
  static const String GET_COMMENT = '/api/community/comment';
  static const String CREATE_NEW_POST = '/wp-json/wp/v2/community-insert-post';
  static const String CREATE_NEW_COMMENT = '/wp-json/wp/v2/community-insert-comment';
  static const String DELETE_POST = '/wp-json/wp/v2/community-delete-post';
  static const String DELETE_COMMENT = '/wp-json/wp/v2/community-delete-comment';
  static const String LIKE_ACTION = '/wp-json/wp/v2/community-like-request';

  // Shared Key
  static const String THEME = 'soft_theme';
  static const String TOKEN = 'token';
  static const String LANGUAGE = 'language_key';
  static const String LANGUAGE_CODE = 'soft_language';
  static const String COUNTRY_CODE = 'soft_country';
  static const String LOCALIZATION_KEY = 'X-localization';
  static const String USER = 'user_model';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.logo, languageName: 'Português', countryCode: 'BR', languageCode: 'pt'),
  ];

}
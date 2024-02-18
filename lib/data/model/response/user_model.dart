import 'package:untitled/helper/helpers.dart';

class User{
  int? id;
  String? avatar, userEmail, displayName;

  User.fromJson(json) {
    id = Helpers.toInt(json['ID']);
    avatar = json['avatar'];
    userEmail = json['user_email'];
    displayName = json['display_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'ID':id,
      'avatar':avatar,
      'user_email':userEmail,
      'display_name':displayName
    };
  }

}
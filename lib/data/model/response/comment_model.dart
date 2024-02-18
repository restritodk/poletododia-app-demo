import 'package:jiffy/jiffy.dart';
import 'package:untitled/data/model/response/user_model.dart';
import 'package:untitled/helper/helpers.dart';

class Comment{
  int? id, postId;
  DateTime? commentDate;
  String? content;
  bool? isMyComment, like;
  User? user;

  Comment.fromJson(json){
    id = Helpers.toInt(json['ID']);
    postId = Helpers.toInt(json['post_id']);
    content = json['content'].toString();
    commentDate = DateTime.tryParse(json['comment_date']);
    isMyComment = Helpers.toBool(json['is_my_comment']);
    like = Helpers.toBool(json['like']);
    user = User.fromJson(json['user']);
  }

  String getDataComment() {
    Jiffy.setLocale('pt_BR');
    return Jiffy.parseFromDateTime(commentDate!).format(pattern: 'd MMMM, y');
  }
}
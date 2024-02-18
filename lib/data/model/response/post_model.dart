import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:untitled/data/model/enum/archive_type.dart';
import 'package:untitled/data/model/response/user_model.dart';
import 'package:untitled/helper/helpers.dart';
import 'package:untitled/view/base/custom_image.dart';

import 'comment_model.dart';

class PostModel{
  int? totalSize, limit, offset;
  List<Post>? posts;

  PostModel.fromJson(json){
    totalSize = Helpers.toInt(json['total_size']);
    limit = Helpers.toInt(json['limit']);
    offset = Helpers.toInt(json['offset']);
    if(json['posts'] != null){
      posts = List.from(json['posts']).map((e) => Post.fromJson(e)).toList();
    }
  }
}

class Post{
  bool isPlayVideoInit = false;
  var commentController = TextEditingController();

  int? id, commentsCount;
  String? title, content, category;
  DateTime? postDate;
  Media? media;
  bool? like, isMyPost;
  User? author;
  bool _loading = true;
  List<Comment>? _comments;

  bool get isLoading => _loading;

  List<Comment>? get comments => _comments;

  bool get hasComments => _comments != null ? _comments!.isNotEmpty : false;

  bool isCommentPanelVisible = false;

  Post.fromJson(json){
    id = Helpers.toInt(json['ID']);
    commentsCount = Helpers.toInt(json['comments_count']);
    title = json['title'].toString();
    content = json['content'].toString();
    category = json['category'] ?? 'not_found';
    postDate = DateTime.tryParse(json['post_date']);
    if(json['media'] != null){
      media = Media.fromJson(json['media']);
    }
    like = Helpers.toBool(json['like']);
    isMyPost = Helpers.toBool(json['is_my_post']);
    author = User.fromJson(json['author']);
    
    
  }

  String getDataString() {
    Jiffy.setLocale('pt_BR');
    return Jiffy.parseFromDateTime(postDate!).format(pattern: 'd MMMM, y');
  }

  Widget getMediaWidget() {
    return CustomImage(image: media!.url!);
  }

  void setLoadingComments() {
    _loading = true;
  }

  void setComments(data) {
    if(data == null){
      _comments = null;
      return;
    }
    _comments = [];
    _comments = List.from(data).map((e) => Comment.fromJson(e)).toList();
    _loading = false;
  }

  void removeComment(int id) {
    _comments!.removeWhere((element) => element.id == id);
  }

}

class Media{
  ArchiveType? type;
  String? url;

  Media.fromJson(json){
    if(json == null){
      return;
    }
    url = json['url'];
    type = ArchiveType.values.byName(json['type_media']);
  }
}
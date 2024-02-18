import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/enum/archive_type.dart';
import '../../data/model/enum/like_event.dart';
import '../../data/model/enum/like_type.dart';
import '../../data/model/response/post_model.dart';
import '../../data/model/response/user_model.dart';

abstract class CommunityRepoInterface{

  //Postagens
  Future<Response?> getListPosts({int offset = 1});

  Future<Response?> getPost({required int id});

  Future<Response?> createNewPost({required int category, required String title, required String content, ArchiveType? archiveType, XFile? archive});

  Future<Response?> deletePost({required int id});

  //Comentários
  Future<Response?> getListComments({required int postId, int? limit, int? offset});

  Future<Response?> getComment({required int id});

  Future<Response?> createNewComment({required String content, required int postId});

  Future<Response?> deleteComment({required int commentId});

  //Curitr e desfazer curtida
  Future<Response?> like({required LikeType type, required LikeEvent event, required int refId, required User user});
}
import 'package:untitled/data/model/response/post_model.dart';

import '../../data/model/response/comment_model.dart';

abstract class CommunityInterface{

  Future<void> listenPosts({bool notify = false, int offset = 1});

  Future<void> onLikeAction({Post? post, Comment? comment});

  Future<void> listenComments({required Post post});

  void showDialogDeleteComment({required Comment comment, Post? post});

  Future<void> deleteComment({required Comment comment, Post? post});

  void showDialogDeletePost({required int id});

  Future<void> deletePost({required int id});

  Future<void> createNewComment({required Post post, required String content});

  void selectArchive();

  Future<void> getPost({required int id, bool refresh = false});

  Future<void> getComment({required int id, bool refresh = false});

  void putViewPost({required Post post});

  void putViewComment({required Post post, required Comment comment});

  Future<void> onPublish({required String title, required String content});

}
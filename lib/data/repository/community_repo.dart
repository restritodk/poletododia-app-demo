import 'package:image_picker/image_picker.dart';
import 'package:untitled/data/api/api_client.dart';
import 'package:untitled/data/model/enum/archive_type.dart';
import 'package:untitled/data/model/enum/like_event.dart';
import 'package:untitled/data/model/enum/like_type.dart';
import 'package:untitled/data/model/response/user_model.dart';
import 'package:get/get.dart';
import 'package:untitled/util/app_constants.dart';
import '../../interfaces/community/community_repo_interface.dart';

class CommunityRepo implements CommunityRepoInterface{
  final ApiClient apiClient;
  CommunityRepo({required this.apiClient});

  @override
  Future<Response?> createNewPost({required int category, required String title, required String content, ArchiveType? archiveType, XFile? archive}) async{
    Map<String, String> body = {
      'category':category.toString(),
      'title':title,
      'message':content
    };
    if(archive != null){
      body['tipoarchive'] = archiveType!.name;
      return await apiClient.postMultipartData(AppConstants.CREATE_NEW_POST, body, MultipartBody('archive', archive), isUseWpRoute: true);
    }
    return await apiClient.postData(AppConstants.CREATE_NEW_POST, body, isUseWpRoute: true);
  }

  @override
  Future<Response?> deleteComment({required int commentId}) async{
    return await apiClient.deleteData('${AppConstants.DELETE_COMMENT}?comment=$commentId', isUseWpRoute: true);
  }

  @override
  Future<Response?> deletePost({required int id}) async{
    return await apiClient.deleteData('${AppConstants.DELETE_POST}?rel_id=$id&rel_type=post', isUseWpRoute: true);
  }

  @override
  Future<Response?> getComment({required int id}) async{
    return await apiClient.getData('${AppConstants.GET_COMMENT}/$id');
  }

  @override
  Future<Response?> getListComments({required int postId, int? limit, int? offset}) async{
    var query = '';
    if(limit != null && offset != null){
      query = '?limit=$limit&offset=$offset';
    }

    return await apiClient.getData('${AppConstants.LISTEN_COMMENTS}/$postId$query');
  }

  @override
  Future<Response?> getListPosts({int offset = 1}) async{
    return await apiClient.getData('${AppConstants.LISTEN_POSTS}?limit=20&offset=$offset');
  }

  @override
  Future<Response?> getPost({required int id}) async{
    return await apiClient.getData('${AppConstants.GET_POST}/$id');
  }

  @override
  Future<Response?> like({required LikeType type, required LikeEvent event, required int refId, required User user}) async{
    return await apiClient.postData(AppConstants.LIKE_ACTION, {
      "author_id":user.id,
      "post_id": refId,
      "type":type.name,
      "event":event.name
    }, isUseWpRoute: true);
  }

  @override
  Future<Response?> createNewComment({required String content, required int postId})async {
    return await apiClient.postData(AppConstants.CREATE_NEW_COMMENT, {
      "post_id": postId,
      "message": content,
      "author_id":apiClient.user!.id
    }, isUseWpRoute: true);
  }

}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/controllers/settings_controller.dart';
import 'package:untitled/data/model/enum/archive_type.dart';
import 'package:untitled/data/model/enum/like_event.dart';
import 'package:untitled/data/model/enum/like_type.dart';
import 'package:untitled/data/model/enum/page_state.dart';
import 'package:untitled/data/model/response/category.dart';
import 'package:untitled/data/model/response/comment_model.dart';
import 'package:untitled/helper/helpers.dart';
import 'package:untitled/view/base/custom_snackbar.dart';

import '../data/api/api_checker.dart';
import '../data/model/response/post_model.dart';
import '../data/repository/community_repo.dart';
import '../interfaces/community/community_interface.dart';

class CommunityController extends GetxController implements GetxService, CommunityInterface {
  final CommunityRepo communityRepo;

  CommunityController({required this.communityRepo});

  final ImagePicker _picker = ImagePicker();
  PostModel? _postModel;
  List<Post>? _posts;
  List<int> _offsetList = [];
  bool _paginate = false;
  int? _pageSize;
  XFile? archive;
  Post? _post;
  Comment? _comment;
  int _offset = 1;
  Category? _category = null;
  Category? get category => _category;
  ArchiveType? _archiveType = ArchiveType.foto;
  ArchiveType? get archiveType => _archiveType;

  PostModel? get postModel => _postModel;

  List<Post>? get posts => _posts;
  bool get paginate => _paginate;
  int? get pageSize => _pageSize;
  int get offset => _offset;
  Post? get post => _post;
  Comment? get comment => _comment;
  PageState postPageState = PageState.loading;
  PageState commentPageState = PageState.loading;

  List<ArchiveType> get archivesTypes => [
    ArchiveType.foto,
    ArchiveType.video,
  ];

  @override
  Future<void> listenPosts({bool notify = false, int offset = 1}) async {
    _offset = offset;
    if (offset == 1 || _posts == null) {

      // _posts = null;
      _offset = 1;
      _offsetList = [];
      if (notify) {
        update();
      }
    }

    if (!_offsetList.contains(offset)){
      _offsetList.add(offset);
      Response? response = await communityRepo.getListPosts(offset: offset);
      bool isSuccess = response != null && response.statusCode == 200;
      if (isSuccess) {
        if (offset == 1) {
          _posts = [];
        }
        _postModel = PostModel.fromJson(response.body['data']);
        _posts!.addAll(_postModel!.posts!);
        _pageSize = _postModel!.totalSize;
        _paginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    }
    else {
      if(_paginate) {
        _paginate = false;
        update();
      }
    }

  }

  @override
  Future<void> listenComments({required Post post}) async{

    post.setLoadingComments();
    update();

    var response = await communityRepo.getListComments(postId: post.id!);
    bool isSuccess = response != null && response.statusCode == 200;

    if(isSuccess){
      var data = response.body['data'];
      post.setComments(data);
    }else{
      post.setComments(null);
    }

    update();
  }

  @override
  Future<void> onLikeAction({Post? post, Comment? comment}) async{
    var user = Get.find<SettingsController>().getUser();

    bool isLike = post != null ? post.like! : comment!.like!;
    int id = 0;
    LikeType type;
    if(post != null){
      post.like = !isLike;
      id = post.id!;
      type = LikeType.post;
    }else{
      comment!.like = !isLike;
      id = comment.id!;
      type = LikeType.comment;
    }
    update();
    var response = await communityRepo.like(type: type, event: isLike ? LikeEvent.unliked : LikeEvent.liked, refId: id, user: user!);

    bool isSuccess = response != null && response.statusCode == 200;

    if(!isSuccess){
      if(post != null){
        post.like = !post.like!;
      }else{
        comment!.like = !comment.like!;
      }
      showCustomSnackBar('Não foi possivel realizar a curtida');
      update();
    }
  }

  @override
  void showDialogDeleteComment({required Comment comment, Post? post}) async{
    showDialog(context: Get.context!, builder: (context){
      return AlertDialog(
        title: const Text('Atênção'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Realmente deseja apagar seu comentário?')
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
          TextButton(onPressed: () => deleteComment(comment: comment, post: post!), child: const Text('Apagar', style: TextStyle(color: Colors.red),)),
        ],
      );
    });
  }

  @override
  Future<void> deleteComment({required Comment comment, Post? post}) async{
    Get.back();
    Helpers.setLoading();

    var response = await communityRepo.deleteComment(commentId: comment.id!);
    bool isSuccess = response != null && response.statusCode == 200;

    if(isSuccess){
      if(post != null){
        post.removeComment(comment.id!);
      }
      showCustomSnackBar('Comentário apagado com sucesso!', isError: false);
    }else{
      showCustomSnackBar('Não foi possivel apagar seu Comentário, tente novamente!');
    }
    update();
    Helpers.removeLoading();
  }

  @override
  Future<void> deletePost({required int id}) async{
    Get.back();
    Helpers.setLoading();

    var response = await communityRepo.deletePost(id: id);
    bool isSuccess = response != null && response.statusCode == 200;

    if(isSuccess){
      _posts!.removeWhere((element) => element.id == id);
      _postModel!.posts!.removeWhere((element) => element.id == id);
      showCustomSnackBar('Postagem apagada com sucesso!', isError: false);
    }else{
      showCustomSnackBar('Não foi possivel apagar sua postagem, tente novamente!');
    }
    update();
    Helpers.removeLoading();
  }

  @override
  void showDialogDeletePost({required int id}) {
    showDialog(context: Get.context!, builder: (context){
      return AlertDialog(
        title: const Text('Atênção'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Realmente deseja apagar sua postagem?')
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
          TextButton(onPressed: () => deletePost(id: id), child: const Text('Apagar', style: TextStyle(color: Colors.red),)),
        ],
      );
    });
  }

  @override
  Future<void> createNewComment({required Post post, required String content}) async{

    if(content.isEmpty){
      showCustomSnackBar('Escreva algo para publicar!');
      return;
    }

    Helpers.setLoading();
    var response = await communityRepo.createNewComment(content: content, postId: post.id!);
    bool isSuccess = response != null && response.statusCode == 200;

    if(isSuccess){
      showCustomSnackBar('Comentário publicado com sucesso!', isError: false);
      post.commentsCount = post.commentsCount!+1;
      await listenComments(post: post);
    }else{
      showCustomSnackBar('Não foi possivel adicionar seu comentário, tente novamente!');
    }

    update();
    Helpers.removeLoading();
  }

  List<Category> get categories => Get.find<SettingsController>().appSettings!.categories!;

  void setCategory(Category? newValue) {
    _category = newValue!;
    update();
  }

  void setArchiveType(ArchiveType? newValue) {
    if(_archiveType != newValue && archive != null){
      archive = null;
      showCustomSnackBar('Arquivo removido, escolha agora ${newValue!.name}');
    }
    _archiveType = newValue!;
    update();
  }

  @override
  void selectArchive() async{
    ImageSource source = ImageSource.gallery;
    if(_archiveType == ArchiveType.video){

      archive = await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 10));

    }else{
      archive = await _picker.pickImage(
          source: source);

    }
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showFoodBottomLoader() {
    _paginate = true;
    update();
  }

  @override
  Future<void> getPost({required int id, bool refresh = false}) async{
    if(refresh){
      loadingPagePost();
      update();
    }
    var response = await communityRepo.getPost(id: id);
    var isSuccess = response != null && response.statusCode == 200;

    if(isSuccess){
      postPageState = PageState.finish;
      _post = Post.fromJson(response.body['data']);
      update();
      return;
    }
    postPageState = PageState.failure;
    _post = null;
    update();

  }

  void loadingPagePost({bool finishIfLoading = false}) {
    if(postPageState != PageState.loading){
      postPageState = PageState.loading;
    }
    if(finishIfLoading){
      if(postPageState == PageState.loading){
        postPageState = PageState.finish;
      }
    }
  }

  void loadingPageComment({bool finishIfLoading = false}) {
    if(commentPageState != PageState.loading){
      commentPageState = PageState.loading;
    }
    if(finishIfLoading){
      if(commentPageState == PageState.loading){
        commentPageState = PageState.finish;
      }
    }
  }

  @override
  Future<void> getComment({required int id, bool refresh = false}) async{
    if(refresh){
      loadingPageComment();
      update();
    }
    var response = await communityRepo.getComment(id: id);
    var isSuccess = response != null && response.statusCode == 200;

    if(isSuccess){
      commentPageState = PageState.finish;
      _comment = Comment.fromJson(response.body['data']);
      update();
      return;
    }
    commentPageState = PageState.failure;
    _comment = null;
    update();
  }

  @override
  void putViewComment({required Post post, required Comment comment}) {
    _post = post;
    _comment = comment;
  }

  @override
  void putViewPost({required Post post}) {
    _post = post;
  }

  @override
  Future<void> onPublish({required String title, required String content}) async{
    if(title.isEmpty){
      showCustomSnackBar('Digite um titulo');
      return;
    }

    if(content.isEmpty){
      showCustomSnackBar('Digite o conteudo da sua postagem');
      return;
    }

    Helpers.setLoading();
    _category ??= categories.elementAt(0);
    var response = await communityRepo.createNewPost(title: title, category: _category!.id!, content: content, archiveType: _archiveType, archive: archive);
    bool isSuccess = response != null && response.statusCode == 200;
    if(isSuccess){
      await listenPosts(offset: _offset);
      showCustomSnackBar('Postagem criada com sucesso!', isError: false);
      Get.back();

    }else{
      showCustomSnackBar('Não foi possivel criar sua postagem, tente novamente!');
    }
    Helpers.removeLoading();
  }
}
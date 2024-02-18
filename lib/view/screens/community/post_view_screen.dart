import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/community_controller.dart';
import 'package:untitled/data/model/enum/page_state.dart';
import 'package:untitled/helper/helpers.dart';
import 'package:untitled/view/screens/Loading_screen.dart';
import 'package:untitled/view/screens/community/widget/card_post_view_widget.dart';

import '../../base/no_internet_screen.dart';

class PostViewScreen extends StatefulWidget{
  int? postId;

  PostViewScreen({super.key, this.postId});

  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {

  @override
  void initState() {
    if(widget.postId != 0){
      Get.find<CommunityController>().loadingPagePost();
      setState(() {

      });
      Get.find<CommunityController>().getPost(id: widget.postId!);
    }else{
      Get.find<CommunityController>().loadingPagePost(finishIfLoading: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        appBar: AppBar(
          title: const Text('Postagem'),
          centerTitle: true,
        ),
        child: GetBuilder<CommunityController>(builder: (controller){
      switch(controller.postPageState){

        case PageState.loading:
          return Center(
            child: Helpers.loading(),
          );
        case PageState.finish:
          return SingleChildScrollView(child: CardPostViewWidget(post: controller.post!, controller: controller),);
        case PageState.failure:
          return NoInternetScreen(
            onRetry: (){
              controller.getPost(id: widget.postId == 0 ? controller.post!.id! : widget.postId!, refresh: true);
            },
          );
      }
    },));
  }
}
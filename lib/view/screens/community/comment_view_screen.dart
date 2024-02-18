import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/view/screens/community/widget/card_comment_view_widget.dart';

import '../../../controllers/community_controller.dart';
import '../../../data/model/enum/page_state.dart';
import '../../../helper/helpers.dart';
import '../../base/no_internet_screen.dart';
import '../Loading_screen.dart';

class CommentViewScreen extends StatefulWidget{
  int? commentId;

  CommentViewScreen({super.key, this.commentId});

  @override
  State<CommentViewScreen> createState() => _CommentViewScreenState();
}

class _CommentViewScreenState extends State<CommentViewScreen> {
  @override
  void initState() {
    if(widget.commentId != 0){
      Get.find<CommunityController>().loadingPageComment();
      setState(() {

      });
      Get.find<CommunityController>().getComment(id: widget.commentId!);
    }else{
      Get.find<CommunityController>().loadingPageComment(finishIfLoading: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        appBar: AppBar(
          title: const Text('Comentário'),
          centerTitle: true,
        ),
        child: GetBuilder<CommunityController>(builder: (controller){
          switch(controller.commentPageState){

            case PageState.loading:
              return Center(
                child: Helpers.loading(),
              );
            case PageState.finish:
              return SingleChildScrollView(child: CardCommentViewWidget(post: controller.post!, controller: controller, comment: controller.comment!,),);
            case PageState.failure:
              return NoInternetScreen(
                onRetry: (){
                  controller.getComment(id: widget.commentId == 0 ? controller.comment!.id! : widget.commentId!, refresh: true);
                },
              );
          }
        },));
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/community_controller.dart';
import 'package:untitled/data/model/response/comment_model.dart';
import 'package:untitled/data/model/response/post_model.dart';
import 'package:untitled/helper/route_helper.dart';
import 'package:untitled/view/screens/community/widget/video_card_widget.dart';

import '../../../../data/model/enum/archive_type.dart';
import '../../../../helper/helpers.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_image.dart';
import '../../../base/custom_text_field.dart';
import 'card_comment_view_widget.dart';

class CardPostViewWidget extends StatefulWidget{
  final Post post;
  final CommunityController controller;
  const CardPostViewWidget({super.key, required this.post, required this.controller});

  @override
  State<CardPostViewWidget> createState() => _CardPostViewWidgetState();
}

class _CardPostViewWidgetState extends State<CardPostViewWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getPostCommunityRoute(postModel: widget.post)),
      child: Padding(
        padding: const EdgeInsets.symmetric(),
        child: Card(
          color: Colors.white,
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(widget.post.author!.displayName!, style: const TextStyle(color: Colors.black),),
                subtitle: Text(widget.post.category!, style: const TextStyle(color: Colors.deepOrange),),
                leading: CustomImage(
                  image: widget.post.author!.avatar!,
                  width: 45,
                  height: 45,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(widget.post.getDataString())),
                    if(widget.post.isMyPost!)
                      TextButton(
                        onPressed: () => widget.controller.showDialogDeletePost(id: widget.post.id!),
                        child: const Text('Excluir', style: TextStyle(color: Colors.red),),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: HtmlWidget(widget.post.content!, customStylesBuilder: (element){
                    if (element.classes.contains('mentiony-link')) {
                      return {'color': 'orange'};
                    }

                    return null;
                  },),
                ),
              ),

              if(widget.post.media != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: widget.post.media!.type == ArchiveType.video ? VideoCardWidget(videoUrl: widget.post.media!.url!,) : widget.post.getMediaWidget(),
                ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Expanded(child: CustomButton(
                      buttonText: widget.post.like! ? 'Gostei' : 'Curtir',
                      onPressed: () async => widget.controller.onLikeAction(post: widget.post),
                      backgroundColor: widget.post.like! ? Colors.deepOrange : Colors.transparent,
                      foregroundColor: widget.post.like! ? Colors.white : Colors.deepOrange,
                      withBorder: !widget.post.like!,
                      radius: 100,
                    )),
                    Expanded(child: TextButton(
                      onPressed: () async{
                        widget.post.isCommentPanelVisible = !widget.post.isCommentPanelVisible;
                        setState(() {

                        });
                        if(widget.post.isCommentPanelVisible){
                          await widget.controller.listenComments(post: widget.post);

                        }

                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${widget.post.commentsCount} ${'comment'.trPlural('comments', widget.post.commentsCount)}', style: const TextStyle(
                              color: Colors.deepOrange
                          ),),
                          const SizedBox(width: 10,),
                          Icon(widget.post.isCommentPanelVisible ? Icons.arrow_drop_up_outlined : Icons.arrow_drop_down, color: Colors.deepOrange,)
                        ],
                      ),
                    ))
                  ],
                ),
              ),

              if(widget.post.isCommentPanelVisible)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(widget.post.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: Helpers.loading(size: 40),),
                      )
                    else
                      if(widget.post.hasComments)
                        Column(
                          children: [
                            Column(children: _commentsList().map((comment) => CardCommentViewWidget(post: widget.post, comment: comment, controller: widget.controller,)).toList(),),
                            if(widget.post.comments!.length > 3)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Center(
                                  child: TextButton(
                                    child: Text('Mais ${widget.post.comments!.length} comentários...'),
                                    onPressed: () => _openMoreComments(),
                                  ),
                                ),
                              ),
                          ],
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                          child: Center(
                            child: Text('Não há comentãrios', textAlign: TextAlign.center,),
                          ),
                        ),

                    Card(
                      child: Column(children: [
                        Card(
                          elevation: 5,
                          color: Colors.grey[200],
                          child: Column(
                            children: [
                              Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CustomTextField(
                                  controller: widget.post.commentController,
                                  maxLines: 5,
                                  showTitle: false,
                                  hintText: 'Escreva seu comentário',
                                  capitalization: TextCapitalization.sentences,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: CustomButton(
                                  buttonText: 'Publicar',
                                  onPressed: () => widget.controller.createNewComment(post: widget.post, content: widget.post.commentController.text.trim()),
                                  radius: 50,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],),
                    )
                  ],
                ),

              const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

  List<Comment> _commentsList() {
    if(widget.post.comments!.length > 3){
      return widget.post.comments!.sublist(0, 3);
    }
    return widget.post.comments!;
  }

  void _openMoreComments() {
    showModalBottomSheet(
      context: Get.context!,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(Get.context!).size.height - 50,
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: Center(
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Container(
                color: const Color(0xFFF7F9FA),
                child: Column(children: widget.post.comments!.map((comment) => CardCommentViewWidget(post: widget.post, comment: comment, controller: widget.controller)).toList()),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        );
      },
    );
  }
}
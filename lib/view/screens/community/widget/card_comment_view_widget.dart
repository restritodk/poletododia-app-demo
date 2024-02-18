import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:untitled/helper/route_helper.dart';

import '../../../../controllers/community_controller.dart';
import '../../../../data/model/response/comment_model.dart';
import '../../../../data/model/response/post_model.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_image.dart';

class CardCommentViewWidget extends StatelessWidget{
  Post? post;
  final Comment comment;
  final CommunityController controller;

  CardCommentViewWidget({super.key, this.post, required this.comment, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getCommentCommunityRoute(commentModel: comment, post: post!)),
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
                title: Text(comment.user!.displayName!, style: const TextStyle(color: Colors.black),),
                subtitle: Text(comment.getDataComment(), style: const TextStyle(color: Colors.deepOrange),),
                leading: CustomImage(
                  image: comment.user!.avatar!,
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
                      if(comment.isMyComment!)
                        TextButton(
                          onPressed: () => controller.showDialogDeleteComment(comment: comment, post: post),
                          child: const Text('Excluir', style: TextStyle(color: Colors.red),),
                        ),
                    ]
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
                  child: HtmlWidget(comment.content!, customStylesBuilder: (element){
                    if (element.classes.contains('mentiony-link')) {
                      return {'color': 'orange'};
                    }

                    return null;
                  },),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: MediaQuery.of(context).size.width/2.8,
                child: CustomButton(
                  buttonText: comment.like! ? 'Gostei' : 'Curtir',
                  onPressed: () async => controller.onLikeAction(comment: comment),
                  backgroundColor: comment.like! ? Colors.deepOrange : Colors.transparent,
                  foregroundColor: comment.like! ? Colors.white : Colors.deepOrange,
                  withBorder: !comment.like!,
                  radius: 100,
                ),
              ),

              const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
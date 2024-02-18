import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/community_controller.dart';
import 'package:untitled/helper/helpers.dart';
import 'package:untitled/helper/route_helper.dart';
import 'package:untitled/view/screens/Loading_screen.dart';
import 'package:untitled/view/screens/community/widget/card_post_view_widget.dart';

class CommunityScreen extends StatefulWidget{
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _controller = ScrollController();

  @override
  void initState() {
    var controller =Get.find<CommunityController>();
    controller.listenPosts();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent
          && controller.posts != null
          && !controller.paginate) {
        int pageSize = (controller.pageSize! / 10).ceil();

        if (controller.offset < pageSize) {
          controller.setOffset(controller.offset+1);
          controller.showFoodBottomLoader();
          controller.listenPosts(offset: controller.offset);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        appBar: AppBar(
          title: const Text('Comunidade'),
          actions: [
            TextButton(
                onPressed: () => Get.toNamed(RouteHelper.getNewPostCommunityRoute()),
                child: const Text('Nova postagem')
            )
          ],
        ),
        child: GetBuilder<CommunityController>(builder: (controller){
          return RefreshIndicator(child: controller.posts == null ? Center(
            child: Helpers.loading(),
          ) : CustomScrollView(
            controller: _controller,
            slivers: [
              SliverList(delegate: SliverChildBuilderDelegate((c, index){
                var post = controller.posts!.elementAt(index);
                return CardPostViewWidget(post: post, controller: controller,);
              }, childCount: controller.posts!.length)),
              if(controller.paginate)
                const SliverToBoxAdapter(child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),)
            ],
          ), onRefresh: ()async{
            await controller.listenPosts();
          });
        },));
  }

}
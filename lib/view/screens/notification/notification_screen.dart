import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/notification_controller.dart';
import 'package:untitled/data/model/response/notification_model.dart';
import 'package:untitled/helper/helpers.dart';
import 'package:untitled/helper/route_helper.dart';
import 'package:untitled/view/base/custom_button.dart';
import 'package:untitled/view/screens/Loading_screen.dart';

import '../../../util/styles.dart';

class NotificationScreen extends StatefulWidget{
  String? notificationID;

  NotificationScreen({super.key, this.notificationID});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with WidgetsBindingObserver{

  @override
  void initState() {
    Get.find<NotificationController>().cleanReadNotifications();
    Get.find<NotificationController>().loadingNotification();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<NotificationController>().loadingNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if(widget.notificationID != null){
                Get.offAndToNamed(RouteHelper.getSplashRoute());
                return;
              }
              Get.back();
            },
          ),
          title: const Text('Notificações'),
        ),
        child: SafeArea(child: GetBuilder<NotificationController>(builder: (controller){
          var notifications = controller.notifications ?? [];
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (c, index){
              var notification = notifications.elementAt(index);

              return InkWell(
                onTap: () => onViewNotification(notification, controller),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 20,
                            width: 0.8,
                            color: Colors.black,
                          ),
                          const SizedBox(height:2,),
                          const Icon(Icons.notifications, color: Colors.yellow,),
                          const SizedBox(height:2,),
                          Container(
                            height: _notificationHeight(notification),
                            width: 0.8,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10,),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.title!, style: const TextStyle(
                              fontSize: 16, color: Colors.black87
                          ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                          Text(notification.body!, style: const TextStyle(
                              fontSize: 14, color: Colors.black54
                          ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                          if(notification.link != '')
                            TextButton(
                              onPressed: () => Helpers.goBrowser(notification.link),
                              child: const Text('Abrir link'),
                            ),
                          if(notification.image != '')
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Image.file(File(notification.image!), height: 220,),
                            )
                        ],)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () async => await controller.deleteNotification(notification),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },),));
  }

  double _notificationHeight(NotificationModel notification) {
    double _ = 30.0;
    if(notification.link != ''){
      _ += 30;
    }
    if(notification.image != ''){
      _ += 220;
    }

    return _;
  }

  onViewNotification(NotificationModel notification, NotificationController controller) {
    showModalBottomSheet(context: Get.context!, builder: (context){
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Center(
              child: Container(
                width: 50,
                height: 2,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20,),
            if(notification.image! != '')
              SizedBox(
                width: double.maxFinite,
                height: 139,
                child: Image.file(File(notification.image!)),
              ),
            const SizedBox(height: 20,),
            if(notification.link != '')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomButton(
                    buttonText: 'Abrir link',
                    onPressed: () {
                      Get.back();
                      Helpers.goBrowser(notification.link!);
                    },
                    radius: 100,
                    backgroundColor: Colors.yellow
                ),
              ),
            const SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  Text(notification.title!, style: robotoBlack,),
                  const SizedBox(height: 10,),
                  Text(notification.body!, style: robotoRegular,),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomButton(
                  buttonText: 'Apagar',
                  onPressed: () async{
                    Get.back();
                    await controller.deleteNotification(notification);
                  },
                  radius: 100,
                  backgroundColor: Colors.red
              ),
            ),
            const SizedBox(height: 40,),
          ],
        ),
      );
    },
        isDismissible: true
    );
  }
}
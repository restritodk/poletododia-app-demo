import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/notification_controller.dart';
import 'package:untitled/controllers/settings_controller.dart';
import 'package:untitled/helper/route_helper.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/view/screens/Loading_screen.dart';

class SettingsScreen extends StatefulWidget{
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        appBar: AppBar(
          title: const Text('Configuraçôes'),
          actions: [
            GetBuilder<NotificationController>(builder: (controller){
              int count = controller.countNotification;
              return InkWell(
                onTap: () => Get.toNamed(RouteHelper.getNotificationPushRoute()),
                child: SizedBox(
                  width: 50,
                  child: Stack(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(.4),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: const Icon(Icons.notifications, color: Colors.white,),
                    ),
                    if(count != 0)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100)
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Text(count > 99 ? '99+' : '$count', style: robotoRegular.copyWith(color: Colors.white, fontSize: 10),),
                          ),
                        ),
                      )
                  ],),
                ),
              );
            }),
            const SizedBox(width: 10,)
          ],
        ),
        backgroundColor: colorBackground,
        child: GetBuilder<SettingsController>(builder: (controller){
          return SingleChildScrollView(child: Column(
            children: [
              const SizedBox(height: 20,),

              _cardItemFunc(
                  title: 'Notificações de novos comentarios',
                  subtitle: 'Sempre que um novo comentario em um post seu receberar uma notificação',
                  value: controller.userSettings!.isReceiverNotificationNewComment!.value,
                  onChanged: (dynamic value)async{
                    await controller.changeNotificationOption(controller.userSettings!.isReceiverNotificationNewComment!);
                  }
              ),

              _cardItemFunc(
                  title: 'Notificações de aulas recentes',
                  subtitle: 'Sempre que houver uma aula que vc goste, vc receberar uma notificaçao',
                  value: controller.userSettings!.isReceiverNotificationRecentClasses!.value,
                  onChanged: (dynamic value)async{
                    await controller.changeNotificationOption(controller.userSettings!.isReceiverNotificationRecentClasses!);
                  }
              ),

              _cardItemFunc(
                  title: 'Notificações da comunidade',
                  subtitle: 'Notificações individuais (marcação, gostei, etc.)',
                  value: controller.userSettings!.isReceiverNotificationCommunity!.value,
                  onChanged: (dynamic value)async{
                    await controller.changeNotificationOption(controller.userSettings!.isReceiverNotificationCommunity!);
                  }
              ),

              _cardItemFunc(
                  title: 'Calendário de treinos',
                  subtitle: 'Notificações sobre treinos',
                  value: controller.userSettings!.isReceiverNotificationTrainingCalendar!.value,
                  parent: controller.userSettings!.isReceiverNotificationTrainingCalendar!.value ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButton<String>(
                      value: controller.userSettings!.calendarTrigger!.value as String,
                      onChanged: (String? newValue) async{
                        controller.userSettings!.calendarTrigger!.setValue(newValue!);
                        await controller.changeNotificationOption(controller.userSettings!.calendarTrigger!);
                      },
                      items: <String>['an_hour', 'half_an_hour', 'now'
                      ].map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value!,
                          child: Text(value.tr),
                        );
                      }).toList(),
                    ),
                  ) : null,
                  onChanged: (dynamic value)async{
                    await controller.changeNotificationOption(controller.userSettings!.isReceiverNotificationTrainingCalendar!);
                  }
              ),

            ],),);
        }));
  }

  Widget _cardItemFunc({required String title, required String subtitle, required dynamic value, required Function(dynamic value) onChanged, Widget? parent}) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
                title: Text(title),
                subtitle: Text(subtitle, style: const TextStyle(color: Colors.black54),),
                value: value, onChanged: (bool? value) async => onChanged(value)),
            if(parent != null)
              parent
          ],
        ),
      ),
    );
  }
}

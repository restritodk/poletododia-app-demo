import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/helper/route_helper.dart';

class HomePageScreen extends StatefulWidget{
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _itemHome(
                title: 'Comunidade',
                subtitle: 'Pole Todo Dia',
                color: Colors.red,
                icon: Icons.person_outline_sharp,
                onTap: () => Get.toNamed(RouteHelper.getCommunityRoute())
            ),
            _itemHome(
                title: 'Notificações',
                subtitle: 'Todas as notificações',
                color: Colors.yellow,
                icon: Icons.notifications,
                onTap: () => Get.toNamed(RouteHelper.getNotificationPushRoute())
            ),
            _itemHome(
                title: 'Configurações',
                subtitle: 'Configure seu app',
                color: Colors.purple,
                icon: Icons.settings,
                onTap: () => Get.toNamed(RouteHelper.getSettingsRoute())
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemHome({required String title, required String subtitle, required Color color, required IconData icon, required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Card(
        color: color.withOpacity(.3),
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(icon, color: Colors.white,),
              trailing: const Icon(Icons.navigate_next, color: Colors.white,),
              title: Text(title, style: const TextStyle(color: Colors.white),),
              subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70),),
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
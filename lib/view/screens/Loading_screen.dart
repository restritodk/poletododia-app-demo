import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/util/styles.dart';

import '../../controllers/root_controller.dart';
import '../../helper/helpers.dart';

class LoadingScreen extends StatefulWidget{
  final Widget child;
  PreferredSizeWidget? appBar;
  Widget? drawer;
  Future<bool> Function()? onWillPop;
  Color? backgroundColor;
  Widget? bottomNavigationBar;
  GlobalKey<ScaffoldState>? scaffoldKey;

  LoadingScreen({super.key, this.drawer, this.bottomNavigationBar, required this.child, this.appBar, this.onWillPop, this.backgroundColor, this.scaffoldKey});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with WidgetsBindingObserver{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: widget.appBar,
      bottomNavigationBar: widget.bottomNavigationBar,
      drawer: widget.drawer,
      backgroundColor: widget.backgroundColor ?? colorBackground,
      body: GetBuilder<RootController>(builder: (controller){
        return WillPopScope(
          onWillPop: () async{
            if(!controller.loading && widget.onWillPop != null){
              return await widget.onWillPop!();
            }
            return !controller.loading;
          },
          child: Stack(children: [
            widget.child,
            if(controller.loading)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.0),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.0,
                          )
                      ),
                      child: Helpers.loading()
                  ),
                ),
              )
          ],),
        );
      },),
    );
  }
}
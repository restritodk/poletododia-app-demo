import 'package:flutter/material.dart';

import '../../util/dimensions.dart';
import '../../util/styles.dart';

class CustomButton extends StatelessWidget {
  Function? onPressed;
  final String buttonText;
  EdgeInsets? margin;
  double? height;
  double? width;
  double? fontSize;
  final double radius;
  IconData? icon;
  Color? backgroundColor, foregroundColor;
  bool? withBorder;
  CustomButton({this.onPressed,
    required this.buttonText,
    this.margin,
    this.width,
    this.height,
    this.fontSize, this.withBorder = false, this.radius = 5, this.icon, this.backgroundColor = Colors.orangeAccent, this.foregroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    backgroundColor ??= Theme.of(context).primaryColor;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null ? Theme.of(context).disabledColor : backgroundColor ?? Theme.of(context).primaryColor,
      minimumSize: Size(width ?? Dimensions.WEB_MAX_WIDTH, height ?? 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: withBorder! ? BorderSide(
          color: foregroundColor!,
          width: 1
        ) : const BorderSide(width: 0)
      ),
    );

    return Center(child: SizedBox(width: width ?? Dimensions.WEB_MAX_WIDTH, child: Padding(
      padding: margin ?? const EdgeInsets.all(0),
      child: TextButton(
        onPressed: () {
          if(onPressed != null){
            onPressed!();
          }
        },
        style: flatButtonStyle,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          icon != null ? Padding(
            padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(icon, color: backgroundColor),
          ) : const SizedBox(),
          Text(buttonText ??'', textAlign: TextAlign.center, style: robotoBold.copyWith(
            color: foregroundColor,
            fontSize: fontSize ?? Dimensions.fontSizeLarge,
          )),
        ]),
      ),
    )));
  }
}

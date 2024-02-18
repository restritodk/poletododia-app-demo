import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitled/data/model/enum/archive_type.dart';

import '../../util/images.dart';

class CustomImage extends StatelessWidget {
  final String image;
  double? height;
  double? width;
  final BoxFit fit;
  final String placeholder;
  ArchiveType? archiveType;
  CustomImage({required this.image, this.height, this.width, this.fit = BoxFit.cover, this.placeholder = Images.placeholder, this.archiveType});

  @override
  Widget build(BuildContext context) {
    if(archiveType == ArchiveType.video){
     return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            image: DecorationImage(
                image: FileImage(File(image))
            )
        )
      );
    }
    return Container(
      color: Theme.of(context).cardColor,
      child: CachedNetworkImage(
        imageUrl: image, height: height, width: width, fit: fit,
        placeholder: (context, url) => Image.asset(placeholder, height: height, width: width, fit: fit),
        errorWidget: (context, url, error) => Image.asset(placeholder, height: height, width: width, fit: fit),
      ),
    );
  }
}

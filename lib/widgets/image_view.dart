import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:websafe_svg/websafe_svg.dart';


class ImageView extends StatelessWidget {
  final String? path;
  final double? width;
  final double? height;
  final File? file;
  final bool? circleCrop;
  final BoxFit? fit;
  final Color? color;
  final double? radius;

  const ImageView(
      {Key? key,
        this.path,
        this.width,
        this.height,
        this.file,
        this.circleCrop = false,
        this.fit,
        this.radius = 20.0,
        this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    // if(path==""){
    //   imageWidget=Image.asset(
    //     ImageConstants.splash,
    //     width: width,
    //     height: height,
    //     color:ColorConstants.primaryColor,
    //     fit: BoxFit.contain,
    //   );
    // }
    // else
    if (path?.startsWith('https') ?? false) {
      imageWidget = CachedNetworkImage(
        fit: fit,
        height: height,
        width: width,
        imageUrl: path!,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color:ColorConstants.primaryColor
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );

    }
    else if (path?.startsWith('images/') ?? false) {
      imageWidget =
      path!.contains(".svg")
          ? WebsafeSvg.asset(
        path!,
        width: width,
        height: height,
        color: color,
      ) :
      Image.asset(
        path!,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    }
    else if (file != null) {
      imageWidget = Image.file(
        file!,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      imageWidget = Image.file(
        File(path.toString()),
        width: width,
        height: height,
        fit: fit,
      );
    }
    return circleCrop!
        ? CircleAvatar(radius: radius, child: ClipOval(child: imageWidget))
        : imageWidget;
  }
}

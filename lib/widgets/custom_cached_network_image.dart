import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/widgets/custom_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String? url;
  final String? placeHolderImg;
  final Color? placeHolderImgColor;
  final Color? color;
  final double? width;
  final double? height;
  final String? screenName;
  final BoxFit? fit;
  final bool? isNewSize;

  const CustomCachedNetworkImage(
      {this.url,
      this.placeHolderImg = 'assets/img/no_image.png',
      this.placeHolderImgColor,
      this.width,
      this.height,
      this.screenName,
      this.color,
      this.fit,
      this.isNewSize,
      super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "$url",
      fit: fit ?? BoxFit.fill,
      width: double.infinity,
      color: color,
      imageBuilder: (context, imageProvider) {
        return isNewSize == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[ClipRRect(borderRadius: BorderRadius.circular(0), child: Image.network(url!, height: height, fit: BoxFit.fill))])
            : Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: fit ?? BoxFit.fill)));
      },
      placeholder: (context, url) => CustomImage(placeHolderImg: placeHolderImg, placeHolderImgColor: placeHolderImgColor),
      errorWidget: (context, url, error) => CustomImage(placeHolderImg: placeHolderImg, placeHolderImgColor: placeHolderImgColor),
    );
  }
}

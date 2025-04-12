import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String? placeHolderImg;
  final Color? placeHolderImgColor;

  const CustomImage({this.placeHolderImg, this.placeHolderImgColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(placeHolderImg ?? "assets/icons/preview.png", fit: BoxFit.cover, color: placeHolderImgColor);
  }
}

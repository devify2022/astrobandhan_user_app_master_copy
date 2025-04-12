import 'package:astrobandhan/localization/language_constrants.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';

class CustomText2 extends StatelessWidget {
  CustomText2(
      {this.title,
      this.color = blackColor,
      this.fontSize = 14,
      this.fontWeight,
      this.fontStyle,
      this.textAlign,
      this.decoration,
      this.maxLines,
      this.fontFamily,
      this.height,
      this.overflow,
      super.key});
  String? title;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  FontStyle? fontStyle;
  TextAlign? textAlign;
  TextDecoration? decoration;
  int? maxLines;
  String? fontFamily;
  double? height;
  TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      getTranslated(title!, context) ?? "",
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight, decoration: decoration, fontStyle: fontStyle, fontFamily: fontFamily ?? "medium", height: height),
    );
  }
}

class CustomText3 extends StatelessWidget {
  const CustomText3(this.data, {super.key, this.style, this.textAlign, this.overflow, this.maxLines, this.color, this.fontSize, this.decoration});

  final String data;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final int? maxLines;
  final TextStyle? style;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      getTranslated(data, context) ?? "",
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow,
      style: style ?? poppinsStyle500Medium.copyWith(fontSize: fontSize, color: color, decoration: decoration),
    );
  }
}

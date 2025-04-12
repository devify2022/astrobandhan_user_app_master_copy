import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomCircleWidget extends StatelessWidget {
  final Icon? icon;
  final String? title;
  final int? index;
  final Color? bgColor;
  final Color? titleColor;

  const CustomCircleWidget({this.icon, this.title, this.index, this.bgColor, this.titleColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          //Space
          SizedBox(height: 6),
          CustomText(title: title, color: titleColor, fontSize: 13)
        ],
      ),
    );
  }
}

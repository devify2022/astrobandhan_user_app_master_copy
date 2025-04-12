import 'package:flutter/material.dart';

class CustomParentWidget extends StatelessWidget {
  const CustomParentWidget({this.child, super.key});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    late MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return MediaQuery(data: queryData.copyWith(textScaler: TextScaler.linear(1.0)), child: child ?? SizedBox());
  }
}

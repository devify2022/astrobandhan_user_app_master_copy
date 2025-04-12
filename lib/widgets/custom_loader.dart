import 'package:astrobandhan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SpinKitFadingCircle(color: kPrimaryColor, size: 40.0),
    );
  }
}

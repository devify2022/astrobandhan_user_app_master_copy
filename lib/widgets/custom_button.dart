import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';

class CustomButtons {
  // Constants
  static const double _buttonHeight = 50.0; // Adjust this value as needed
  static const double _borderRadius = 25.0;

  // static Color textColor = kPrimaryColor;

  static Widget saveButton(
      {required VoidCallback? onPressed,
      double? width,
      String text = 'SAVE',
      Color textColor = kPrimaryColor,
      double? height,
      double? borderRadius}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? _borderRadius)),
        minimumSize: Size(width ?? double.infinity, height ?? _buttonHeight),
      ),
      onPressed: onPressed,
      child: Text(text,
          style:
              poppinsStyle500Medium.copyWith(fontSize: 16, color: textColor)),
    );
  }

  static Widget loadingButton() {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  static Widget buildOutlinedButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
        textStyle: poppinsStyle500Medium.copyWith(
            fontSize: 16, decoration: TextDecoration.underline),
        // textStyle: const TextStyle(
        //   fontWeight: FontWeight.normal,
        //   fontFamily: 'Poppins',
        //   decoration: TextDecoration.underline,
        // ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

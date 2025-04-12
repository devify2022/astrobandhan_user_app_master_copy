import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:astrobandhan/utils/text.styles.dart';

class OtpPinInput extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  final Function(String) onCompleted;
  final double width;
  final double height;

  const OtpPinInput({
    super.key,
    required this.controller,
    this.length = 4,
    required this.onCompleted,
    this.width = 88,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: width,
      height: height,
      
      textStyle: poppinsStyle500Medium.copyWith(
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(46),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.white.withValues(alpha: 0.5),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
    );

    return Pinput(
      controller: controller,
      length: length,
     autofillHints: const [AutofillHints.oneTimeCode],
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: onCompleted,
      onChanged: (value) {
        // You can add additional validation logic here if needed
      },
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: 22,
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

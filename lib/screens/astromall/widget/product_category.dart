import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AstomallTapWidget extends StatelessWidget {
  final bool isSelected;
  final VoidCallback callback;
  final String title;
  const AstomallTapWidget({
    this.isSelected = false,
    required this.callback,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: callback,
          child: Container(
            decoration: BoxDecoration(
                color: isSelected ? kBackgroundColor : Colors.transparent,
                border: isSelected ? null : Border.all(color: kBackgroundColor),
                borderRadius: BorderRadius.circular(25)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(title,
                  style: poppinsStyle500Medium.copyWith(
                      color: isSelected ? kPrimaryColor : kBackgroundColor)),
            )),
          ),
        ),
        Gap(10)
      ],
    );
  }
}

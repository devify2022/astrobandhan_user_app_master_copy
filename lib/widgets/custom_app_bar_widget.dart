import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/utils/size.util.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool textAlignCenter;

  const AppBarWidget({super.key, required this.title, this.onBackPressed, this.textAlignCenter = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: SvgPicture.asset(ImageResources.back_arrow),
          onPressed: () {
            if (onBackPressed != null) {
              onBackPressed!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        textAlignCenter ? SizedBox(width: 10) : spaceWeight10,
        Expanded(
            child: Text(title, style: poppinsStyle500Medium.copyWith(fontSize: 18), textAlign: textAlignCenter ? TextAlign.center : TextAlign.start)),
        const SizedBox(width: 20),
      ],
    );
  }
}

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool textAlignCenter;

  const CustomAppBarWidget({super.key, required this.title, this.onBackPressed, this.textAlignCenter = false});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Color(0xff0f0f60), statusBarIconBrightness: Brightness.light),
      sized: true,
      child: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(ImageResources.back_arrow),
          onPressed: () {
            if (onBackPressed != null) {
              onBackPressed!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(title, style: poppinsStyle500Medium.copyWith(fontSize: 18)),
        centerTitle: textAlignCenter,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}

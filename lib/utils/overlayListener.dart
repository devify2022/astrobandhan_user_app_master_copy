import 'package:astrobandhan/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:astrobandhan/provider/overlay_provider.dart';

class OverlayVisibilityListener extends StatefulWidget {
  const OverlayVisibilityListener({super.key});

  @override
  State<OverlayVisibilityListener> createState() =>
      _OverlayVisibilityListenerState();
}

class _OverlayVisibilityListenerState extends State<OverlayVisibilityListener> {
  bool? previousVisibility;

  @override
  void initState() {
    super.initState();

    // Delay listening until after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlayProvider =
          Provider.of<OverlayProvider>(context, listen: false);
      previousVisibility = overlayProvider.isOverlayVisible;

      overlayProvider.addListener(_checkVisibilityChange);
    });
  }

  void _checkVisibilityChange() {
    final overlayProvider =
        Provider.of<OverlayProvider>(context, listen: false);
    final currentVisibility = overlayProvider.isOverlayVisible;

    if (currentVisibility != previousVisibility) {
      previousVisibility = currentVisibility;

      // Trigger toast only on actual change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showToastMessage(
          currentVisibility ? "Button is visible2" : "Button is hidden2",
        );
      });

      // Optional: update UI if needed
      setState(() {});
    }
  }

  @override
  void dispose() {
    final overlayProvider =
        Provider.of<OverlayProvider>(context, listen: false);
    overlayProvider.removeListener(_checkVisibilityChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Invisible widget
  }
}

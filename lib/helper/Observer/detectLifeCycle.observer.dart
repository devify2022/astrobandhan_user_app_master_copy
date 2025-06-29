import 'package:astrobandhan/provider/socket_provider.dart';
import 'package:flutter/widgets.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final Function(bool isActive) onStateChange;

  AppLifecycleObserver(this.onStateChange);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onStateChange(true); // User is active
    } else {
      onStateChange(false); // User is inactive
    }
  }
}

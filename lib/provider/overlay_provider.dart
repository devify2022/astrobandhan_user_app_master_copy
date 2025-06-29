// overlay_provider.dart
import 'package:astrobandhan/datasource/model/others/chatRoom_model.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/auth_provider.dart';
import 'package:astrobandhan/provider/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverlayProvider with ChangeNotifier {
  bool _isOverlayVisible = false;
  ChatRoomModel? _currentChatRoom;
  BuildContext? _context;

  bool get isOverlayVisible => _isOverlayVisible;
  ChatRoomModel? get currentChatRoom => _currentChatRoom;

  // Call this method to set the context before using the provider
  void setContext(BuildContext context) {
    _context = context;
  }

  void showOverlay(ChatRoomModel chatRoom) {
    if (_context == null) {
      debugPrint('⚠️ Context is not set in OverlayProvider');
      return;
    }

    _currentChatRoom = chatRoom;
    _isOverlayVisible = true;
    final authProvider = Provider.of<AuthProvider>(_context!, listen: false);
    final socketProvider =
        Provider.of<SocketProvider>(_context!, listen: false);
    // Fetch userId
    String userId = authProvider.authRepo.getUserInfoData()?.id ?? '';
    socketProvider.initializeSocket(userId);
    debugPrint('🟢 ShowOverlay called - Visible: $_isOverlayVisible');
    notifyListeners();
  }

  void hideOverlay() {
    _isOverlayVisible = false;
    _currentChatRoom = null;
    debugPrint('🔴 HideOverlay called - Visible: $_isOverlayVisible');
    notifyListeners();
  }
}

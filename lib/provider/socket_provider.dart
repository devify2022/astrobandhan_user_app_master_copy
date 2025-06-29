import 'dart:async';
import 'package:astrobandhan/Service/SocketService.dart';
import 'package:flutter/material.dart';
import 'package:astrobandhan/provider/overlay_provider.dart';

import 'package:astrobandhan/datasource/model/others/chatRoom_model.dart';

class SocketProvider extends ChangeNotifier {
  SocketService? _socketService;
  bool isConnected = false;
  bool _isButtonVisible = false;
  bool get isButtonVisible => _isButtonVisible;
  SocketService? get socketService => _socketService;
  bool _loading = false;
  bool get loading => _loading;

  ChatRoomModel? _chatRoomModel;
  ChatRoomModel? get chatRoomModel => _chatRoomModel;

  int _remainingSeconds = 60;
  int get remainingSeconds => _remainingSeconds;

  Timer? _timer;

  void updateButtonVisibility(bool isVisible) {
    if (_isButtonVisible != isVisible) {
      if (!isVisible) {
        _chatRoomModel = null;
      }
      _isButtonVisible = isVisible;
      print("Chat button visibility changed: $_isButtonVisible");
      notifyListeners();
    }
  }

  void updateChatRoomData(Map<String, dynamic> chatRoomData) {
    _loading = true;
    notifyListeners();

    _chatRoomModel = ChatRoomModel.fromJson(chatRoomData);
    print("Chat Room Data updated: ${_chatRoomModel?.toJson()}");

    if (_chatRoomModel?.status == 'confirmed' ||
        _chatRoomModel?.status == 'active') {
      startCountdownTimer();
    }

    _loading = false;
    notifyListeners();
  }

  void startCountdownTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _remainingSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      if (_remainingSeconds <= 0) {
        _remainingSeconds = 0;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  void resetTimer() {
    _remainingSeconds = 60;
    notifyListeners();
  }

  void acceptRequest() {
    print("Request accepted!");
    resetTimer();
    startCountdownTimer();
  }

  void initializeSocket(String userId) {
    if (isConnected) {
      print("Socket already connected.");
      return;
    }

    _socketService = SocketService(
      userId,
      updateButtonVisibility_: (isVisible) {
        updateButtonVisibility(isVisible);
      },
      onChatRoomUpdate: (response) {
        print("ChatRoomUpdate received: $response");
        updateChatRoomData(response);
        updateButtonVisibility(true);
      },
      onVisibilityTimeout: () {
        print("Visibility timeout triggered.");
        updateButtonVisibility(false);
        _chatRoomModel = null;
        notifyListeners();
      },
      overlayProvider: OverlayProvider(),
    );

    _socketService?.connect(userId);
    isConnected = true;
    notifyListeners();
  }

  void startChat(
      String userId, String astrologerId, String chatRoomId, String response) {
    _socketService?.emitUserResponse(
        userId, astrologerId, chatRoomId, response);
  }

  void endChat(String userId, String astrologerId, String chatRoomId) {
    _socketService?.endChat(userId, astrologerId, chatRoomId);
  }

  void sendMessage(String userId, String astrologerId, String chatRoomId,
      String messageText, String messageType, String senderType) {
    if (!isConnected || _socketService == null) {
      initializeSocket(userId);
    }

    final payload = {
      'chatRoomId': chatRoomId,
      'senderType': senderType,
      'senderId': userId,
      'recipientId': astrologerId,
      'messageType': messageType,
      'message': messageText,
    };

    _socketService?.sendMessage(payload);
  }

  void onMessageReceived(Function(dynamic data) callback) {
    _socketService?.socket.on("received-message", callback);
  }

  void onChatEnded(Function(dynamic data) callback) {
    _socketService?.socket.on("chat-ended", callback);
  }

  void emitRequestChat(String userId, String astrologerId, String chatType) {
    if (!isConnected || _socketService == null) {
      initializeSocket(userId);
    }
    _socketService?.emitRequestChat(userId, astrologerId, chatType);
  }

  void emitUserActivity(String userId, bool isActive) {
    if (!isConnected || _socketService == null) {
      initializeSocket(userId);
    }
    _socketService?.emitUserActivity(userId, isActive);
  }

  void disconnectSocket() {
    if (!isConnected) {
      return;
    }
    _socketService?.disconnect();
    isConnected = false;
    updateButtonVisibility(false);
    _chatRoomModel = null;
    _timer?.cancel();
    notifyListeners();
  }
}

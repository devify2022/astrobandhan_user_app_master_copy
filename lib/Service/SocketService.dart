import 'dart:convert';
import 'dart:ffi';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/screens/astrologer/astrologer_screen.dart';
import 'package:astrobandhan/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:astrobandhan/datasource/model/others/chatRoom_model.dart';
import 'package:astrobandhan/provider/overlay_provider.dart';
import 'package:astrobandhan/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  bool listenersAttached = false;
  final Function(Map<String, dynamic>)? onChatRoomUpdate;
  final Function()? onVisibilityTimeout;
  final Function(bool)? updateButtonVisibility_;
  final OverlayProvider? overlayProvider;

  SocketService(
    String userId, {
    this.onChatRoomUpdate,
    this.onVisibilityTimeout,
    this.updateButtonVisibility_,
    this.overlayProvider,
  }) {
    socket = IO.io(AppConstant.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'userId': userId},
    });
  }

  void connect(String userId) {
    if (socket.connected) {
      print('Socket already connected.');
      return;
    }

    socket.connect();

    socket.on('connect', (_) async {
      print('Socket connected as $userId');

      if (!listenersAttached) {
        listenersAttached = true;
        _detachExistingListeners();
        _attachListeners(userId);
      }
    });
  }

  void _detachExistingListeners() {
    socket.clearListeners();
  }

  void _attachListeners(String userId) {
    _registerPlayerId(userId);

    socket.emit('register_user', {'userId': userId});

    socket.on('chatRoomStatusUpdate', (data) async {
      debugPrint('chatRoomStatusUpdate received: $data');
      try {
        final model = ChatRoomModel.fromJson(data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('chatRoomData', jsonEncode(model.toJson()));

        onChatRoomUpdate?.call(data);
        updateButtonVisibility_?.call(true);
      } catch (e) {
        debugPrint("Error parsing chatRoomStatusUpdate: $e");
      }
    });
    socket.on('noChatResponse', (data) async {
      try {
        updateButtonVisibility_?.call(false);

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('chatRoomData'); // This will clear the chatRoomData
      } catch (e) {
        debugPrint("Error parsing chatRoomStatusUpdate: $e");
      }
    });
    socket.on('chat_request_cancelled', (data) async {
      try {
        final message = data['message'] ?? 'Chat request cancelled.';
        debugPrint('chat_request_cancelled received: $message');
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('chatRoomData'); // This will clear the chatRoomData
        showToastMessage(message);
      } catch (e) {
        debugPrint("Error handling chat_request_cancelled: $e");
      }
    });
    socket.on('chat-ended', (data) async {
      try {
        showToastMessage('Chat ended.');
      } catch (e) {
        debugPrint("Error handling chat_request_cancelled: $e");
      }
    });

    socket.on('end_audio_call', (data) async {
      try {
        showToastMessage('Call ended.');
      } catch (e) {
        debugPrint("Error handling chat_request_cancelled: $e");
      }
    });
    socket.on('call_rejected_by_astrologer', (data) async {
      try {
        Helper.navigateTo(DashboardScreen());
        showToastMessage('Call ended  by astrologer.');
      } catch (e) {
        debugPrint("Error handling chat_request_cancelled: $e");
      }
    });

    socket.on('call_accepted', (data) async {
      try {
        showToastMessage('Call Started ');
      } catch (e) {
        debugPrint("Error handling chat_request_cancelled: $e");
      }
    });

    socket.on('chat_request_failed', (data) async {
      try {
        final message = data['message'] ?? 'Request not sent!.';
        showToastMessage(message);
      } catch (e) {
        debugPrint("Error handling chat_request_cancelled: $e");
      }
    });
  }

  void sendMessage(Map<String, dynamic> payload) {
    if (!socket.connected) connect(payload['senderId']);
    socket.emit('send_message', payload);
  }

  void emitRequestChat(String userId, String astrologerId, String chatType) {
    final payload = {
      'userId': userId,
      'astrologerId': astrologerId,
      'chatType': chatType,
    };
    socket.emit('request_chat', payload);
  }

  void emitUserResponse(
      String userId, String astrologerId, String chatRoomId, String response) {
    final payload = {
      'userId': userId,
      'astrologerId': astrologerId,
      'chatRoomId': chatRoomId,
      'response': response,
    };
    socket.emit('user_response', payload);
  }

  void endChat(String userId, String astrologerId, String chatRoomId) {
    final payload = {
      'userId': userId,
      'astrologerId': astrologerId,
      'roomId': chatRoomId,
      'sender': 'user',
    };
    socket.emit('end_chat', payload);
  }

  void emitUserActivity(String userId, bool isActive) {
    final payload = {
      'userId': userId,
      'isActive': isActive,
    };
    socket.emit('update_status', payload);
  }

  void _registerPlayerId(String userId) {
    // Optional: implement OneSignal player ID registration if required
    debugPrint("Registering OneSignal player ID for $userId");
  }

  void disconnect() {
    socket.disconnect();
    listenersAttached = false;
    debugPrint("Socket disconnected.");
  }
}

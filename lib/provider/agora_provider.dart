import 'dart:convert';
import 'package:astrobandhan/datasource/model/call/agoraTokenModel.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:astrobandhan/provider/socket_provider.dart'; // Import the SocketProvider

class AgoraProvider with ChangeNotifier {
  final SocketProvider? socketProvider;

  AgoraProvider({required this.socketProvider});

  Future<AgoraTokenModel> fetchToken({
    required String channelName,
    required int uid,
    required String userId,
    required String astrologerId,
  }) async {
    final url = Uri.parse(
        '${AppConstant.agoraTokenEndpoint}?channelName=$channelName&uid=$uid');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'channelName': channelName,
        'uid': uid,
        userId: userId,
        astrologerId: astrologerId,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        // Ensure the 'data' and 'token' exist before proceeding
        if (data['data'] != null && data['data']['token'] != null) {
          // Emit the socket event with the token
          socketProvider?.socketService!.socket.emit("call_initialize", {
            'payload': {
              'channelName': channelName,
              'uid': uid,
              'userId': userId,
              'astrologerId': astrologerId,
            }, // Your payload data here
            'token': data['data']['token']
          });
          return AgoraTokenModel.fromJson(data);
        } else {
          throw Exception('Token not found in the response');
        }
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Failed to parse response body');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to fetch Agora token');
    }
  }

  Future<AgoraTokenModel> fetchTokenVideoCall({
    required String channelName,
    required int uid,
    required String userId,
    required String astrologerId,
  }) async {
    final url = Uri.parse(
        '${AppConstant.agoraTokenEndpoint}?channelName=$channelName&uid=$uid');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'channelName': channelName,
        'uid': uid,
        userId: userId,
        astrologerId: astrologerId,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        // Ensure the 'data' and 'token' exist before proceeding
        if (data['data'] != null && data['data']['token'] != null) {
          // Emit the socket event with the token
          socketProvider?.socketService!.socket.emit("videoCall_initialize", {
            'payload': {
              'channelName': channelName,
              'uid': uid,
              'userId': userId,
              'astrologerId': astrologerId,
            }, // Your payload data here
            'token': data['data']['token']
          });
          return AgoraTokenModel.fromJson(data);
        } else {
          throw Exception('Token not found in the response');
        }
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Failed to parse response body');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to fetch Agora token');
    }
  }
}

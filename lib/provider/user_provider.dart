// user_provider.dart

import 'package:astrobandhan/datasource/model/auth/login_user_model.dart';
import 'package:flutter/material.dart';
import 'package:astrobandhan/datasource/repository/user_repo.dart';
import 'package:astrobandhan/datasource/repository/auth_repo.dart';
import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';

class UserProvider extends ChangeNotifier {
  final UserRepo userRepo;
  final AuthRepo authRepo;

  bool isLoading = false;
  String? errorMessage;

  UserProvider({required this.userRepo, required this.authRepo});

  // Send gift API and update user info logic
  Future<void> sendGiftAndUpdateUserInfo({
    required String astrologerId,
    required String userId,
    required double amount,
    required Function(bool) callback, // Accepts a success/failure boolean
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final url = '${AppConstant.baseUrl}${AppConstant.sendGift}';
      final dio = Dio();

      final response = await dio.post(
        url,
        data: {
          'astrologerId': astrologerId,
          'userId': userId,
          'amount': amount,
        },
      );
      print('API Response: $response');

      if (response.statusCode == 200) {
        print('✅ Gift sent successfully to astrologer.');

        ApiResponse userDetailsResponse = await userRepo.getUserDetails(userId);
        print('User info from db: ${userDetailsResponse.response.data}');

        if (userDetailsResponse.response.statusCode == 200) {
          print('Data: ${userDetailsResponse.response.data['data']}');
          await authRepo.saveUserInfo(LoginUserModel.fromJson(
              userDetailsResponse.response.data['data']));

          print('User info saved to SharedPreferences.');
          callback(true); // Success callback
        } else {
          errorMessage = userDetailsResponse.response.data['message'];
          print('❌ Failed to fetch updated user details.');
          callback(false); // Failure callback
        }
      } else {
        errorMessage = response.data['message'] ?? 'Failed to send gift.';
        print('❌ Failed to send gift.');
        callback(false); // Failure callback
      }
    } catch (e) {
      errorMessage = 'Error sending gift: $e';
      print('❗ Error sending gift: $e');
      callback(false); // Failure callback
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

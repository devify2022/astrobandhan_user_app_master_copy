import 'dart:convert';
import 'dart:io';

import 'package:astrobandhan/datasource/model/auth/login_user_model.dart';
import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/remote/dio/dio_client.dart';
import 'package:astrobandhan/datasource/remote/exception/api_error_handler.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> uploadImage(XFile imageFile) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      final cloudName = 'dlol2hjj8';
      final uploadPreset = 'chatting';
      final fileName = imageFile.path.split('/').last;
      final String url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
        "upload_preset": uploadPreset,
      });
      response = await Dio().post(url, data: formData);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> signUp(String name, String email, String phone, String dob, String gender, String timeOfBirth, String placeOfBirth,
      String password, String image) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post('${AppConstant.baseUrl}astrobandhan/v1/user/signup', data: {
        "photo": image,
        "name": name,
        "email": email,
        "dateOfBirth": dob,
        "timeOfBirth": timeOfBirth,
        "placeOfBirth": placeOfBirth,
        "password": password,
        "gender": gender,
        "phone": phone,
        "selected_language_id": "673ad53f92bf6a0be6da3ec2"
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> verifyOTP(String email, String otp) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post(AppConstant.verifyOTPURI, data: {"username": email, "otp": otp});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('shvo ${e.toString()}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> resendOTP() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      var header = {'accept': 'application/json', 'Authorization': 'Bearer ${sharedPreferences.getString(AppConstant.token)}'};
      print(header);

      response = await Dio().post('${AppConstant.baseUrl}${AppConstant.resendOTPURI}', options: Options(headers: header));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> sendOtp(
    String phone,
  ) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      print(AppConstant.loginWithOtp);
      response = await dioClient.post(AppConstant.loginWithOtp, data: {"phone": phone, "role": "user"});

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> otpValidation(String phone, String pin, String verificationId) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      print(AppConstant.otpValidation);
      response = await dioClient.post(AppConstant.otpValidation, data: {"phone": phone, "verificationId": verificationId, "code": pin});

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> updatePassword(
    String phone,
    String password,
  ) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      print(AppConstant.updatePassword);
      response = await dioClient.post(AppConstant.updatePassword, data: {"phone": phone, "newPassword": password});

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> signIn(String phone, String password) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post(AppConstant.login, data: {"phone": phone, "password": password});

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> signInByGoogle(Map map, {String? deviceId}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));

    try {
      response = await dioClient.post('${AppConstant.baseUrl}${AppConstant.loginBySocial}',
          options: Options(headers: {"device-id": deviceId ?? ''}), data: map);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> forgotPassword(String emailAddress, {String? deviceId}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient
          .post(AppConstant.forgotPasswordURI, options: Options(headers: {"device-id": deviceId ?? ''}), data: {"email": emailAddress});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> forgotPasswordWhatsApp(String whatsAppNumber, {String? deviceId}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    print(whatsAppNumber);
    try {
      response = await dioClient
          .post(AppConstant.forgotPasswordWhatsappURI, options: Options(headers: {"device-id": deviceId ?? ''}), data: {"mobile": whatsAppNumber});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> resetPasswordWhatsApp(Map<String, dynamic> data, {String? deviceId}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post(AppConstant.resetPasswordWhatsappURI, options: Options(headers: {"device-id": deviceId ?? ''}), data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> resetPasswordByEmail(Map<String, dynamic> data, {String? deviceId}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post(AppConstant.baseUrl + AppConstant.resetPasswordByEmailURI,
          options: Options(headers: {"device-id": deviceId ?? ''}), data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> refreshToken(String refreshToken, {String? deviceId}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response =
          await dioClient.post(AppConstant.refreshTokenURI, options: Options(headers: {"device-id": deviceId ?? '', "refresh-token": refreshToken}));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> guestLogin({String? deviceId}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post(AppConstant.guestLogin, options: Options(headers: {"device-id": deviceId ?? ''}));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  //Logout
  Future<ApiResponse> logout() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post('auth/logout');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      // print('logout error $e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

//
  Future<ApiResponse> deleteAccount() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.put(AppConstant.deleteAccount);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

//Change Password
  Future<ApiResponse> changePassword(String old, String password, BuildContext context) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.put('${AppConstant.baseUrl}${AppConstant.changePassword}', data: {"old": old, "password": password});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  //Change Password
  Future<ApiResponse> changeProfile(String firstname, String lastname, String email, String mobile) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.put('${AppConstant.baseUrl}${AppConstant.changeProfile}',
          data: {"firstname": firstname, "lastname": lastname, "email": email, "mobile": mobile});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  //Change Name
  Future<ApiResponse> changeName(String firstname, String lastname) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.put('${AppConstant.baseUrl}${AppConstant.changeUserName}', data: {"firstname": firstname, "lastname": lastname});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> uploadPdfWord(File file) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      String fileName = file.path.split('/').last;
      final data = FormData.fromMap({"file": await MultipartFile.fromFile(file.path, filename: fileName), "isPublic": true});

      response = await dioClient.post('${AppConstant.baseUrl}${AppConstant.pdfUploadURI}', data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<void> saveUserInfo(LoginUserModel userInfo) async {
    try {
      await sharedPreferences.setString(AppConstant.userInfo, jsonEncode(userInfo.toJson()));
    } catch (e) {
      rethrow;
    }
  }

  LoginUserModel getUserInfoData() {
    try {
      String? userJson = sharedPreferences.getString(AppConstant.userInfo);
      if (userJson == null) return LoginUserModel();
      return LoginUserModel.fromJson(jsonDecode(userJson));
    } catch (e) {
      rethrow;
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient.token = token;
    dioClient.dio.options.headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};

    try {
      await sharedPreferences.setString(AppConstant.token, token);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await sharedPreferences.setString(AppConstant.refreshToken, token);
    } catch (e) {
      rethrow;
    }
  }

  bool checkTokenExist() {
    return sharedPreferences.containsKey(AppConstant.token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstant.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstant.token);
  }

  Future<bool> clearToken() async {
    await sharedPreferences.remove(AppConstant.userID);
    await sharedPreferences.remove(AppConstant.userEmail2);
    await sharedPreferences.remove(AppConstant.userEmail);
    await sharedPreferences.remove(AppConstant.userPassword);
    await sharedPreferences.remove(AppConstant.user);
    await sharedPreferences.remove(AppConstant.refreshToken);
    return sharedPreferences.remove(AppConstant.token);
  }

  // for  Remember Email
  Future<void> saveUserEmailAndPassword(String email, String password) async {
    try {
      await sharedPreferences.setString(AppConstant.userEmail, email);
      await sharedPreferences.setString(AppConstant.userPassword, password);
    } catch (e) {
      rethrow;
    }
  }

  // for  Remember Email
  Future<void> saveUserEmail(String email) async {
    try {
      await sharedPreferences.setString(AppConstant.userEmail2, email);
    } catch (e) {
      rethrow;
    }
  }

  // for
  Future<void> saveUserPassword(String password) async {
    try {
      await sharedPreferences.setString(AppConstant.userPassword, password);
    } catch (e) {
      rethrow;
    }
  }

  // for  Remember Email

  Future<void> saveUserID(int userID) async {
    try {
      await sharedPreferences.setInt(AppConstant.userID, userID);
    } catch (e) {
      rethrow;
    }
  }

  int getUserID() {
    return sharedPreferences.getInt(AppConstant.userID) ?? -1;
  }

  bool isExistsCustomerID() {
    return sharedPreferences.containsKey(AppConstant.userID);
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstant.userEmail) ?? "";
  }

  String getUserEmail2() {
    return sharedPreferences.getString(AppConstant.userEmail2) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstant.userPassword) ?? "";
  }

  Future<bool> clearUserEmailAndPassword() async {
    await sharedPreferences.remove(AppConstant.userPassword);
    return await sharedPreferences.remove(AppConstant.userEmail);
  }
}

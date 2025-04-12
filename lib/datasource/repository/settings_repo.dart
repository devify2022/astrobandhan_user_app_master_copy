import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/remote/dio/dio_client.dart';
import 'package:astrobandhan/datasource/remote/exception/api_error_handler.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';

class SettingsRepo {
  final DioClient dioClient;

  SettingsRepo({required this.dioClient});

  Future<ApiResponse> updateNotification(Map<String, dynamic> data) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    print(data);
    try {
      response = await dioClient.put(AppConstant.userNotificationURI, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getUser() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get(AppConstant.userURI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getStatusSecurity() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get(AppConstant.statusSecurity);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> sendOtp(String number, bool isVerifiedWhatsApp) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      print('sadjksahjdasjka $number');
      Map map = {"faActive": !isVerifiedWhatsApp, "twoFactorAuthType": "WHATSAPP", "mobile": number};
      response = await dioClient.put(AppConstant.sendOtp, data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> verifyOtp(String number, {String? deviceId}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.put("${AppConstant.verifyWhatsapp}?code=$number", options: Options(headers: {'device-id': '$deviceId'}));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> clearDevicesPut() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.put(AppConstant.clearDevicesPut);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> clearDevicesDelete(String deviceId, String number) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.delete("${AppConstant.clearDevicesDelete}?code=$number", options: Options(headers: {'device-id': deviceId}));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}

// user_repo.dart

import 'package:astrobandhan/datasource/remote/dio/dio_client.dart';
import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/remote/exception/api_error_handler.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';

class UserRepo {
  final DioClient dioClient;

  UserRepo({required this.dioClient});

  // Fetch updated user details
  Future<ApiResponse> getUserDetails(String userId) async {
    Response response =
        Response(requestOptions: RequestOptions(path: 'getUserDetails'));
    try {
      response = await dioClient.get(
        AppConstant.getUserDetails,
        data: {"userId": userId},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}

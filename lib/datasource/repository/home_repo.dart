
import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/remote/dio/dio_client.dart';
import 'package:astrobandhan/datasource/remote/exception/api_error_handler.dart';
import 'package:astrobandhan/datasource/repository/auth_repo.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepo {
  final DioClient dioClient;
  final AuthRepo authRepo;
  HomeRepo({required this.dioClient, required this.authRepo});

  Future<ApiResponse> getAstrologer(int page, {int size = 20}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get(AppConstant.getAstrologerURI(page, size));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getAstrologerAIURI() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post(AppConstant.getAstrologerAIURI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

    Future<ApiResponse> getUserDetails() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get(AppConstant.getUserDetails,data: 
        {"userId": authRepo.getUserInfoData().id}
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}

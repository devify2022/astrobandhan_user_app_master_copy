import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/remote/dio/dio_client.dart';
import 'package:astrobandhan/datasource/remote/exception/api_error_handler.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';

class AstrologerRepo {
  final DioClient dioClient;

  AstrologerRepo({required this.dioClient});

  // Fetch all astrologers with pagination
  Future<ApiResponse> getAstrologers({int page = 1, int size = 20}) async {
    Response response =
        Response(requestOptions: RequestOptions(path: 'astrologers'));
    try {
      response = await dioClient.get(AppConstant.getAstrologerURI(page, size));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  // Fetch a single astrologer by ID
  Future<ApiResponse> getAstrologerById(String id) async {
    Response response =
        Response(requestOptions: RequestOptions(path: 'astrologer/$id'));
    try {
      response = await dioClient.get(AppConstant.getAstrologerById(id));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getAstrologerCategories() async {
    Response response = Response(
      requestOptions: RequestOptions(path: AppConstant.categoriesForAstrologer),
    );
    try {
      response = await dioClient.post(AppConstant.categoriesForAstrologer);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  // You can add more astrologer-related APIs here like search, update, etc.
}

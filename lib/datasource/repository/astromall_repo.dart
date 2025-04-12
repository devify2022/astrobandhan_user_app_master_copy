import 'package:astrobandhan/datasource/model/astromall/order_model.dart';
import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/remote/dio/dio_client.dart';
import 'package:astrobandhan/datasource/remote/exception/api_error_handler.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';

class AstromallRepo {
  final DioClient dioClient;

  AstromallRepo({required this.dioClient});

  Future<ApiResponse> getPoductCategory() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get(AppConstant.astromallCategory);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

    Future<ApiResponse> getAllproduct() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get(AppConstant.getAllAstromallProduct);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
   Future<ApiResponse> createOrder( UserOrder order) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post(AppConstant.astromallProductOrder,data: order.toJson() );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}

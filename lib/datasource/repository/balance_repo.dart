
import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/remote/dio/dio_client.dart';
import 'package:astrobandhan/datasource/remote/exception/api_error_handler.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';

class BalanceRepo {
  final DioClient dioClient;

  BalanceRepo({required this.dioClient});

  Future<ApiResponse> getBalanceHistory() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post(AppConstant.getBalanceHistoryURI, data: {"userId": loginUserModel.id, "debit_type": "", "amount_type": "all"});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> addBalance({required double amount, required String transactionId, required String amountType}) async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      final Map<String, dynamic> data = {'userId': loginUserModel.id, 'amount': amount, 'transaction_id': transactionId, 'amount_type': amountType};

      response = await dioClient.post(AppConstant.addBalanceURI, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }

  Future<ApiResponse> getCallHistory() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.post(AppConstant.getCallHistoryURI, data: {"userId": loginUserModel.id, "type": "user"});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
  Future<ApiResponse> getChatHistory() async {
    Response response = Response(requestOptions: RequestOptions(path: '22222'));
    try {
      response = await dioClient.get(AppConstant.getChatHistoryURI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}

import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/remote/exception/api_error_handler.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UserLanguageRepo {
  //Change Name
  static Future<ApiResponse> userChangeLanguage(BuildContext context, String lang) async {
     Response response = Response(requestOptions: RequestOptions(path: '22222'));
    
    var api = "${AppConstant.baseUrl}${AppConstant.userLanguage}$lang";
    try {
      response = await Dio().put(
        api,
        options: Options(
          // headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).getUserToken()}'},
        ),
      );
      print(response);
      //  await Provider.of<SettingProvider>(context, listen: false).getUser(context);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
    }
  }
}

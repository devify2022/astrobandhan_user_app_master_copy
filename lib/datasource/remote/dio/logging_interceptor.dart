import 'dart:developer';

import 'package:astrobandhan/helper/library/swipeable_page_route/swipeable_page_route.dart';
import 'package:astrobandhan/main.dart';
import 'package:astrobandhan/screens/others/no_internet_screen.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 250;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("--> ${options.method} ${options.path}");
    log("Headers: ${options.headers.toString()}");
    log("Query Parameters: ${options.data.toString()}");
    log("<-- END HTTP");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");

    String responseAsString = response.data.toString();

    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        log(responseAsString.substring(i * maxCharactersPerLine, endingIndex));
      }
    } else {
      log(response.data.toString());
    }

    log("<-- END HTTP");

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    log("ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}");
    super.onError(err, handler);
  }
}

Future<void> clearAllToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(AppConstant.token);
    await sharedPreferences.remove(AppConstant.refreshToken);
  
}

class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor(this.dio);

  @override
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.unknown) {
      await clearAllToken(); // your method to clear tokens

      if (navigatorKey.currentContext != null) {
        Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
          SwipeablePageRoute(
            canOnlySwipeFromEdge: true,
            backGestureDetectionWidth: 10,
            builder: (BuildContext ctx) {
              return NoInternetOrDataScreen(isNoInternet: true);
            },
          ),
          (route) => false,
        );
      } else {
        print("Navigator context is null");
      }
    } else if (err.response?.statusCode == 403) {
      // Refresh the token and retry the request
      await refreshToken();

      final opts = Options(
        method: err.requestOptions.method,
        headers: {
          ...err.requestOptions.headers,
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      final cloneReq = await dio.request(
        err.requestOptions.path,
        options: opts,
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );

      return handler.resolve(cloneReq); // Safe resolve
    } else {
      handler.next(err); // Propagate other errors
    }
  }

  Future<void> refreshToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var mapHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
      'accept': '*/*',
      'Authorization':
          'Bearer ${sharedPreferences.getString(AppConstant.token) ?? ""}',
      "refresh-token":
          sharedPreferences.getString(AppConstant.refreshToken) ?? ''
    };

    log("--------------------------------------------------------------------------------------------------------------");
    log('REFRESH TOKEN API CALLING URL ${AppConstant.baseUrl}${AppConstant.refreshTokenURI}');
    log('REFRESH TOKEN API CALLING Header $mapHeader');
    log("--------------------------------------------------------------------------------------------------------------");

    try {
      Response response = await dio.post(
          "${AppConstant.baseUrl}${AppConstant.refreshTokenURI}",
          options: Options(headers: mapHeader));

      log('RESPONSE ${response.statusCode}: ${response.data}');
      log("--------------------------------------------------------------------------------------------------------------");

      if (response.statusCode == 200) {
        sharedPreferences.setString(
            AppConstant.token, response.data['value']['accessToken']);
        sharedPreferences.setString(
            AppConstant.refreshToken, response.data['value']['refreshToken']);
      } else {
        // Handle token refresh failure
        // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      }
    } catch (e) {
      // Handle error
      // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Splash()), (route) => false);
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstant.token);
  }
}

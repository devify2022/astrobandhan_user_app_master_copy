import 'dart:async';
import 'dart:io';

import 'package:astrobandhan/datasource/remote/dio/logging_interceptor.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final String baseUrl;
  late LoggingInterceptor? loggingInterceptor;
  late SharedPreferences? sharedPreferences;

  Dio dio = Dio();
  String token = '';
  Dio dio1 = Dio();

  DioClient(this.baseUrl, Dio dioC, {this.loggingInterceptor, this.sharedPreferences}) {
    token = sharedPreferences!.getString(AppConstant.token) ?? "";
    dio = dioC;
    dio1 = dioC;
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = Duration(minutes: 3)
      ..options.receiveTimeout = Duration(minutes: 3)
      ..httpClientAdapter = IOHttpClientAdapter()
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
        'device-id': sharedPreferences!.getString(AppConstant.deviceId) ?? ""
      };
    dio.interceptors.add(loggingInterceptor!);
    dio.interceptors.add(TokenInterceptor(dio));
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<Response> get(String uri, {data,Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onReceiveProgress}) async {
    try {
      var response = await dio.get(uri,
          data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress);
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String uri,
      {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress}) async {
    try {
      var response =
          await dio.post(uri, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress);
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      print('DIO ERROR: $e');
      rethrow;
    }
  }

  Future<Response> put(String uri,
      {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress}) async {
    try {
      var response =
          await dio.put(uri, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress);
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String uri, {data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    try {
      var response = await dio.delete(uri, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}

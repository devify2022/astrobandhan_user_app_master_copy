import 'dart:convert';

import 'package:astrobandhan/datasource/remote/dio/dio_client.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  SplashRepo({required this.dioClient, required this.sharedPreferences});


  Future<bool> initSharedData() {
    if (!sharedPreferences.containsKey(AppConstant.theme)) {
      return sharedPreferences.setBool(AppConstant.theme, false);
    }
    return Future.value(true);
  }

  void saveTheme(bool isLight, Map<String, dynamic> data) {
    if (isLight) {
      sharedPreferences.setString(AppConstant.light, jsonEncode(data));
    } else {
      sharedPreferences.setString(AppConstant.dark, jsonEncode(data));
    }
  }

  void saveVariantID(int variant) async {
    sharedPreferences.setInt(AppConstant.variant, variant);
  }

  void setonBoardingStatus() async {
    sharedPreferences.setBool(AppConstant.onBoardingStatus, true);
  }

  bool getOnBoardingStatus() {
    return sharedPreferences.getBool(AppConstant.onBoardingStatus) ?? false;
  }

  int getVariant() {
    return sharedPreferences.getInt(AppConstant.variant) ?? 0;
  }

  bool getThemeCondition() {
    return sharedPreferences.getBool(AppConstant.theme) ?? false;
  }

  Map<String, dynamic> getTheme(bool isLight) {
    return jsonDecode(sharedPreferences.getString(isLight ? AppConstant.light : AppConstant.dark) ?? "");
  }
}

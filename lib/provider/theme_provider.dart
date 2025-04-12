import 'package:astrobandhan/datasource/repository/splash_repo.dart';
import 'package:astrobandhan/provider/setting_provider.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final SplashRepo splashRepo;

  ThemeProvider({required this.sharedPreferences, required this.splashRepo}) {
    loadCurrentTheme();
  }

  bool isDarkTheme = false;

  bool get darkTheme => isDarkTheme;

  void toggleTheme(BuildContext context, {bool? value}) async {
    var settingProvider = Provider.of<SettingProvider>(context, listen: false);
    if (value != null) {
      isDarkTheme = value;
    } else {
      isDarkTheme = !isDarkTheme;
      // if (settingProvider.userModel2.role != null) {
      //   if (settingProvider.userModel2.role!.name == "ROLE_ADMIN" || settingProvider.userModel2.role!.name == "ROLE_CUSTOMER") {
      //     await ThemeServices.themeChange(context, isDarkTheme);
      //   }
      // }
    }
    sharedPreferences.setBool(AppConstant.theme, isDarkTheme);
    notifyListeners();
  }

  void loadCurrentTheme() async {
    isDarkTheme = sharedPreferences.getBool(AppConstant.theme) ?? false;
    //   notifyListeners();
  }

  String darkMapStyle = '';

  Future loadMapStyles() async {
    darkMapStyle = await rootBundle.loadString('assets/json/mapDark.json');
  }

  String retroMapStyle = '';

  Future retroMapStyles() async {
    retroMapStyle = await rootBundle.loadString('assets/json/mapRetro.json');
  }
}

import 'package:astrobandhan/datasource/model/others/language_model.dart';
import 'package:astrobandhan/provider/setting_provider.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocalizationProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  LocalizationProvider({required this.sharedPreferences}) {
    _loadCurrentLanguage();
  }
  Locale _locale = const Locale('sq', 'AL');
  bool _isLtr = true;
  String? languageText = "Albanian";
  Locale get locale => _locale;

  bool get isLtr => _isLtr;

  void setLanguage(Locale locale) {
    _locale = locale;
    if (_locale.languageCode == 'ar') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    _saveLanguage(_locale);
    notifyListeners();
  }

  _loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(AppConstant.languageCode) ?? 'en',
        sharedPreferences.getString(AppConstant.countryCode) ?? 'US');
    _isLtr = _locale.languageCode == 'sq';

    if (_locale.countryCode == 'US') {
      languageModel = AppConstant.languages[2];
      languageText = "English";
    }
    // else if (_locale.countryCode == 'GR') {
    //   languageModel = AppConstant.languages[1];
    //   languageText = "Greek";
    // }
    else if (_locale.countryCode == 'IT') {
      languageModel = AppConstant.languages[1];
      languageText = "Italian";
    } else {
      languageModel = AppConstant.languages[0];
      languageText = "Albanian";
    }
    notifyListeners();
  }

  _saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstant.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstant.countryCode, locale.countryCode ?? '');
    _loadCurrentLanguage();
  }


  LanguageModel? languageModel;

  changeLanguage(LanguageModel l,context,{bool? firstTime}) async{
    languageModel = l;
    var settingProvider = Provider.of<SettingProvider>(context,listen: false);
   // print(";lllllllllllll ${settingProvider.userModel2.role!.name}");
    if(firstTime==true){
      setLanguage(Locale(l.languageCode, l.countryCode));
      print("lang: ${l.languageCode}");
    }else {
      // if(settingProvider.userModel2.role != null){
      // if (settingProvider.userModel2.role!.name == "ROLE_ADMIN"||settingProvider.userModel2.role!.name=="ROLE_CUSTOMER") {
      //   if (l.languageCode == "en") {
      //     await UserLanguageRepo.userChangeLanguage(context, "EN");
      //   } else if (l.languageCode == "sq") {
      //     await UserLanguageRepo.userChangeLanguage(context, "SQ");
      //   }
      //   else if (l.languageCode == "it") {
      //     await UserLanguageRepo.userChangeLanguage(context, "IT");
      //   }
      // }}
      //   setLanguage(Locale('${l.languageCode}', '${l.countryCode}'));
      //
      // print("lang: ${l.languageCode}");
    }
    notifyListeners();
  }



}

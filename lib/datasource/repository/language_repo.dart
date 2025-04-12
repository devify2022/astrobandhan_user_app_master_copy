import 'package:astrobandhan/datasource/model/others/language_model.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstant.languages;
  }
}

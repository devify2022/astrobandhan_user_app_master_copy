import 'package:astrobandhan/datasource/repository/splash_repo.dart';
import 'package:flutter/material.dart';

class SplashProvider with ChangeNotifier {
  final SplashRepo splashRepo;

  SplashProvider({required this.splashRepo});

  final DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  void saveTheme(bool isLight, Map<String, dynamic> data) {}

  void setOnboardingStatus() {
    splashRepo.setonBoardingStatus();
    notifyListeners();
  }

  bool getOnboardingStatus() {
   return splashRepo.getOnBoardingStatus();
  }
  bool initinitializeOnboardingStatus() {
    return splashRepo.getOnBoardingStatus();
  }
}

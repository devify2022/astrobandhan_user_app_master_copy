import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    pageController.jumpToPage(index);
    notifyListeners();
  }

  PageController pageController = PageController();


}


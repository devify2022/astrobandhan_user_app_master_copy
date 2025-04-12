import 'package:astrobandhan/datasource/model/astrologer_model.dart';
import 'package:astrobandhan/datasource/model/auth/user_model.dart';
import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/repository/home_repo.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepo homeRepo;

  HomeProvider({required this.homeRepo});

  bool isLoading = false;
  bool bottomLoading = false;
  List<AstrologerModel> astrologers = [];
  int page = 1;
  bool hasNextData = false;

  getAstrologers({int page = 1, bool isFirstTime = false}) async {
    if (page == 1) {
      astrologers.clear();
      astrologers = [];
      this.page = 1;
      hasNextData = false;
      isLoading = true;
      bottomLoading = false;
      if (isFirstTime == false) notifyListeners();
    } else {
      bottomLoading = true;
      notifyListeners();
    }
    ApiResponse apiResponse = await homeRepo.getAstrologer(page);
    bottomLoading = false;
    isLoading = false;
    if (apiResponse.response.statusCode == 200) {
      if (apiResponse.response.data['data']['astrologers'].length > 0) {
        apiResponse.response.data['data']['astrologers'].forEach((element) {
          astrologers.add(AstrologerModel.fromJson(element));
        });
      }
      notifyListeners();

      if (apiResponse.response.data['data']['totalPages'] > page) {
        hasNextData = true;
      } else {
        hasNextData = false;
      }
    } else {
      hasNextData = false;
      showToastMessage(apiResponse.error.message);
    }
    notifyListeners();
  }

  ///////// for AI
  List<AstrologerModel> aiAstrologers = [];
  bool aiLoading = false;

  void getAstrologerAI() async {
    aiLoading = true;
    aiAstrologers.clear();
    aiAstrologers = [];
    // notifyListeners();
    ApiResponse apiResponse = await homeRepo.getAstrologerAIURI();
    aiLoading = false;
    if (apiResponse.response.statusCode == 200) {
      if (apiResponse.response.data['data'].length > 0) {
        apiResponse.response.data['data'].forEach((element) {
          aiAstrologers.add(AstrologerModel.fromJson(element));
        });
      }
    } else {
      showToastMessage(apiResponse.error.message);
    }
    notifyListeners();
  }

  UserModel userModel = UserModel();
  void getUserDetails() async {
    aiLoading = true;
    aiAstrologers.clear();
    aiAstrologers = [];
    // notifyListeners();
    ApiResponse apiResponse = await homeRepo.getUserDetails();
    aiLoading = false;
    if (apiResponse.response.statusCode == 200) {
      userModel = UserModel.fromJson(apiResponse.response.data['data']);
    } else {
      showToastMessage(apiResponse.error.message);
    }
    notifyListeners();
  }

  int selectedChip = 0;
  void setSelectedChip(int index) {
    selectedChip = index;
    notifyListeners();
  }
}

import 'package:astrobandhan/datasource/model/others/balance_history_model.dart';
import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/model/others/call_history_model.dart';
import 'package:astrobandhan/datasource/repository/balance_repo.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/main.dart';
import 'package:flutter/material.dart';

class BalanceProvider extends ChangeNotifier {
  final BalanceRepo balanceRepo;

  BalanceProvider({required this.balanceRepo});

  bool isLoading = false;
  BalanceHistoryModel balanceHistoryModel = BalanceHistoryModel();

  getBalanceHistory() async {
    isLoading = true;
    balanceHistoryModel = BalanceHistoryModel();

    ApiResponse apiResponse = await balanceRepo.getBalanceHistory();
    debugPrint("📥 Full API Response: ${apiResponse.response}");

    isLoading = false;
    if (apiResponse.response.statusCode == 200) {
      balanceHistoryModel =
          BalanceHistoryModel.fromJson(apiResponse.response.data['data']);
    } else {
      showToastMessage(apiResponse.error.message);
    }
    notifyListeners();
  }

  addBalance(
      {required double amount,
      required String transactionId,
      required String amountType}) async {
    isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await balanceRepo.addBalance(
        amount: amount, transactionId: transactionId, amountType: amountType);
    isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      showToastMessage('Balance added successfully');
      getBalanceHistory();
      Navigator.pop(navigatorKey.currentContext!);
    } else {
      showToastMessage(apiResponse.error.message);
    }
    notifyListeners();
  }

  List<CallHistoryModel> callHistory = [];

  void getAllCallHistory() async {
    isLoading = true;
    notifyListeners(); // Notify listeners to show the loader

    ApiResponse apiResponse = await balanceRepo.getCallHistory();
    isLoading = false;
    notifyListeners(); // Notify listeners to hide the loader

    // Print full response for debugging
    print("Status Code: ${apiResponse.response.statusCode}");
    print("Response Data: ${apiResponse.response.data}");
    print("Error (if any): ${apiResponse.error?.message}");

    if (apiResponse.response.statusCode == 200) {
      // Check if the message says "No records found"
      if (apiResponse.response.data['message'] == 'No records found') {
        showToastMessage("No Data Found");
        callHistory = []; // Set callHistory to empty list
      } else {
        callHistory = [];
        apiResponse.response.data.forEach((element) {
          callHistory.add(CallHistoryModel.fromJson(element));
        });
      }
    } else {
      showToastMessage(apiResponse.error?.message ?? "Unknown Error");
    }

    notifyListeners(); // Ensure listeners are notified
  }

  List<String> chatHistory = [];

  void getAllChatHistory() async {
    isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await balanceRepo.getChatHistory();
    isLoading = false;
    if (apiResponse.response.statusCode == 200) {
      chatHistory = [];
      apiResponse.response.data.forEach((element) {
        chatHistory.add(element);
      });
    } else {
      showToastMessage(apiResponse.error.message);
    }
    notifyListeners();
  }
}

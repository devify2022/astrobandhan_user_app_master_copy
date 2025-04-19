import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/model/others/astrologerCategory/astrologer_caegory_model.dart';
import 'package:astrobandhan/datasource/repository/astrologer_repo.dart';
import 'package:astrobandhan/datasource/repository/home_repo.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../utils//app_constant.dart';

class AstrologerProvider extends ChangeNotifier {
  final AstrologerRepo astrologerRepo;

  AstrologerProvider({
    required this.astrologerRepo,
  });

  Map<String, dynamic>? astrologerData;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchAstrologerData(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final url = AppConstant.getAstrologerById(id); // ✅ use AppConstant method
      print('🌐 Response received: $url');
      final response = await Dio().get('${AppConstant.baseUrl}$url');
      print('🌐 Response received: ${response.data['astrologer']}');
      if (response.statusCode == 200 && response.data['astrologer'] != null) {
        astrologerData =
            response.data['astrologer']; // ✅ store astrologer object directly
      } else {
        errorMessage =
            response.data['message'] ?? 'Failed to load astrologer data';
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException: ${e.message}');
        print('DioException: ${e.response}');
      } else {
        errorMessage = 'Error fetching data: $e';
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Submit review for the astrologer
  Future<void> submitReview(
      String astrologerId, double rating, String comment, String userId) async {
    try {
      final url =
          '${AppConstant.baseUrl}${AppConstant.addReview}'; // Fix URL concatenation
      final dio = Dio();

      final response = await dio.post(
        url,
        data: {
          'astrologerId': astrologerId,
          'userId': userId, // Pass userId here
          'comment': comment,
          'rating': rating,
        },
      );

      if (response.statusCode == 200) {
        // Handle success, you can process the response here
        print('Review submitted successfully');

        // Fetch updated astrologer data after submitting the review
        await fetchAstrologerData(astrologerId); // Call fetchAstrologerData
      } else {
        // Handle error if status code is not 200
        print('Failed to submit review');
      }
    } catch (e) {
      print('Error submitting review: $e');
    }
  }

  List<AstrologerCategory> categories = [];
  bool aiLoading = false;

  void getAstrologerCategories() async {
    try {
      aiLoading = true;
      notifyListeners(); // Notify for loading state

      final apiResponse = await astrologerRepo.getAstrologerCategories();

      if (apiResponse.response?.statusCode == 200) {
        categories.clear(); // Clear existing data before adding new
        if (apiResponse.response?.data['data'] != null &&
            apiResponse.response!.data['data'].isNotEmpty) {
          for (var element in apiResponse.response!.data['data']) {
            categories.add(AstrologerCategory.fromJson(element));
          }
        }
      } else {
        final errorMsg =
            apiResponse.error?.message ?? 'Failed to load categories';
        showToastMessage(errorMsg);
      }
    } catch (e) {
      showToastMessage('An unexpected error occurred');
      debugPrint('Error fetching categories: $e');
    } finally {
      aiLoading = false;
      notifyListeners(); // Notify when complete
    }
  }
}

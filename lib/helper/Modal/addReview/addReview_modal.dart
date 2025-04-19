import 'dart:convert';
import 'package:astrobandhan/provider/astrologer_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrobandhan/datasource/model/auth/login_user_model.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:provider/provider.dart';

void showReviewModal(BuildContext context, String astrologerId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userInfoString = prefs.getString(AppConstant.userInfo);

  if (userInfoString == null) {
    return;
  }

  final userInfo = LoginUserModel.fromJson(jsonDecode(userInfoString));

  double rating = 0;
  TextEditingController commentController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: kPrimaryColor,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Write a Review',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hi ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextSpan(
                          text: userInfo.name,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ', we value your feedback!',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Star Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: index < rating ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),

                  // Comment Input
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write your comment...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      // Check if rating is provided
                      if (rating == 0) {
                        showToastMessage('Rating is mandatory.');
                        return;
                      }

                      // Check if the comment is not empty
                      if (commentController.text.trim().isEmpty) {
                        showToastMessage('Please provide a comment.');
                        return;
                      }

                      // Ensure userInfo.id is not null
                      if (userInfo.id == null) {
                        showToastMessage('User ID is missing.');
                        return;
                      }

                      // Access the AstrologerProvider using Provider.of
                      Provider.of<AstrologerProvider>(context, listen: false)
                          .submitReview(
                        astrologerId,
                        rating,
                        commentController.text,
                        userInfo.id!, // Use ! to assert it's non-null
                      )
                          .then((_) {
                        // Process the review submission after it's successful
                        print('Review by: ${userInfo.name}');
                        print('User ID: ${userInfo.id}');
                        print('Astrologer ID: ${astrologerId}');
                        print('Rating: $rating');
                        print('Comment: ${commentController.text}');

                        // Show a success toast message
                        showToastMessage(
                          'Thanks for your feedback, ${userInfo.name}!',
                          isError: false,
                        );

                        // Optionally, you can navigate away from the screen after review submission
                        Navigator.pop(
                            context); // Close the review dialog or screen
                      }).catchError((e) {
                        // Handle any error that occurred during the review submission
                        showToastMessage(
                            'Failed to submit review. Please try again.');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Submit Review',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

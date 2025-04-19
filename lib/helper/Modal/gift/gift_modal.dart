import 'dart:convert';
import 'package:astrobandhan/datasource/model/auth/login_user_model.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/astrologer_provider.dart';
import 'package:astrobandhan/provider/user_provider.dart';

import 'package:astrobandhan/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Make sure this file contains `kPrimaryColor`
import 'package:provider/provider.dart';

void showGiftModal(BuildContext context, String astrologerId,
    UserProvider userProvider) async {
  // Retrieve user data from SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userInfoString = prefs.getString(AppConstant.userInfo);

  if (userInfoString == null) {
    // Handle the case where user info is not available
    return;
  }

  // Convert the string back to LoginUserModel
  final userInfo = LoginUserModel.fromJson(jsonDecode(userInfoString));

  // Now, use the wallet value from userInfo
  final walletValue = userInfo.wallet;
  final userId = userInfo.id!; // Use ! to assert that the id is non-null
  print('Wallet Value: $walletValue');

  final List<Map<String, dynamic>> giftItems = [
    {
      'name': 'Swastik',
      'imagePath': 'assets/gift/send_gift1.png',
      'price': 50000
    },
    {'name': 'Love', 'imagePath': 'assets/gift/send_gift2.png', 'price': 10},
    {'name': 'Flower', 'imagePath': 'assets/gift/send_gift3.png', 'price': 20},
    {'name': 'Like', 'imagePath': 'assets/gift/send_gift4.png', 'price': 25},
    {'name': 'Gita', 'imagePath': 'assets/gift/send_gift5.png', 'price': 30},
    {'name': 'Tip', 'imagePath': 'assets/gift/send_gift6.png', 'price': 50},
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: kPrimaryColor,
    builder: (context) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title and Wallet Row
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gift Options',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Highlighted Wallet Section
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.account_balance_wallet,
                                color: Colors.black, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₹$walletValue',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Gift Grid
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: giftItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final gift = giftItems[index];
                    return GestureDetector(
                      onTap: () {
                        // Check if the gift price is valid
                        int giftPrice = gift['price'];
                        int userWallet =
                            int.tryParse(walletValue.toString()) ?? 0;

                        // Check if the user has enough wallet balance
                        if (giftPrice > userWallet) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            showToastMessage('Insufficient wallet balance.'),
                          );
                        } else {
                          // Ensure userInfo.id is not null
                          if (userInfo.id == null) {
                            showToastMessage('User ID is missing.');
                            return;
                          }

                          userProvider
                              .sendGiftAndUpdateUserInfo(
                            astrologerId: astrologerId,
                            userId: userId,
                            amount: giftPrice.toDouble(),
                            callback: (success) {
                              if (success) {
                                // Success scenario
                                showToastMessage(
                                  'Your gift has been sent to the astrologer 🎁',
                                  isError: false,
                                );
                                Navigator.pop(
                                    context); // Close the modal or screen
                              } else {
                                // Failure scenario
                                showToastMessage(
                                  'Failed to send the gift. Please try again later.',
                                  isError: true,
                                );
                              }
                            },
                          )
                              .catchError((e) {
                            // Handle any error that occurred during the review submission
                            showToastMessage(
                              'Failed to send the gift. Please try again later.',
                            );
                          });
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(gift['imagePath']),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            gift['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${gift['price']}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

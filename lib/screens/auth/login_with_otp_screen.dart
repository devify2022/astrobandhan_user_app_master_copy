import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/auth_provider.dart';
import 'package:astrobandhan/screens/auth/otp_verify_screen.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/widgets/custom_app_bar_widget.dart';
import 'package:astrobandhan/widgets/custom_button.dart';
import 'package:astrobandhan/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class LoginWithOtpScreen extends StatefulWidget {
  const LoginWithOtpScreen({super.key});

  @override
  State<LoginWithOtpScreen> createState() => _LoginWithOtpScreenState();
}

class _LoginWithOtpScreenState extends State<LoginWithOtpScreen> {
  final TextEditingController _phoneNumber = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();

  // Indian mobile number validator
  bool isValidIndianMobile(String phone) {
    // Remove any spaces or special characters
    String cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it starts with +91 and remove it
    if (cleanPhone.startsWith('+91')) {
      cleanPhone = cleanPhone.substring(3);
    }

    // Check if it's exactly 10 digits and starts with 6, 7, 8, or 9
    return RegExp(r'^[6-9]\d{9}$').hasMatch(cleanPhone);
  }

  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(ImageResources.screenBG, fit: BoxFit.cover)),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                AppBarWidget(title: 'Login With OTP', textAlignCenter: false),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0,
                          MediaQuery.of(context).viewInsets.bottom + 24.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Gap(60),
                                SvgPicture.asset(
                                  "assets/SVG/auth/login_with_otp.svg",
                                  height: hight * 0.300,
                                  width: width * 298,
                                ),
                                Gap(50),
                                CustomTextField(
                                  hintText: 'Your Mobile',
                                  controller: _phoneNumber,
                                  keyboardType: TextInputType.phone,
                                  autofillHints: [
                                    AutofillHints.telephoneNumber
                                  ],
                                  focusNode: phoneFocusNode,
                                ),
                                const Gap(10),
                                Consumer<AuthProvider>(
                                  builder: (context, provider, child) {
                                    if (provider.isLoading) {
                                      return CustomButtons.loadingButton(); // 👈 Replace with your own loading button widget
                                    }
                                    return CustomButtons.saveButton(
                                      onPressed: () {
                                        if (_phoneNumber.text.isEmpty) {
                                          showToastMessage(
                                              "Please enter your mobile number");
                                        } else if (!isValidIndianMobile(
                                            _phoneNumber.text)) {
                                          showToastMessage(
                                              "Please enter a valid Indian mobile number");
                                        } else {
                                          provider
                                              .loginWithOtp(_phoneNumber.text,
                                                  callback: (value) {
                                            print(
                                                "--------value coming---->$value");
                                            if (value) {
                                              showToastMessage(
                                                  "OTP Sent to your mobile",
                                                  isError: false); // ✅ Toast
                                              Helper.pushRemoveScreen(
                                                context,
                                                OtpVerifyScreen(
                                                  isFromForgetPassword: false,
                                                  phoneNumber:
                                                      _phoneNumber.text,
                                                ),
                                              );
                                            }
                                          });
                                        }
                                      },
                                      text: 'Continue',
                                    );
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

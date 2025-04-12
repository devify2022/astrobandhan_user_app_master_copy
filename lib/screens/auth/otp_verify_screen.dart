import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/auth_provider.dart';
import 'package:astrobandhan/screens/auth/change_passowrd_screen.dart';
import 'package:astrobandhan/screens/dashboard/dashboard_screen.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:astrobandhan/widgets/custom_app_bar_widget.dart';
import 'package:astrobandhan/widgets/custom_button.dart';
import 'package:astrobandhan/widgets/custom_pinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isFromForgetPassword;
  const OtpVerifyScreen(
      {super.key,
      required this.phoneNumber,
      required this.isFromForgetPassword});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
                AppBarWidget(title: 'OTP Verification', textAlignCenter: true),
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
                                const SizedBox(height: 60),
                                SvgPicture.asset(
                                  "assets/SVG/auth/otp_verify.svg",
                                  height: height * 0.300,
                                  width: width * 298,
                                ),
                                Gap(50),
                                Text(
                                  "OTP Verification",
                                  style: poppinsStyle500Medium.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                                Gap(10),
                                Center(
                                  child: OtpPinInput(
                                    
                                    controller: otpController,
                                    length: 4,
                                    onCompleted: (pin) {},
                                  ),
                                ),
                                Gap(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Didn't receive code? ",
                                      style: poppinsStyle400Regular.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                       Provider.of<AuthProvider>(context).loginWithOtp(widget.phoneNumber, callback: (){
                                        
                                       });
                                      },
                                      child: Text(
                                        "Resend",
                                        style: poppinsStyle500Medium.copyWith(
                                          fontSize: 14,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(30),
                                Consumer<AuthProvider>(
                                    builder: (context, provider, child) {
                                  return CustomButtons.saveButton(
                                      onPressed: () {
                                        if (otpController.text.isEmpty) {
                                          showToastMessage(
                                              "please enter  otp code");
                                        } else if (otpController
                                                .text.characters.length <=
                                            3) {
                                          showToastMessage(
                                              "please enter a valid otp code");
                                          return;
                                        } else {
                                          provider.otpValidation(
                                              widget.phoneNumber,
                                              otpController.text,
                                              callback: (value) {
                                           if(value){
                                             widget.isFromForgetPassword
                                                  ? Helper.pushRemoveScreen(
                                                      context,
                                                      ChangePasswordScrren(phoneNumber: widget.phoneNumber,))
                                                  : Helper.pushRemoveScreen(
                                                      context, DashboardScreen());
                                           }
                                              });
                                        
                                        }

                                        // Verify OTP logic
                                        // if (otpController.text.length == 4) {
                                        //   // Add your OTP verification logic here
                                        //   Helper.pushRemoveScreen(
                                        //       context, ChangePasswordScrren());
                                        // } else {
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(
                                        //     SnackBar(
                                        //         content: Text(
                                        //             "Please enter a valid OTP")),
                                        //   );
                                        // }
                                      },
                                      text: 'Continue');
                                }),
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
      resizeToAvoidBottomInset: true,
    );
  }
}

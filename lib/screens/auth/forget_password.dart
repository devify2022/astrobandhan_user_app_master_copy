import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/auth_provider.dart';
import 'package:astrobandhan/screens/auth/otp_verify_screen.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:astrobandhan/widgets/custom_app_bar_widget.dart';
import 'package:astrobandhan/widgets/custom_button.dart';
import 'package:astrobandhan/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _phoneNumber = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
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
                AppBarWidget(title: 'Forget Password', textAlignCenter: false),
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
                                  "assets/SVG/auth/forget_password.svg",
                                  height: hight * 0.300,
                                  width: width * 298,
                                ),
                                Gap(50),
                                Text(
                                  "Forget Password?",
                                  style: poppinsStyle500Medium.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                                Gap(10),
                                CustomTextField(
                                  isShowTopText: false,
                                  hintText: 'Your Mobile',
                                  controller: _phoneNumber,
                                  keyboardType: TextInputType.phone,
                                  autofillHints: [
                                    AutofillHints.telephoneNumber
                                  ],
                                  focusNode: phoneFocusNode,
                                ),

                                const Gap(10),
                                // BlocConsumer<LoginCubit, LoginState>(
                                //   listener: (context, state) async {
                                //     print('Current LoginState: $state');
                                //     if (state.isSuccess) {
                                //       final prefs = await SharedPreferences.getInstance();
                                //       await prefs.setBool('isLoggedIn', true);
                                //       if (state.freeChatAvailable) {
                                //         Navigator.pushReplacement(
                                //           context,
                                //           MaterialPageRoute(builder: (context) => ChatScreen()),
                                //         );
                                //       } else {
                                //         Navigator.pushReplacement(
                                //           context,
                                //           MaterialPageRoute(builder: (context) => BottomBar(i: 0)),
                                //         );
                                //       }
                                //     } else if (state.errorMessage != null) {
                                //       print('Login Error: ${state.errorMessage}');
                                //       ScaffoldMessenger.of(context).showSnackBar(
                                //         SnackBar(content: Text(state.errorMessage!)),
                                //       );
                                //     }
                                //   },
                                //   builder: (context, state) {
                                //     if (state.isLoading) {
                                //       return Center(child: CircularProgressIndicator());
                                //     }
                                //     return CustomButtons.saveButton(
                                //       onPressed: state.isLoading
                                //           ? () {}
                                //           : () {
                                //         print('Phone: ${phoneController.text}');
                                //         print('Password: ${passwordController.text}');
                                //
                                //         context.read<LoginCubit>().login(
                                //           phoneController.text,
                                //           passwordController.text.trim(),
                                //         );
                                //       },
                                //       text: 'LOGIN',
                                //     );
                                //   },
                                // ),

                                Consumer<AuthProvider>(
                                    builder: (context, provider, child) {
                                  return CustomButtons.saveButton(
                                      onPressed: () {
                                        provider.loginWithOtp(_phoneNumber.text,
                                            callback: (value) {
                                          if (value) {
                                            Helper.pushRemoveScreen(
                                                context,
                                                OtpVerifyScreen(
                                                  phoneNumber:
                                                      _phoneNumber.text,
                                                  isFromForgetPassword: true,
                                                ));
                                          }
                                        });

                                        // });
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
    );
  }
}

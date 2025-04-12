import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/auth_provider.dart';
import 'package:astrobandhan/screens/auth/create_account.dart';
import 'package:astrobandhan/screens/auth/forget_password.dart';
import 'package:astrobandhan/screens/auth/login_with_otp_screen.dart';
import 'package:astrobandhan/screens/dashboard/dashboard_screen.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/widgets/custom_app_bar_widget.dart';
import 'package:astrobandhan/widgets/custom_button.dart';
import 'package:astrobandhan/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(ImageResources.screenBG, fit: BoxFit.cover)),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                AppBarWidget(title: 'LOGIN', textAlignCenter: true),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, MediaQuery.of(context).viewInsets.bottom + 24.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 60),
                                CustomTextField(
                                  hintText: 'Your Mobile',
                                  labelText: 'Mobile',
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  autofillHints: [AutofillHints.telephoneNumber],
                                  focusNode: phoneFocusNode,
                                  nextFocusNode: passwordFocusNode,
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  hintText: 'Your Password',
                                  labelText: 'Password',
                                  isPassword: true,
                                  controller: passwordController,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.visiblePassword,
                                  autofillHints: [AutofillHints.password],
                                  onEditingComplete: () => TextInput.finishAutofillContext(),
                                  focusNode: passwordFocusNode,
                                ),
                                const SizedBox(height: 24),
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

                                Consumer<AuthProvider>(builder: (context, provider, child) {
                                  return CustomButtons.saveButton(
                                      onPressed: () {
                                        provider.signIn(phoneController.text, passwordController.text, callback: (value) {
                                          if (value) {
                                            Helper.pushRemoveScreen(context, DashboardScreen());
                                          }
                                        });
                                      },
                                      text: 'LOGIN');
                                }),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomButtons.buildOutlinedButton(
                                    'Forgot Password?',
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.5))),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text('Or', style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withValues(alpha: 0.7)))),
                                    Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.5))),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                CustomButtons.saveButton(
                                    onPressed: () {
                                      Helper.toScreen(context, LoginWithOtpScreen());
                                    },
                                    text: 'LOGIN WITH OTP'),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account? ",
                                        style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withValues(alpha: 0.7))),
                                    CustomButtons.buildOutlinedButton(
                                      'Sign Up',
                                      () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => BlocProvider(
                                        //       create: (_) => CreateAccountCubit(),
                                        //       child: CreateAccount(),
                                        //     ),
                                        //   ),
                                        // );

                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
                                      },
                                    ),
                                  ],
                                ),
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

import 'package:astrobandhan/screens/auth/LoginScreen.dart';
import 'package:astrobandhan/screens/auth/create_account.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/utils/size.util.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:astrobandhan/widgets/custom_parent_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomParentWidget(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
        sized: false,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                  child: Image.asset(ImageResources.background_home,
                      fit: BoxFit.cover)),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0,
                    MediaQuery.of(context).viewInsets.bottom + 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text('Astro Bandhan',
                              style: interStyle900Black.copyWith(fontSize: 30)),
                          spaceHeight20,
                          Container(
                            height: 290,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.50),
                                  width: 1),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFF232324)
                                        .withValues(alpha: 0.2),
                                    blurRadius: 9,
                                    spreadRadius: 1)
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text('Welcome',
                                      style: poppinsStyle500Medium.copyWith(
                                          fontSize: 32)),
                                  Text(
                                      'Connect instantly with real-time astrologers or explore insights from our AI astrologer.',
                                      style: interStyle300Light.copyWith(
                                          fontSize: 16),
                                      textAlign: TextAlign.center),
                                  spaceHeight20,
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                      );
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Center(
                                          child: Text('LOGIN',
                                              style: poppinsStyle500Medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: kPrimaryColor))),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CreateAccount()));
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                            alpha:
                                                0.10), // background color with 10% opacity
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                              alpha:
                                                  0.20), // border color with 20% opacity
                                          width: 1, // 1px border width
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                                alpha:
                                                    0.1), // shadow color with 25% opacity
                                            offset: Offset(0,
                                                4), // shadow offset (0px x, 4px y)
                                            blurRadius:
                                                10, // shadow blur radius
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                          child: Text('CREATE AN ACCOUNT',
                                              style: poppinsStyle500Medium
                                                  .copyWith(fontSize: 16))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

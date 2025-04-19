import 'dart:ui';
import 'package:astrobandhan/datasource/model/auth/user_model.dart';
import 'package:astrobandhan/screens/astromall/astromall.dart';
import 'package:astrobandhan/screens/history/history_screen.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/home_provider.dart';
import 'package:astrobandhan/screens/auth/LoginScreen.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../user/userDetail_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.80,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white.withValues(alpha: 0.06),
      // Transparent background
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        enabled: true,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24)),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2), width: 1)),
          child: Column(
            children: [
              _buildProfileSection(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildDrawerItem(
                      icon: ImageResources.home,
                      title: 'Home',
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        // Navigate to Home
                      },
                    ),
                    _buildDrawerItem(
                      icon: ImageResources.pooja,
                      title: 'Book A Pooja',
                      onTap: () {
                        // showInfoDialog("No Data Found!", context);
                        // Navigate to Book A Pooja
                      },
                    ),
                    _buildDrawerItem(
                      icon: ImageResources.contact_us,
                      title: 'Contact Us',
                      onTap: () {
                        Navigator.pop(context);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ContactUsPage()),
                        // );
                        // Navigate to Contact Us
                      },
                    ),
                    _buildDrawerItem(
                      icon: 'assets/SVG/history.svg',
                      title: 'History',
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HistoryScreen()),
                        );

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => BottomBar(i: 4)),
                        // );
                      },
                    ),
                    _buildDrawerItem(
                      icon: 'assets/SVG/home.svg',
                      title: 'Remedies',
                      onTap: () {
                        Navigator.pop(context); // Close the drawer first
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AstromallScreen()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: 'assets/SVG/home.svg',
                      title: 'Connect With Astrologer',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to Connect With Astrologer
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Not Available, Comming soon"),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: 'assets/SVG/home.svg',
                      title: 'Free Services',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to Free Services
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Not Available, Comming soon"),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: 'assets/SVG/home.svg',
                      title: 'Palm Reading',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to Palm Reading
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Not Available, Comming soon"),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: 'assets/SVG/home.svg',
                      title: 'Update Your App',
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to Update Your App
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Not Available, Comming soon"),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: 'assets/SVG/home.svg',
                      title: 'Share Your App',
                      onTap: () {
                        Navigator.pop(context);
                        // Implement share functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Not Available, Comming soon"),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: 'assets/SVG/home.svg',
                      title: 'Log out',
                      onTap: () async {
                        Navigator.pop(context);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove(AppConstant.userInfo);
                        await prefs.remove(AppConstant.token);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                        // Implement share functionality
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0xFF374151), width: 1))),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1), width: 1),
                image: provider.userModel.photo == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(provider.userModel.photo!),
                        fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(toTitleCase("${provider.userModel.name}"),
                    style: poppinsStyle600SemiBold.copyWith(fontSize: 18)),
                SizedBox(height: 4),
                Text(
                  toTitleCase("${provider.userModel.phone}"),
                  style: interStyle400Regular.copyWith(
                      color: Colors.white.withValues(alpha: 0.7)),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsScreen(
                      userModel:
                          provider.userModel, // Pass the userModel object
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDrawerItem(
      {required String icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
        leading: SvgPicture.asset(icon,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            width: 18,
            height: 18),
        title:
            Text(title, style: poppinsStyle400Regular.copyWith(fontSize: 16)),
        onTap: onTap,
        contentPadding: const EdgeInsets.only(left: 10, bottom: 2),
        dense: true);
  }
}
//   Future<void> getUserDetails() async {
//     final prefs = await SharedPreferences.getInstance();

//     setState(() {
//       name = prefs.getString('name') ?? 'Sayan Paul';
//       number = prefs.getString('phone') ?? '+91 9988664422';
//       avatar = prefs.getString('avatar') ?? 'https://img.freepik.com/free-psd/portrait-man-teenager-isolated_23-2151745771.jpg';
//     });
//   }
// }

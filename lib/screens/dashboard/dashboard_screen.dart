import 'dart:ui';

import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/dashboard_provider.dart';
import 'package:astrobandhan/screens/ai/ai_astro_screen.dart';
import 'package:astrobandhan/screens/astrologer/astrologer_screen.dart';
import 'package:astrobandhan/screens/dashboard/widget/drawer.dart';
import 'package:astrobandhan/screens/history/history_screen.dart';
import 'package:astrobandhan/screens/home/home_scrren.dart';
import 'package:astrobandhan/screens/wallet/wallet_screen.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Widget> _screens = [
    HomeScrren(),
    AiAstroScreen(),
    Container(),
    AstrologerScreen(),
    HistoryScreen(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    providerHome.getAstrologers(isFirstTime: true);
    providerHome.getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xff0f0f60),
          statusBarIconBrightness: Brightness.light),
      sized: true,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                }),
            title: Text('Astro Bandhan',
                style: interStyle700Bold.copyWith(fontSize: 18)),
            centerTitle: true,
            actions: [
              // IconButton(
              //     icon: SvgPicture.asset(ImageResources.search,
              //         width: 20, height: 20),
              //     onPressed: () {}),
              IconButton(
                  icon: SvgPicture.asset(ImageResources.wallet,
                      width: 20, height: 20),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WalletScreen()));
                  }),
              IconButton(
                  icon: SvgPicture.asset(ImageResources.bell,
                      width: 20, height: 20),
                  onPressed: () {}),
            ],
          ),
          drawer: CustomDrawer(),
          body: Consumer<DashboardProvider>(
              builder: (context, dashboardProvider, child) => PageView.builder(
                  itemCount: _screens.length,
                  controller: dashboardProvider.pageController,
                  onPageChanged: dashboardProvider.setCurrentIndex,
                  itemBuilder: (context, index) {
                    return _screens[index];
                  })),
          bottomNavigationBar: Consumer<DashboardProvider>(
              builder: (context, dashBoardProvider, child) => Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF3C00FF).withValues(alpha: 0.5),
                          const Color(0xFF3C00FF).withValues(alpha: 0.3),
                          const Color(0xFFAAFF00).withValues(alpha: 0.35),
                        ],
                      ),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            spreadRadius: 1,
                            blurRadius: 50,
                            offset: Offset(0, 0))
                      ],
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: -4),
                      child: Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18)),
                          color: Colors.transparent,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF3C00FF).withValues(alpha: 0.3),
                              const Color(0xFF3C00FF).withValues(alpha: 0.3),
                              const Color(0xFFAAFF00).withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                        child: BottomNavigationBar(
                          currentIndex: dashBoardProvider.currentIndex,
                          backgroundColor: Colors.transparent,
                          type: BottomNavigationBarType.fixed,
                          selectedItemColor: Colors.white,
                          unselectedItemColor: Colors.grey[400],
                          selectedLabelStyle: interStyle700Bold,
                          unselectedLabelStyle: interStyle700Bold.copyWith(
                              color: Colors.grey[400]),
                          onTap: dashBoardProvider.setCurrentIndex,
                          items: [
                            buildBottomNavigationBarItem(ImageResources.home,
                                'Home', 0, dashBoardProvider.currentIndex),
                            buildBottomNavigationBarItem(ImageResources.ai,
                                'Ai Astro', 1, dashBoardProvider.currentIndex),
                            buildBottomNavigationBarItem(ImageResources.live,
                                'Live', 2, dashBoardProvider.currentIndex),
                            buildBottomNavigationBarItem(ImageResources.ask,
                                'Chat', 3, dashBoardProvider.currentIndex),
                            buildBottomNavigationBarItem(ImageResources.history,
                                'History', 4, dashBoardProvider.currentIndex),
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      String imageURL, String title, int position, int currentIndex) {
    return BottomNavigationBarItem(
      icon: Container(
          margin: EdgeInsets.only(bottom: 8),
          child: SvgPicture.asset(
            imageURL,
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
                position == currentIndex
                    ? Colors.white
                    : Colors.grey.withValues(alpha: 0.9),
                BlendMode.srcIn),
          )),
      label: title,
    );
  }
}

import 'dart:ui';

import 'package:astrobandhan/Service/SocketService.dart';
import 'package:astrobandhan/helper/Chat_Overlay_button_widget.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/dashboard_provider.dart';
import 'package:astrobandhan/provider/socket_provider.dart';
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
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
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
  @override
  void initState() {
    super.initState();

    providerHome.getAstrologers(isFirstTime: true);
    providerHome.getUserDetails();

    // Post frame ensures PageView is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      dashboardProvider
          .setCurrentIndex(0); // This internally calls jumpToPage(0)

      final userId = providerHome.homeRepo.authRepo.getUserInfoData()?.id;
      if (userId != null && userId.isNotEmpty) {
        print('Initializing socket for user: $userId');
        Provider.of<SocketProvider>(context, listen: false)
            .initializeSocket(userId);
      }
    });

    _initializeAsyncTasks();
  }

  Future<void> _initializeAsyncTasks() async {
    // Request Camera and Storage permissions
    await _requestPermissions();
    OneSignal.Notifications.requestPermission(true);
    // Initialize socket after the first frame
  }

  Future<void> _requestPermissions() async {
    // Request permissions for camera, storage, and gallery
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.photos,
    ].request();

    // Check if all permissions are granted
    bool isCameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    bool isStorageGranted = statuses[Permission.storage]?.isGranted ?? false;
    bool isPhotosGranted = statuses[Permission.photos]?.isGranted ?? false;

    if (isCameraGranted && isStorageGranted && isPhotosGranted) {
      print("All permissions granted!");
      // Proceed with your logic to open the camera or gallery
    } else {
      print("Some permissions are denied. Please enable them in the settings.");
    }
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
            title: Text('Rudra Ganga',
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
          body: Stack(
            children: [
              // PageView.builder with proper consumer for DashboardProvider
              Consumer<DashboardProvider>(
                builder: (context, dashboardProvider, child) {
                  return PageView.builder(
                    itemCount: _screens.length,
                    controller: dashboardProvider.pageController,
                    onPageChanged: dashboardProvider.setCurrentIndex,
                    itemBuilder: (context, index) {
                      return _screens[index];
                    },
                  );
                },
              ),

              // Visibility widget wrapped with correct Positioned layout
              Consumer<SocketProvider>(
                builder: (context, socketProvider, child) {
                  return Visibility(
                    visible: socketProvider.isButtonVisible,
                    child: OverlayButtonWidget(),
                  );
                },
              ),
            ],
          ),
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
                                'Astro', 1, dashBoardProvider.currentIndex),
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

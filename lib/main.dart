import 'package:astrobandhan/Service/SocketService.dart';
import 'package:astrobandhan/helper/NotificationHandler.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/helper/library/month_year_picker/month_year_picker.dart';
import 'package:astrobandhan/localization/app_localization.dart';
import 'package:astrobandhan/provider/agora_provider.dart';
import 'package:astrobandhan/provider/astrologer_provider.dart';
import 'package:astrobandhan/provider/astromall_provider.dart';
import 'package:astrobandhan/provider/auth_provider.dart';
import 'package:astrobandhan/provider/balance_provider.dart';
import 'package:astrobandhan/provider/dashboard_provider.dart';
import 'package:astrobandhan/provider/home_provider.dart';
import 'package:astrobandhan/provider/language_provider.dart';
import 'package:astrobandhan/provider/localization_provider.dart';
import 'package:astrobandhan/provider/overlay_provider.dart';
import 'package:astrobandhan/provider/setting_provider.dart';
import 'package:astrobandhan/provider/socket_provider.dart';
import 'package:astrobandhan/provider/splash_provider.dart';
import 'package:astrobandhan/provider/theme_provider.dart';
import 'package:astrobandhan/provider/user_provider.dart';
import 'package:astrobandhan/screens/dashboard/dashboard_screen.dart';
import 'package:astrobandhan/screens/splash/splash.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:astrobandhan/utils/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'di_container.dart' as di;
import 'package:astrobandhan/helper/Chat_Overlay_button_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:astrobandhan/helper/Observer/detectLifeCycle.observer.dart';
import 'package:astrobandhan/provider/NotifcationService_provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize OneSignal
  OneSignal.initialize("befff9f6-5ae6-4eeb-a989-fe2eabe52a82");

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  // Add subscription observer to log when device registers
  OneSignal.User.pushSubscription.addObserver((state) {
    print("🔔 OneSignal Subscription State Updated:");
    print("Player ID: ${state.current.id}");
    print("Is Subscribed: ${state.current.optedIn}");
    print("Token: ${state.current.token}");
  });

  // Add notification observer to log when notifications are received
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    print("📬 Notification received: ${event.notification.body}");
  });

  await di.init();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => OverlayProvider()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<DashboardProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<UserProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<HomeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AstromallProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AstrologerProvider>()),
      Provider<NotificationService>(create: (_) => NotificationService()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SettingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BalanceProvider>()),
      ChangeNotifierProvider(create: (_) => SocketProvider()),
      ChangeNotifierProxyProvider<SocketProvider, AgoraProvider>(
        create: (_) => AgoraProvider(socketProvider: null), // temporarily null
        update: (_, socketProvider, __) =>
            AgoraProvider(socketProvider: socketProvider),
      ),
      ChangeNotifierProvider<NotificationHandler>(
          create: (_) => NotificationHandler()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late AppLifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();

    // Create our lifecycle observer
    _lifecycleObserver = AppLifecycleObserver((isActive) {
      _handleAppStateChange(isActive);
    });

    // Register observer
    WidgetsBinding.instance.addObserver(_lifecycleObserver);

    // Initialize socket after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSocket(true); // Initialize with active state on first run
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  void _handleAppStateChange(bool isActive) {
    print("User is ${isActive ? 'active' : 'inactive'}");
    _initializeSocket(isActive);
  }

  void _initializeSocket(bool isActive) {
    // Get providers directly without using context in initState
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    // Fetch userId
    String? userId = authProvider.authRepo.getUserInfoData()?.id;

    if (userId != null && userId.isNotEmpty) {
      // First ensure the socket is initialized
      if (!socketProvider.isConnected) {
        socketProvider.initializeSocket(userId);
      }

      // Then emit user activity
      socketProvider.emitUserActivity(userId, isActive);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstant.languages) {
      locals.add(Locale(language.languageCode, language.countryCode));
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalization.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      builder: EasyLoading.init(),
      supportedLocales: locals,
      locale: Provider.of<LocalizationProvider>(context).locale,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: navigatorKey,
      title: 'Rudraganga: Talk to Astrologer',
      theme: AppTheme.getLightModeTheme(),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Stack(
            children: [
              authProvider.authRepo.checkTokenExist()
                  ? DashboardScreen()
                  : SplashScreen(),
            ],
          );
        },
      ),
    );
  }
}

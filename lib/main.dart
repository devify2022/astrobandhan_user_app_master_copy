import 'package:astrobandhan/helper/library/month_year_picker/month_year_picker.dart';
import 'package:astrobandhan/localization/app_localization.dart';
import 'package:astrobandhan/provider/astrologer_provider.dart';
import 'package:astrobandhan/provider/astromall_provider.dart';
import 'package:astrobandhan/provider/auth_provider.dart';
import 'package:astrobandhan/provider/balance_provider.dart';
import 'package:astrobandhan/provider/dashboard_provider.dart';
import 'package:astrobandhan/provider/home_provider.dart';
import 'package:astrobandhan/provider/language_provider.dart';
import 'package:astrobandhan/provider/localization_provider.dart';
import 'package:astrobandhan/provider/setting_provider.dart';
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

GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<DashboardProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<UserProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<HomeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AstromallProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AstrologerProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<UtilsProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<AddNewsProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<JobsProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<JobApplyProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<VariousProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<ListingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SettingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BalanceProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<CompanyProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<LocationHelperProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<HelperProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<BoxProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<BeachProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<MapHelperProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<HomePageProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<PublicationsProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<DestinationProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<PlacesDetailProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<PoiMenuProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<NewsProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<AddressProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<BugsReportProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<BusProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<HotelProvider>()),
      // ChangeNotifierProvider(create: (context) => di.sl<Hotel2Provider>()),
      // ChangeNotifierProvider(create: (context) => MainProvider()),
      // ChangeNotifierProvider(create: (context) => SearchProvider()),
      // ChangeNotifierProvider(create: (context) => DataStorageProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstant.languages) {
      locals.add(Locale(language.languageCode, language.countryCode));
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        // Color for Android
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalization.delegate,
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      builder: EasyLoading.init(),
      supportedLocales: locals,
      locale: Provider.of<LocalizationProvider>(context).locale,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      // add this
      navigatorKey: navigatorKey,
      title: 'Rudraganga: Talk to Astrologer',
      theme: AppTheme.getLightModeTheme(),
      home: Provider.of<AuthProvider>(context).authRepo.checkTokenExist()
          ? DashboardScreen()
          : SplashScreen(),
    );
  }
}

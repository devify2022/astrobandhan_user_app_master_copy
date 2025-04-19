import 'package:astrobandhan/datasource/remote/dio/logging_interceptor.dart';
import 'package:astrobandhan/datasource/repository/astrologer_repo.dart';
import 'package:astrobandhan/datasource/repository/astromall_repo.dart';
import 'package:astrobandhan/datasource/repository/auth_repo.dart';
import 'package:astrobandhan/datasource/repository/balance_repo.dart';
import 'package:astrobandhan/datasource/repository/home_repo.dart';
import 'package:astrobandhan/datasource/repository/language_repo.dart';
import 'package:astrobandhan/datasource/repository/settings_repo.dart';
import 'package:astrobandhan/datasource/repository/splash_repo.dart';
import 'package:astrobandhan/datasource/repository/user_repo.dart';
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
import 'package:astrobandhan/provider/user_provider.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'datasource/remote/dio/dio_client.dart';
import 'provider/theme_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  //sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => DioClient(AppConstant.baseUrl, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(
      () => SplashRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => LanguageRepo());

  sl.registerLazySingleton(() => AstromallRepo(dioClient: sl()));
  sl.registerLazySingleton(() => SettingsRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BalanceRepo(dioClient: sl()));
  sl.registerLazySingleton(() => AstrologerRepo(dioClient: sl()));
  sl.registerLazySingleton(() => UserRepo(
      dioClient:
          sl())); // Assuming this is how you're handling user-related data
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => HomeRepo(dioClient: sl(), authRepo: sl()));
  // sl.registerLazySingleton(() => DestinationRepo(dioClient: sl()));
  // sl.registerLazySingleton(() => PlacesDetailServices(dioClient: sl()));
  // sl.registerLazySingleton(() => PoiMenuRepo(dioClient: sl()));
  // sl.registerLazySingleton(() => PoiFilterServices(dioClient: sl()));
  // sl.registerLazySingleton(() => NewsRepo(dioClient: sl()));
  // sl.registerLazySingleton(() => BugsRepo(dioClient: sl()));
  // sl.registerLazySingleton(() => CartRepo(dioClient: sl()));
  // sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), authRepo: sl()));
  // sl.registerLazySingleton(() => BusRepo(dioClient: sl()));
  // sl.registerLazySingleton(() => HotelRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(
      () => ThemeProvider(sharedPreferences: sl(), splashRepo: sl()));
  sl.registerFactory(() => DashboardProvider());
  sl.registerFactory(() => BalanceProvider(balanceRepo: sl()));
  sl.registerFactory(() => AstromallProvider(astromallRepo: sl()));

  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => AstrologerProvider(astrologerRepo: sl()));
  sl.registerFactory(() => UserProvider(
      authRepo: sl(), userRepo: sl())); // Adjust based on your repo name

  sl.registerFactory(() => HomeProvider(homeRepo: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));

  // sl.registerFactory(() => VariousProvider(variousRepo: sl()));
  // sl.registerFactory(() => WishListProvider(wishListRepo: sl()));
  // sl.registerFactory(() => ChatProvider(messageRepo: sl()));
  // sl.registerFactory(() => JobsProvider(jobRepo: sl()));
  // sl.registerFactory(() => JobApplyProvider(jobApplyRepo: sl()));
  // sl.registerFactory(() => LocationProvider(utilsRepo: sl()));
  // sl.registerFactory(() => UtilsProvider(utilsRepo: sl()));
  // sl.registerFactory(() => AddNewsProvider(utilsRepo: sl(),newsRepo: sl()));
  // sl.registerFactory(() => MainPlacesProvider(placesMobileServices: sl(),poiFilterServices: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => SettingProvider(settingsRepo: sl()));
  // sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  // sl.registerFactory(() => DestinationProvider(destinationRepo: sl()));
  // sl.registerFactory(() => PoiMenuProvider(poiMenuRepo: sl()));
  // sl.registerFactory(() => NewsProvider(newsRepo: sl()));
  // sl.registerFactory(() => BugsReportProvider(bugsRepo: sl(),utilsRepo: sl()));
  // sl.registerFactory(() => CartProvider(cartRepo: sl()));
  // sl.registerFactory(() => OrderProvider(cartRepo: sl()));
  // sl.registerFactory(() => BusProvider(busRepo: sl()));
  // sl.registerFactory(() => HotelProvider(hotelRepo: sl()));
  // sl.registerFactory(() => Hotel2Provider(hotelRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}

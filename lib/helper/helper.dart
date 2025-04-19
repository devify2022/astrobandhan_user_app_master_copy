import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Directory, File, HttpClient, HttpClientRequest, Platform;

import 'package:astrobandhan/datasource/model/auth/login_user_model.dart';
import 'package:astrobandhan/datasource/model/others/language_model.dart';
import 'package:astrobandhan/helper/library/swipeable_page_route/swipeable_page_route.dart';
import 'package:astrobandhan/provider/astromall_provider.dart';
import 'package:astrobandhan/provider/auth_provider.dart';
import 'package:astrobandhan/provider/balance_provider.dart';
import 'package:astrobandhan/provider/home_provider.dart';
import 'package:astrobandhan/provider/language_provider.dart';
import 'package:astrobandhan/provider/localization_provider.dart';
import 'package:astrobandhan/provider/setting_provider.dart';
import 'package:astrobandhan/provider/theme_provider.dart';
import 'package:astrobandhan/screens/wallet/wallet_screen.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

AuthProvider get providerAuth =>
    Provider.of<AuthProvider>(navigatorKey.currentState!.context,
        listen: false);

BalanceProvider get providerBalance =>
    Provider.of<BalanceProvider>(navigatorKey.currentState!.context,
        listen: false);

ThemeProvider get providerTheme =>
    Provider.of<ThemeProvider>(navigatorKey.currentState!.context,
        listen: false);

LanguageProvider get providerLanguage =>
    Provider.of<LanguageProvider>(navigatorKey.currentState!.context,
        listen: false);

LocalizationProvider get providerLocalization =>
    Provider.of<LocalizationProvider>(navigatorKey.currentState!.context,
        listen: false);

HomeProvider get providerHome =>
    Provider.of<HomeProvider>(navigatorKey.currentState!.context,
        listen: false);
AstromallProvider get providerAstromall =>
    Provider.of<AstromallProvider>(navigatorKey.currentState!.context,
        listen: false);
SettingProvider get providerSetting =>
    Provider.of<SettingProvider>(navigatorKey.currentState!.context,
        listen: false);

LoginUserModel get loginUserModel => providerAuth.userModel;
// UserModel2 userModel2 = providerSetting.userModel2;

Locale get localeLanguage => providerLocalization.locale;

bool get darkThemeStatus => providerTheme.darkTheme;

// int get userID => providerAuth.getUserID();
//
// String get userToken => providerAuth.getUserToken();

double get screenHeight =>
    MediaQuery.of(navigatorKey.currentState!.context).size.height;

double get screenWeight =>
    MediaQuery.of(navigatorKey.currentState!.context).size.width;

Locales localText(List<Locales> locales) {
  Locales locale = locales
          .where((element) =>
              element.language.toString().toUpperCase() ==
              providerLocalization.locale.languageCode.toUpperCase())
          .isNotEmpty
      ? locales.firstWhere((element) =>
          element.language.toString() ==
          localeLanguage.languageCode.toUpperCase())
      : locales[0];
  // Locales locale = locales.firstWhere((element) => element.language.toString() == localeLanguage.languageCode.toUpperCase());
  return locale;
}

String localTextConvertToName(List<Locales>? locales, String name) {
  String nameTitle =
      locales != null && locales.isNotEmpty ? localText(locales).name! : name;
  return nameTitle;
}

setDeviceID() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString(AppConstant.deviceId) == null) {
    var deviceId = const Uuid().v4();
    prefs.setString(AppConstant.deviceId, deviceId);
  }
}

Future<String?> getDeviceID() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(AppConstant.deviceId);
}

String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

Future<File?> downloadFile(String url, String filename) async {
  try {
    HttpClient httpClient = HttpClient();
    HttpClientRequest httpClientRequest =
        await httpClient.getUrl(Uri.parse(url));
    var response = await httpClientRequest.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    var finalPath = '$dir/$filename';
    File file = File(finalPath);

    if (await file.exists()) {
      await file.delete();
    }

    await file.writeAsBytes(bytes);
    return file;
  } catch (e) {
    return null;
  }
}

showSnackMessage(String message, {duration = 2, bool isError = true}) {
  ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 14)),
          backgroundColor: isError ? Colors.red : kPrimaryColor,
          duration: Duration(seconds: duration)));
}

showToastMessage(String message,
    {length = Toast.LENGTH_SHORT,
    bool isError = true,
    gravity = ToastGravity.TOP}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: isError
          ? Colors.red
          : !isError
              ? Colors.green
              : kPrimaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

//  List<Color> gradientColors = [
//     Color.fromRGBO(170, 255, 0, 0.4),
//     Color.fromRGBO(60, 0, 255, 0.4),
//   ];

Future<void> extractSharedPreferencesData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    List<Map<String, dynamic>> sharedPreferencesData = [];
    for (String key in keys) {
      final value = prefs.get(key);
      if (key == 'refreshToken' || key == 'deviceId' || key == 'token')
        sharedPreferencesData.add({key: value});
    }
    // Save the data to a file
    await saveJsonToFile({'sharedPreferences': sharedPreferencesData},
        'shared_preferences_data');
  } catch (e) {}
}

Future<void> showSuccessDialog(String message, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap the button to dismiss
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent, // Makes the background transparent
        child: _buildSuccessDialogContent(context, message),
      );
    },
  );
}

Widget _buildSuccessDialogContent(BuildContext context, String message) {
  return Container(
    padding: const EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      color: Colors.white, // Dialog background color
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0))
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min, // To make the dialog compact
      children: <Widget>[
        // Success Animation
        Lottie.asset('assets/animations/success.json',
            width: 100, height: 100, fit: BoxFit.cover),
        const SizedBox(height: 15),
        // Success Message
        Text("Success!",
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[700])),
        const SizedBox(height: 10),
        // Optional Additional Message
        Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, color: Colors.grey[700])),
        const SizedBox(height: 20),
        // Confirmation Button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => WalletScreen()));
            },
            child: Text("OK",
                style: TextStyle(color: Colors.blue, fontSize: 16.0)),
          ),
        ),
      ],
    ),
  );
}

Future<void> saveJsonToFile(
    Map<String, dynamic> jsonData, String fileName) async {
  try {
    // Get the directory to save the file
    final directory = await getApplicationDocumentsDirectory();
    final assetsDirectory = Directory('${directory.path}/assets');

    // Create the assets directory if it doesn't exist
    if (!await assetsDirectory.exists()) {
      await assetsDirectory.create(recursive: true);
    }

    // Create the file path
    final filePath = '${assetsDirectory.path}/$fileName.txt';
    final file = File(filePath);

    // Convert JSON data to a string
    final jsonString = jsonEncode(jsonData);

    // Write the string to the file
    await file.writeAsString(jsonString);
  } catch (e) {}
}

class Helper {
  static setHeight(BuildContext context, {height = 1}) {
    return MediaQuery.of(context).size.height * height;
  }

  static setWidth(BuildContext context, {width = 1}) {
    return MediaQuery.of(context).size.width * width;
  }

  static toScreen(context, screen) {
    Navigator.of(context).push(SwipeablePageRoute(
        canOnlySwipeFromEdge: true,
        backGestureDetectionWidth: 10,
        builder: (BuildContext context) => screen));
  }

  static void pushRemoveScreen(BuildContext context, Widget screen) {
    Navigator.of(context).pushAndRemoveUntil(
      SwipeablePageRoute(
        canOnlySwipeFromEdge: true,
        backGestureDetectionWidth: 10,
        builder: (BuildContext context) => screen,
      ),
      (route) => false,
    );
  }

  static toReplacementScreenSlideRightToLeft(context, screen) {
    Navigator.of(context).push(SwipeablePageRoute(
        canOnlySwipeFromEdge: true,
        backGestureDetectionWidth: 10,
        builder: (BuildContext context) => screen));
    //  Navigator.pushReplacement(context, SlideRightToLeft(page: screen));
  }

  static toReplacementScreenSlideLeftToRight(context, screen) {
    Navigator.of(context).push(SwipeablePageRoute(
        canOnlySwipeFromEdge: true,
        backGestureDetectionWidth: 10,
        builder: (BuildContext context) => screen));
    //   Navigator.pushReplacement(context, SlideLeftToRight(page: screen));
  }

  static circulProggress(context) {
    const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kAccentColor)));
  }

  static showLog(message) {
    log("APP SAYS: $message");
  }

  static boxDecoration(Color color, double radius) {
    BoxDecoration(
        color: color, borderRadius: BorderRadius.all(Radius.circular(radius)));
  }

  static openCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  static openEmail(String email) async {
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: email);
    await launchUrl(emailLaunchUri);
  }

  static openMap(double latitude, double longitude) async {
    // final Uri googleUrl = Uri(path: "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await launchUrl(Uri.parse(googleUrl))) {
      await canLaunchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  static openMap2(double lat, double long) async {
    final String googleMapslocationUrl =
        "google.navigation:q=$lat,$long&mode=d";

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    if (await canLaunchUrl(Uri.parse(encodedURl))) {
      await launchUrl(Uri.parse(encodedURl));
    } else {
      throw 'Could not launch $encodedURl';
    }
  }

  static Future launchGoogleMapsNavigation2(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=w");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  static openWhatsapp(String number) async {
    var whatsappAndroid = Uri.parse("whatsapp://send?phone=$number&text=");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {}
  }

  static openSocial(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static const REFRESH_TOKEN_KEY = 'refresh_token';
  static const BACKEND_TOKEN_KEY = 'backend_token';
  static const GOOGLE_ISSUER = 'https://accounts.google.com';
  static const GOOGLE_CLIENT_ID_IOS = '<IOS-CLIENT-ID>';
  static const GOOGLE_REDIRECT_URI_IOS =
      'com.googleusercontent.apps.<IOS-CLIENT-ID>:/oauthredirect';
  static const GOOGLE_CLIENT_ID_ANDROID = '<ANDROID-CLIENT-ID>';
  static const GOOGLE_REDIRECT_URI_ANDROID =
      'com.googleusercontent.apps242909337676-1kp349ib3hpbdrlqv8f5ev53emmec3dm.apps.googleusercontent.com:/oauthredirect';

  String clientID() {
    if (Platform.isAndroid) {
      return GOOGLE_CLIENT_ID_ANDROID;
    } else if (Platform.isIOS) {
      return GOOGLE_CLIENT_ID_IOS;
    }
    return '';
  }

  String redirectUrl() {
    if (Platform.isAndroid) {
      return GOOGLE_REDIRECT_URI_ANDROID;
    } else if (Platform.isIOS) {
      return GOOGLE_REDIRECT_URI_IOS;
    }
    return '';
  }

  utcConverter(String dateUtc) {
    var date = DateTime.tryParse(dateUtc)?.toLocal();

    const List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    String amPm = date!.hour >= 12 ? "pm" : "am";
    int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;

    String formattedDate =
        "${date.day}th ${months[date.month - 1]} ${date.year}, $hour.${date.minute.toString().padLeft(2, '0')}$amPm";
    return formattedDate;
  }

  cacheImages(BuildContext context, String url) {
    CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Icon(
        Icons.person,
        color: Colors.black,
      ),
      errorWidget: (context, url, error) =>
          Icon(Icons.error, color: Colors.black),
    );
  }
}

import 'dart:async';

import 'package:astrobandhan/datasource/repository/settings_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingProvider extends ChangeNotifier {
  final SettingsRepo settingsRepo;

  SettingProvider({required this.settingsRepo});

  Locale? locale;

  void setLocale(Locale value) {
    locale = value;
    notifyListeners();
  }

  bool isSystem = false;

  void systemToggle(BuildContext context) {
    isSystem = !isSystem;
    // updateNotification(context);

    notifyListeners();
  }

  bool isWhatsApp = false;

  void whatsAppToggle(BuildContext context) {
    isWhatsApp = !isWhatsApp;
    //updateNotification(context);

    notifyListeners();
  }

  bool isInfo = false;

  void infoToggle(BuildContext context) {
    isInfo = !isInfo;
    notifyListeners();
  }

  void setIsSendOtp() {
    // isSended = !isSended;
    notifyListeners();
  }

  int timeCount = 200;

  resetTimeCount() {
    timeCount = 200;
  }

  Timer? timer;

  startTimer(BuildContext context) {
    timeCount = 200;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeCount <= 0) {
        cancelTimer(context);
      } else {
        timeCount--;
        notifyListeners();
      }
    });
  }

  cancelTimer(BuildContext context) {
    // isSended = false;
    if (timer != null) timer!.cancel();
    notifyListeners();
  }

  bool isTextMessage = false;

  void textMessageToggle(BuildContext context) {
    isTextMessage = !isTextMessage;
    //updateNotification(context);

    notifyListeners();
  }

  bool isBiometric = false;
  bool isBiometricSwitched = true;

  setIsBiometric(bool isBiometricHere) {
    isBiometricSwitched = isBiometricHere;
    notifyListeners();
  }

  //biometric
//
//   final LocalAuthentication auth = LocalAuthentication();
//   SupportState supportState = SupportState.unknown;
//   bool? canCheckBiometrics;
//   List<BiometricType>? availableBiometrics;
//   String authorized = 'Not Authorized';
//   bool isAuthenticating = false;
//
//   initBio() {
//     auth.isDeviceSupported().then((bool isSupported) => supportState = isSupported ? SupportState.supported : SupportState.unsupported);
//     notifyListeners();
//   }
//
//   Future<void> checkBiometrics() async {
//     late bool canCheckBiometrics;
//     try {
//       canCheckBiometrics = await auth.canCheckBiometrics;
//     } on PlatformException {
//       canCheckBiometrics = false;
//     }
//     // if (!mounted) {
//     //   return;
//     // }
//
//     canCheckBiometrics = canCheckBiometrics;
//     notifyListeners();
//   }
//
//   Future<void> getAvailableBiometrics() async {
//     late List<BiometricType> availableBiometrics;
//     try {
//       availableBiometrics = await auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       availableBiometrics = <BiometricType>[];
//       print(e);
//     }
//     // if (!mounted) {
//     //   return;
//     // }
//
//     //setState(() {
//     availableBiometrics = availableBiometrics;
//     notifyListeners();
//
//     //});
//   }
//
//   Future<void> authenticate() async {
//     bool authenticated = false;
//     try {
//       isAuthenticating = true;
//       authorized = 'Authenticating';
//
//       authenticated = await auth.authenticate(
//         localizedReason: 'Let OS determine authentication method',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//         ),
//       );
//
//       isAuthenticating = false;
//     } on PlatformException catch (e) {
//       print(e);
//
//       isAuthenticating = false;
//       authorized = 'Error - ${e.message}';
//
//       return;
//     }
//     // if (!mounted) {
//     //   return;
//     // }
//
//     authorized = authenticated ? 'Authorized' : 'Not Authorized';
//     notifyListeners();
//   }
//
//   Future<void> authenticateWithBiometrics({BuildContext? ctx, bool? swiatch = true, bool fromSettings = false}) async {
//     final prefs = await SharedPreferences.getInstance();
//     bool authenticated = false;
//     try {
//       isAuthenticating = true;
//       authorized = 'Authenticating';
//       authenticated = await auth.authenticate(
//         localizedReason: 'Scan your fingerprint (or face or whatever) to authenticate',
//         options: const AuthenticationOptions(useErrorDialogs: true, sensitiveTransaction: true
//             //   stickyAuth: true,
//             //  biometricOnly: true,
//             // sensitiveTransaction: true
//             ),
//         // authMessages: [AndroidAuthMessages(
//         //   cancelButton: 'can',
//         //   goToSettingsButton: 'sadsd'
//         // ),
//         //
//         // ],
//       );
//
//       isAuthenticating = false;
//       authorized = 'Authenticating';
//
//       // if (!mounted) {
//       //   return;
//       // }
//
//       final String message = authenticated ? 'Authorized' : 'Not Authorized';
//       if (authenticated) {
//         //await auth.stopAuthentication();
//         //  Navigator.of(ctx).pop();
//         isBiometric = true;
//         prefs.setBool('isBiometric', true);
//         print('cckkfkkff ${swiatch}');
//         if (!swiatch!) {
//           isBiometric = false;
//
//           prefs.setBool('isBiometric', isBiometric);
//         }
//         notifyListeners();
//       } else {
//         if (fromSettings) {
//         } else {
//           SystemNavigator.pop();
//         }
//       }
//
//       // else{
//       //   SystemNavigator.pop();
//       // }
//       authorized = message;
//       notifyListeners();
//     } on PlatformException catch (e) {
//       print('sadasdadsdsa ${e}');
//       isAuthenticating = false;
//       authorized = 'Error - ${e.message}';
//       return;
//     }
//   }
//
//   Future<void> cancelAuthentication() async {
//     await auth.stopAuthentication();
// //   isAuthenticating = false;
//     notifyListeners();
//   }
//
//   void bioMetricToggle(BuildContext context) {
//     isBiometric = !isBiometric;
//     updateNotification(context);
//
//     notifyListeners();
//   }
//
//   bool isEmail = false;
//
//   void emailToggle(BuildContext context) {
//     isEmail = !isEmail;
//     updateNotification(context);
//
//     notifyListeners();
//   }
//
//   bool isMobile = false;
//
//   void mobileToggle(BuildContext context) {
//     isMobile = !isMobile;
//     updateNotification(context);
//     notifyListeners();
//   }
//
//   bool isListing = false;
//
//   void listingToggle(BuildContext context) {
//     isListing = !isListing;
//     updateNotification(context);
//     notifyListeners();
//   }
//
//   bool isSound = false;
//
//   void soundToggle(BuildContext context) {
//     isSound = !isSound;
//     updateNotification(context);
//     notifyListeners();
//   }
//
//   bool isMessage = false;
//
//   void messageToggle(BuildContext context) {
//     isMessage = !isMessage;
//     updateNotification(context);
//     notifyListeners();
//   }
//
//   int tapInd = 1;
//
//   void checkToggle(BuildContext context, i) {
//     tapInd = i;
//     //updateNotification(context);
//     notifyListeners();
//   }
//
//   bool isArrival = false;
//
//   void arrivalToggle(BuildContext context) {
//     if (tapInd == 0) {
//       fromTimeNoti = '';
//       endTimeNoti = '';
//       fromTimeNotiController.text = "";
//       endTimeSoundController.text = "";
//       isArrival = !isArrival;
//     }
//     updateNotification(context);
//     notifyListeners();
//   }
//
//   String fromTimeNoti = '08:00';
//   String endTimeNoti = '23:00';
//   String fromTimeSound = '08:00';
//   String endTimeSound = '23:00';
//   TextEditingController fromTimeNotiController = TextEditingController();
//   TextEditingController endTimeNotiController = TextEditingController();
//   TextEditingController fromTimeSoundController = TextEditingController();
//   TextEditingController endTimeSoundController = TextEditingController();
//   bool _isLoading = false;
//
//   bool get isLoading => _isLoading;
//
//   Future updateNotification(BuildContext context) async {
//     _isLoading = true;
//     // ChangeNotifyModel changeNotifyModel =ChangeNotifyModel();
//     // changeNotifyModel.system = isSystem;
//     // changeNotifyModel.email = isEmail;
//     // changeNotifyModel.mobile = isMobile;
//     // changeNotifyModel.onArrival = isArrival;
//     // changeNotifyModel.listings = isListing;
//     // changeNotifyModel.messages = isMessage;
//     // changeNotifyModel.time = isArrival==true?"": time;
//     Sound sound = Sound();
//     NotifyTime notifyTime = NotifyTime();
//     sound.active = isSound;
//     sound.start = fromTimeSoundController.text;
//     sound.end = endTimeSoundController.text;
//     notifyTime.timeStart = fromTimeNotiController.text;
//     notifyTime.timeEnd = endTimeNotiController.text;
//
//     //  changeNotifyModel.sound!.active = isSound;
//     print('post ${sound.toJson()}');
//     Map<String, dynamic> data = {
//       "system": isSystem,
//       "email": isEmail,
//       "mobile": isMobile,
//       "onArrival": isArrival,
//       "listings": isListing,
//       "messages": isMessage,
//       "time": notifyTime.toJson(),
//       "sound": sound.toJson()
//     };
//     userModel2 = UserModel2();
//     print("post data $data");
//     notifyListeners();
//     ApiResponse apiResponse = await settingsRepo.updateNotification(data);
//     _isLoading = false;
//
//     if (apiResponse.response.statusCode == 200) {
//       userModel2 = UserModel2.fromJson(apiResponse.response.data["value"]);
//
//       isSystem = userModel2.notification!.system!;
//       isEmail = userModel2.notification!.email!;
//       isMobile = userModel2.notification!.mobile!;
//       isMessage = userModel2.notification!.messages!;
//       isListing = userModel2.notification!.listings!;
//       isArrival = userModel2.notification!.onArrival!;
//       fromTimeNoti = userModel2.notification!.time!.timeStart ?? "";
//       fromTimeNotiController.text = userModel2.notification!.time!.timeStart ?? "";
//       endTimeNoti = userModel2.notification!.time!.timeEnd ?? "";
//       endTimeNotiController.text = userModel2.notification!.time!.timeEnd ?? "";
//       fromTimeSound = userModel2.notification!.sound!.start ?? "";
//       fromTimeSoundController.text = userModel2.notification!.sound!.start ?? "";
//       endTimeSound = userModel2.notification!.sound!.end ?? "";
//       endTimeSoundController.text = userModel2.notification!.sound!.end ?? "";
//       // isSound = userModel2.notification!.sound!.active!;
//       isSound = apiResponse.response.data["value"]["notification"]["sound"]["active"];
//       notifyListeners();
//
//       DateTime dateTime;
//       try {
//         dateTime = DateConverter.isoStringToLocalTime(userModel2.notification!.time!.timeStart.toString());
//         initialTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
//       } catch (e) {
//         initialTime = TimeOfDay.now();
//       }
//     } else {
//       Helper.showSnack(context, apiResponse.error.toString());
//     }
//     notifyListeners();
//   }
//
//   UserModel2 userModel2 = UserModel2();
//   bool expireToken = false;
//   String errorText = "";
//
//   Future getUser(BuildContext context, {bool isGuest = false, bool isFirstTime = false}) async {
//     userModel2 = UserModel2();
//     _isLoading = true;
//     if (!isFirstTime) notifyListeners();
//     errorText = "";
//     ApiResponse apiResponse = await settingsRepo.getUser();
//     _isLoading = false;
//     expireToken = false;
//     if (apiResponse.response.statusCode == 200) {
//       expireToken = false;
//       userModel2 = UserModel2.fromJson(apiResponse.response.data["value"]);
//       UserModel().userCV = apiResponse.response.data["value"]["userCVLink"];
//       isSystem = userModel2.notification!.system ?? false;
//       isEmail = userModel2.notification!.email ?? false;
//       isMobile = userModel2.notification!.mobile ?? false;
//       isMessage = userModel2.notification!.messages ?? false;
//       isListing = userModel2.notification!.listings ?? false;
//       isArrival = userModel2.notification!.onArrival ?? false;
//       fromTimeNoti = userModel2.notification!.time == null ? "" : userModel2.notification!.time!.timeStart ?? "";
//       fromTimeNotiController.text = userModel2.notification!.time == null ? "" : userModel2.notification!.time!.timeStart ?? "";
//       endTimeNoti = userModel2.notification!.time == null ? "" : userModel2.notification!.time!.timeEnd ?? "";
//       endTimeNotiController.text = userModel2.notification!.time == null ? "" : userModel2.notification!.time!.timeEnd ?? "";
//       fromTimeSound = userModel2.notification!.sound == null ? "" : userModel2.notification!.sound!.start ?? "";
//       fromTimeSoundController.text = userModel2.notification!.sound == null ? "" : userModel2.notification!.sound!.start ?? "";
//       endTimeSound = userModel2.notification!.sound == null ? "" : userModel2.notification!.sound!.end ?? "";
//       endTimeSoundController.text = userModel2.notification!.sound == null ? "" : userModel2.notification!.sound!.end ?? "";
//       isSound = userModel2.notification!.sound != null ? userModel2.notification!.sound!.active ?? false : false;
//       UserModel().uid = userModel2.id;
//       UserModel().username = userModel2.firstname;
//       UserModel().fName = userModel2.firstname;
//       UserModel().lName = userModel2.lastname;
//       UserModel().email = userModel2.email;
//       UserModel().phoneNo = userModel2.mobile;
//       UserModel().image = userModel2.image;
//       LanguageModel languageModel = LanguageModel();
//       var lang = apiResponse.response.data["value"]["language"].toUpperCase();
//       if (lang == "EN") {
//         languageModel.languageCode = "en";
//         languageModel.countryCode = "US";
//       } else if (lang == "SQ") {
//         languageModel.languageCode = "sq";
//         languageModel.countryCode = "AL";
//       } else if (lang == "IT") {
//         languageModel.languageCode = "it";
//         languageModel.countryCode = "IT";
//       }
//       providerTheme.toggleTheme(context, value: apiResponse.response.data["value"]["darkMode"]);
//       // providerLocalization.changeLanguage(languageModel, context, firstTime: true);
//       DateTime dateTime;
//       dateTime = DateConverter.isoStringToLocalTime(userModel2.notification!.time!.timeEnd!);
//       initialTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
//     } else {
//       _isLoading = false;
//       expireToken = true;
//       if (apiResponse.error.toString() == "Access Denied Exception") {
//         errorText = "Access Denied Exception";
//       } else {
//         // getUser(context);
//       }
//     }
//     notifyListeners();
//   }
//
//   getUserInfoFromJW2() {
//     Map<String, dynamic> payload = Jwt.parseJwt(UserModel().accessToken.toString());
//     UserModel().userCV = payload["user-information"]["userCVLink"];
//   }
//
//   // time
//   TimeOfDay initialTime = TimeOfDay.now();
//
//   void updateTime(BuildContext context, index) async {
//     TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: initialTime);
//     if (pickedTime != null) {
//       print(pickedTime);
//       if (index == 0) {
//         fromTimeNoti = '${pickedTime.hour > 9 ? pickedTime.hour : '0${pickedTime.hour}'}:${pickedTime.minute > 9 ? pickedTime.minute : '0${pickedTime.minute}'}:00';
//         isArrival = false;
//       } else {
//         endTimeNoti = '${pickedTime.hour > 9 ? pickedTime.hour : '0${pickedTime.hour}'}:${pickedTime.minute > 9 ? pickedTime.minute : '0${pickedTime.minute}'}:00';
//         isArrival = false;
//       }
//       updateNotification(context);
//
//       notifyListeners();
//     }
//   }
//
//   void updateTime2(BuildContext context, index) async {
//     TimeRange? pickedTime = await showCupertinoDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (BuildContext context) {
//         TimeOfDay startTime = initialTime;
//         TimeOfDay endTime = TimeOfDay.now();
//         return CupertinoAlertDialog(
//           content: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: 340,
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       TimeRangePicker(
//                         padding: 22,
//                         hideButtons: true,
//                         handlerRadius: 8,
//                         strokeWidth: 4,
//                         ticks: 12,
//                         fromText: "",
//                         toText: "",
//                         ticksColor: Theme.of(context).textTheme.displayLarge!.color!,
//                         activeTimeTextStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 22, color: Theme.of(context).textTheme.displayLarge!.color!),
//                         timeTextStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 22, color: Theme.of(context).textTheme.displayLarge!.color!),
//                         onStartChange: (start) {
//                           startTime = start;
//                           notifyListeners();
//                         },
//                         onEndChange: (end) {
//                           endTime = end;
//                           notifyListeners();
//                         },
//                       ),
//                       Positioned.directional(
//                           textDirection: Directionality.of(context),
//                           start: MediaQuery.of(context).size.width * 0.1,
//                           end: MediaQuery.of(context).size.width * 0.1,
//                           top: 15,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               CustomText(title: "From", fontSize: 14, color: Theme.of(context).textTheme.displayLarge!.color),
//                               CustomText(title: "To", fontSize: 14, color: Theme.of(context).textTheme.displayLarge!.color)
//                             ],
//                           ))
//                     ],
//                   ),
//                 ],
//               )),
//           actions: <Widget>[
//             CupertinoDialogAction(
//                 isDestructiveAction: true,
//                 child: const Text('Cancel'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 }),
//             CupertinoDialogAction(
//               child: const Text('Ok'),
//               onPressed: () {
//                 Navigator.of(context).pop(
//                   TimeRange(startTime: startTime, endTime: endTime),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//     print(pickedTime);
//     if (index == 0) {
//       fromTimeNoti =
//           '${pickedTime!.startTime.hour > 9 ? pickedTime.startTime.hour : '0${pickedTime.startTime.hour}'}:${pickedTime.startTime.minute > 9 ? pickedTime.startTime.minute : '0${pickedTime.startTime.minute}'}:00';
//
//       endTimeNoti =
//           '${pickedTime.endTime.hour > 9 ? pickedTime.endTime.hour : '0${pickedTime.endTime.hour}'}:${pickedTime.endTime.hour > 9 ? pickedTime.endTime.minute : '0${pickedTime.endTime.minute}'}:00';
//
//       fromTimeNotiController.text = fromTimeNoti.toString();
//       endTimeNotiController.text = endTimeNoti.toString();
//     } else {
//       fromTimeSound =
//           '${pickedTime!.startTime.hour > 9 ? pickedTime.startTime.hour : '0${pickedTime.startTime.hour}'}:${pickedTime.startTime.minute > 9 ? pickedTime.startTime.minute : '0${pickedTime.startTime.minute}'}:00';
//
//       endTimeSound =
//           '${pickedTime.endTime.hour > 9 ? pickedTime.endTime.hour : '0${pickedTime.endTime.hour}'}:${pickedTime.endTime.hour > 9 ? pickedTime.endTime.minute : '0${pickedTime.endTime.minute}'}:00';
//       fromTimeSoundController.text = fromTimeSound.toString();
//       endTimeSoundController.text = endTimeSound.toString();
//     }
//     isArrival = false;
//     updateNotification(context);
//
//     notifyListeners();
//   }
//
//   String statusSecurity = '';
//
//   String numberWhatsapp = '';
//
//   Future<void> getStatusSecurity() async {
//     try {
//       ApiResponse apiResponse;
//       apiResponse = await settingsRepo.getStatusSecurity();
//
//       statusSecurity = apiResponse.response.data['value']['twoFactorAuth'];
//       if (statusSecurity == 'active') {
//         isVerifiedWhatsApp = true;
//         numberWhatsapp = apiResponse.response.data['value']['twoFactorAuthNumber'];
//       } else {
//         isVerifiedWhatsApp = false;
//       }
//       notifyListeners();
//     } catch (e) {}
//   }
//
//   bool isSended = false;
//
//   Future<String> sendOtp(String number, {bool login = false}) async {
//     try {
//       isSended = false;
//       ApiResponse apiResponse;
//       apiResponse = await settingsRepo.sendOtp(number, isVerifiedWhatsApp);
//       if (login) {
//         isSended = true;
//       }
//       isSended = true;
//       notifyListeners();
//       return apiResponse.response.data['message'];
//     } catch (e) {
//       isSended = false;
//       notifyListeners();
//       return 'error';
//     }
//   }
//
//   bool isVerifiedWhatsApp = false;
//
//   Future<String> verifyOtp(String number, {String? verifyOtp, String? phoneNumber}) async {
//     try {
//       isSended = true;
//       notifyListeners();
//       await settingsRepo.verifyOtp(number, deviceId: verifyOtp);
//       isSended = true;
//       notifyListeners();
//       isVerifiedWhatsApp = !isVerifiedWhatsApp;
//       if (isVerifiedWhatsApp) {
//         numberWhatsapp = phoneNumber!;
//         statusSecurity = 'active';
//         notifyListeners();
//       } else {
//         statusSecurity == 'inactive';
//         notifyListeners();
//       }
//       isSended = false;
//       isWhatsApp = false;
//       notifyListeners();
//       return 'Otp success';
//     } catch (e) {
//       return "code not found";
//     }
//   }
//
//   bool isCleared = false;
//
//   Future<String> clearDevicesPut() async {
//     try {
//       ApiResponse apiResponse;
//       apiResponse = await settingsRepo.clearDevicesPut();
//       if (apiResponse.response.data['message'] == 'otp sent to user') {
//         isCleared = true;
//         isSended = true;
//         notifyListeners();
//       }
//       return '${apiResponse.response.data['message']}';
//     } catch (e) {
//       return "error";
//     }
//   }
//
//   Future<String> clearDevicesDelete(String deviceId, String number) async {
//     try {
//       ApiResponse apiResponse;
//       apiResponse = await settingsRepo.clearDevicesDelete(deviceId, number);
//       isCleared = false;
//       isSended = false;
//       return '${apiResponse.response.data['message']}';
//     } catch (e) {
//       return "error";
//     }
//   }
}

enum SupportState { unknown, supported, unsupported }

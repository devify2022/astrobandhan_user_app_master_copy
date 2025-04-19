import 'package:astrobandhan/datasource/model/auth/login_user_model.dart';
import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/repository/auth_repo.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({required this.authRepo});

  bool isToggle = true;
  bool isToggle1 = true;
  bool isToggle2 = true;
  bool isRemember = false;
  String tokenResetPassword = '';

  toggleDone({int? index}) {
    if (index == 0) {
      isToggle = !isToggle;
    } else if (index == 1) {
      isToggle1 = !isToggle1;
    } else if (index == 2) {
      isToggle2 = !isToggle2;
    }
    notifyListeners();
  }

  setTokenReset(String val) {
    tokenResetPassword = val;
    print('sdadssddddd $tokenResetPassword');
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // for Sign in Section
  bool hasVerified = false;
  bool isLoading2 = false;
  String verificationId = '';

  changeVerificationId(String id) {
    verificationId = id;
    notifyListeners();
  }

  changeLoadingIssue(bool status) {
    isLoading2 = status;
    notifyListeners();
  }

  bool isTimeOfBirthEnabled = false;

  changeTimeOfBirth(bool value) {
    isTimeOfBirthEnabled = value;
    notifyListeners();
  }

  String selectedHour = '0';
  String selectedMinute = '0';
  String selectedPeriod = 'AM';

  void updateTimeOfBirth(String? hour, String? minute, String? period) {
    selectedHour = hour!;
    selectedMinute = minute!;
    selectedPeriod = period!;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();
  String? profileImageUrl;

  void removeProfileImage() {
    profileImageUrl = null;
    notifyListeners();
  }

  Future<void> selectProfileImage(BuildContext context) async {
    // Request permission first

    // Permission granted, proceed with image selection
    XFile? imageFile = await _pickImage();
    _isLoading = true;
    notifyListeners();

    if (imageFile != null) {
      ApiResponse response = await authRepo.uploadImage(imageFile);
      _isLoading = false;
      if (response.response.statusCode == 200) {
        profileImageUrl = response.response.data['secure_url'];
      } else {
        showSnackMessage('Failed to upload image. Please try again.');
      }
      notifyListeners();
    }
  }

  Future loginWithOtp(String phone, {required Function callback}) async {
    _isLoading = true;
    if (authRepo.checkTokenExist()) {
      await authRepo.clearToken();
    }
    notifyListeners();
    ApiResponse apiResponse = await authRepo.sendOtp(phone);
    _isLoading = false;
// 🔍 Log the full response
    debugPrint("📥 Full API Response: ${apiResponse.response}");
    if (apiResponse.response.statusCode == 200) {
      showToastMessage(apiResponse.response.data['data']["message"],
          isError: false);
      changeVerificationId(
          apiResponse.response.data['data']["data"]["verificationId"]);
      callback(true);
    } else {
      showToastMessage(apiResponse.response.data["message"], isError: true);
    }
    notifyListeners();
  }

  Future otpValidation(String phone, String pin,
      {required Function callback}) async {
    _isLoading = true;

    notifyListeners();
    ApiResponse apiResponse =
        await authRepo.otpValidation(phone, pin, verificationId);
    _isLoading = false;
    debugPrint(
        "📥 Full API Response of OTP Validation: ${apiResponse.response.data['data']['user']}");
    if (apiResponse.response.statusCode == 200) {
      authRepo.saveUserToken(apiResponse.response.data['data']['accessToken']);
      authRepo.saveUserInfo(
          LoginUserModel.fromJson(apiResponse.response.data['data']['user']));
      showToastMessage(apiResponse.response.data['data']["message"],
          isError: false);
      callback(true);
    } else {
      showToastMessage(apiResponse.response.data["message"], isError: true);
    }
    notifyListeners();
  }

  Future<XFile?> _pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    return image;
  }

  Future updatePassword(String phone, String password,
      {required Function callback}) async {
    _isLoading = true;
    if (authRepo.checkTokenExist()) {
      await authRepo.clearToken();
    }
    notifyListeners();
    ApiResponse apiResponse = await authRepo.updatePassword(phone, password);
    _isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      showToastMessage(apiResponse.response.data['message'], isError: false);

      authRepo.signIn(phone, password);

      callback(true);
    } else {
      showToastMessage(apiResponse.response.data['message']);
    }
    notifyListeners();
  }

//
  Future<void> signIn(String phone, String password, {required Function callback}) async {
  try {
    _isLoading = true;
    if (authRepo.checkTokenExist()) {
      await authRepo.clearToken();
    }
    notifyListeners();

    // Get the raw response without letting Dio throw exceptions
    final response = await authRepo.signIn(phone, password);
    
    _isLoading = false;
    
    // Handle response based on structure and status code
    if (response.response != null) {
      final statusCode = response.response!.statusCode;
      final data = response.response!.data;
      
      debugPrint("📥 Response status code: $statusCode");
      debugPrint("📥 Response data: $data");
      
      if (statusCode == 200 && data['success'] == true) {
        // Success case
        if (isRemember) {
          authRepo.saveUserEmailAndPassword(phone, password);
        } else {
          authRepo.clearUserEmailAndPassword();
        }
        
        showToastMessage(data['message'], isError: false);
        authRepo.saveUserInfo(LoginUserModel.fromJson(data['data']['user']));
        authRepo.saveUserToken(data['data']['accessToken']);
        callback(true);
      } else {
        // Error case - extract message directly from response
        final message = data['message'] ?? "Unexpected error occurred";
        showToastMessage(message);
        callback(false);
      }
    } else {
      showToastMessage("No response from server");
      callback(false);
    }
  } catch (error) {
    _isLoading = false;
    debugPrint("❌ General Error: $error");
    showToastMessage("Something went wrong. Please try again.");
    callback(false);
  } finally {
    notifyListeners();
  }
}
  LoginUserModel get userModel => authRepo.getUserInfoData();

  // Future<Future<LoginUserModel?>> getUserInfo() async {
  //   return authRepo.getUserInfo();
  // }

//
//   Future signInByGoogle(Map map, Function callback) async {
//     final prefs = await SharedPreferences.getInstance();
//     String deviceId = '';
//     if (prefs.getString('deviceId') == null) {
//       var uuid = Uuid();
//       deviceId = uuid.v4();
//       prefs.setString('deviceId', deviceId);
//       print("device id $deviceId");
//     } else {
//       deviceId = prefs.getString('deviceId')!;
//       print("device id $deviceId");
//     }
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.signInByGoogle(map, deviceId: deviceId);
//     _isLoading = false;
//
//     if (apiResponse.response.statusCode == 200) {
//       authRepo.saveUserToken(apiResponse.response.data['value']['accessToken']);
//       authRepo.saveRefreshToken(apiResponse.response.data['value']['refreshToken']);
//       UserModel().accessToken = apiResponse.response.data['value']['accessToken'];
//       authRepo.saveUserID(apiResponse.response.data['value']['user-id']);
//       authRepo.saveUserEmail(apiResponse.response.data['value']['email']);
//       await getUserInfoFromJW();
//       callback(true, '${apiResponse.response.data['message']}');
//     } else {
//       callback(false, '${apiResponse.error.toString()}');
//     }
//     notifyListeners();
//   }
//
//   // for Guest  Section
//
//   Future guestLogin(Function callback, BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     String deviceId = '';
//     if (prefs.getString('deviceId') == null) {
//       var uuid = Uuid();
//       deviceId = uuid.v4();
//       prefs.setString('deviceId', deviceId);
//       print("device id $deviceId");
//     } else {
//       deviceId = prefs.getString('deviceId')!;
//       print("device id $deviceId");
//     }
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.guestLogin(deviceId: deviceId);
//     _isLoading = false;
//
//     if (apiResponse.response.statusCode == 200) {
//       print(apiResponse.response.data.toString());
//       callback(true, apiResponse.response.data['message']);
//       if (authRepo.checkTokenExist()) {
//         clear();
//       }
//       authRepo.saveUserID(-1);
//       authRepo.saveUserToken(apiResponse.response.data['value']['accessToken']);
//       //  authRepo.saveRefreshToken(apiResponse.response.data['value']['refreshToken']);
//       Provider.of<SettingProvider>(navigatorKey.currentState!.context, listen: false).userModel2 = UserModel2();
//
//       // UserModel().accessToken = apiResponse.response.data['value']['accessToken'];
//     } else {
//       callback(false, '${apiResponse.error.toString()}');
//     }
//     notifyListeners();
//   }
//
//   //for Forgot Password  Section
//   bool isForgotPasswordLoading = false;
//
//   Future forgotPassword(Function callback, {String email = '', String whatsAppNumber = '', bool isWhatsApp = false}) async {
//     final prefs = await SharedPreferences.getInstance();
//     String deviceId = '';
//     if (prefs.getString('deviceId') == null) {
//       var uuid = Uuid();
//       deviceId = uuid.v4();
//       prefs.setString('deviceId', deviceId);
//       print("device id $deviceId");
//     } else {
//       deviceId = prefs.getString('deviceId')!;
//       print("device id $deviceId");
//     }
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse;
//     if (isWhatsApp) {
//       apiResponse = await authRepo.forgotPasswordWhatsApp(whatsAppNumber, deviceId: deviceId);
//     } else {
//       apiResponse = await authRepo.forgotPassword(email, deviceId: deviceId);
//     }
//
//     _isLoading = false;
//     if (apiResponse.response.statusCode == 200 || apiResponse.response.statusCode == 201) {
//       callback(true, apiResponse.response.data['message']);
//     } else {
//       callback(false, '${isWhatsApp ? "Phone Number" : "Email"} doesn\'t Exists.');
//     }
//     notifyListeners();
//   }
//
//   //for Reset Password  Section
//
//   Future resetPassword(Function callback, Map<String, dynamic> data) async {
//     final prefs = await SharedPreferences.getInstance();
//     String deviceId = '';
//     if (prefs.getString('deviceId') == null) {
//       var uuid = Uuid();
//       deviceId = uuid.v4();
//       prefs.setString('deviceId', deviceId);
//       print("device id $deviceId");
//     } else {
//       deviceId = prefs.getString('deviceId')!;
//       print("device id $deviceId");
//     }
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.resetPasswordWhatsApp(data, deviceId: deviceId);
//     _isLoading = false;
//     if (apiResponse.response.statusCode == 200 || apiResponse.response.statusCode == 201 || apiResponse.response.statusCode == 202) {
//       callback(true, apiResponse.response.data['message']);
//     } else {
//       callback(false, '${apiResponse.error.toString()}');
//     }
//     notifyListeners();
//   }
//
//   Future resetPasswordByEmail(Function callback, Map<String, dynamic> data) async {
//     final prefs = await SharedPreferences.getInstance();
//     String deviceId = '';
//     if (prefs.getString('deviceId') == null) {
//       var uuid = Uuid();
//       deviceId = uuid.v4();
//       prefs.setString('deviceId', deviceId);
//       print("device id $deviceId");
//     } else {
//       deviceId = prefs.getString('deviceId')!;
//       print("device id $deviceId");
//     }
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.resetPasswordByEmail(data, deviceId: deviceId);
//     _isLoading = false;
//     if (apiResponse.response.statusCode == 200 || apiResponse.response.statusCode == 201 || apiResponse.response.statusCode == 202) {
//       authRepo.saveUserToken(apiResponse.response.data['value']['accessToken']);
//       authRepo.saveRefreshToken(apiResponse.response.data['value']['refreshToken']);
//       UserModel().accessToken = apiResponse.response.data['value']['accessToken'];
//       authRepo.saveUserID(apiResponse.response.data['value']['user-id']);
//       authRepo.saveUserEmail(apiResponse.response.data['value']['email']);
//       getUserInfoFromJW();
//       callback(true, apiResponse.response.data['message']);
//     } else {
//       callback(false, '${apiResponse.error.toString()}');
//     }
//     notifyListeners();
//   }
//
//   Future refreshToken(String refreshToken, Function callback) async {
//     final prefs = await SharedPreferences.getInstance();
//     String deviceId = '';
//     if (prefs.getString('deviceId') == null) {
//       var uuid = Uuid();
//       deviceId = uuid.v4();
//       prefs.setString('deviceId', deviceId);
//       print("device id $deviceId");
//     } else {
//       deviceId = prefs.getString('deviceId')!;
//     }
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.refreshToken(refreshToken, deviceId: deviceId);
//     if (apiResponse.response.statusCode == 200 || apiResponse.response.statusCode == 201 || apiResponse.response.statusCode == 202) {
//       authRepo.saveUserToken(apiResponse.response.data['value']['accessToken']);
//       authRepo.saveRefreshToken(apiResponse.response.data['value']['refreshToken']);
//       UserModel().accessToken = apiResponse.response.data['value']['accessToken'];
//       authRepo.saveUserID(apiResponse.response.data['value']['user-id']);
//       authRepo.saveUserEmail(apiResponse.response.data['value']['email']);
//       getUserInfoFromJW();
//       callback(true, apiResponse.response.data['value']);
//     } else {
//       print("errrrrr ${apiResponse.error.toString()}");
//       callback(false, apiResponse.error.toString());
//     }
//     notifyListeners();
//   }
//
//   // for changePassword in Section
//
//   Future changePassword({BuildContext? context, String? old, String? password, Function? callback}) async {
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.changePassword(old!, password!, context!);
//     _isLoading = false;
//     if (apiResponse.response.statusCode == 200) {
//       authRepo.saveUserPassword(password);
//       callback!(true, '${apiResponse.response.data['message']}');
//     } else {
//       callback!(false, '${apiResponse.error.toString()}');
//     }
//     notifyListeners();
//   }
//
//   // for changePassword in Section
//
//   Future changeProfile({String? firstname, String? lastname, String? email, String? mobile, Function? callback}) async {
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.changeProfile(firstname!, lastname!, email!, mobile!);
//     _isLoading = false;
//     if (apiResponse.response.statusCode == 200) {
//       await getUserInfoFromJW();
//       callback!(true, '${apiResponse.response.data['message']}');
//     } else {
//       callback!(false, '${apiResponse.error.toString()}');
//     }
//     notifyListeners();
//   }
//
// // for changeName in Section
//
//   Future changeName({String? firstname, String? lastname, Function? callback}) async {
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.changeName(
//       firstname!,
//       lastname!,
//     );
//     _isLoading = false;
//     if (apiResponse.response.statusCode == 200) {
//       await getUserInfoFromJW();
//       callback!(true, '${apiResponse.response.data['message']}');
//     } else {
//       callback!(false, '${apiResponse.error.toString()}');
//     }
//     notifyListeners();
//   }
//
//   // for sign up section
//

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  Future signUP(
      String name,
      String email,
      String phone,
      String dob,
      String gender,
      String timeOfBirth,
      String placeOfBirth,
      String password,
      String image,
      Function callback,
      BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await authRepo.signUp(name, email, phone, dob,
        gender, timeOfBirth, placeOfBirth, password, image);
    _isLoading = false;

    if (apiResponse.response.statusCode == 200) {
      showToastMessage(apiResponse.response.data['message'], isError: false);

      authRepo.saveUserInfo(
          LoginUserModel.fromJson(apiResponse.response.data['data']['user']));

      authRepo.saveUserToken(apiResponse.response.data['data']['accessToken']);

      callback(true);
    } else {
      showToastMessage(apiResponse.response.data['message'], isError: true);

      callback(false);
    }
    notifyListeners();
  }
//
//   Future verifyOTP(String otp, Function callback) async {
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.verifyOTP(getUserEmail(), otp);
//     _isLoading = false;
//     if (apiResponse.response.statusCode == 200) {
//       if (authRepo.checkTokenExist()) {
//         clear();
//       }
//
//       authRepo.saveUserToken(apiResponse.response.data['value']['accessToken']);
//       authRepo.saveRefreshToken(apiResponse.response.data['value']['refreshToken']);
//       authRepo.saveUserID(apiResponse.response.data['value']['user-id']);
//       authRepo.saveUserEmail(apiResponse.response.data['value']['email']);
//       userRole = '${apiResponse.response.data['value']['roles'][0]}';
//       await getUserInfoFromJW();
//       callback(true, '${apiResponse.response.data['message']}');
//     } else {
//       callback(false, 'OTP Not Correct');
//     }
//     notifyListeners();
//   }
//
//   /////TODO: for time count
//
//   int minutes = 5;
//   int seconds = 0;
//   DateTime dateTime = DateTime.now();
//
//   setDateTime(DateTime time) {
//     dateTime = time;
//     notifyListeners();
//   }
//
//   bool isEmail = true;
//   late Timer _timer;
//
//   void startTimerForOTP() {
//     // Calculate the difference in time between now and the target DateTime
//     Duration difference = dateTime.difference(DateTime.now());
//     int differenceInSeconds = difference.inSeconds;
//     // Set the initial minutes and seconds from the difference
//     minutes = differenceInSeconds ~/ 60;
//     seconds = differenceInSeconds % 60;
//
//     // Start the timer
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (seconds > 0) {
//         seconds--;
//       } else {
//         if (minutes > 0) {
//           minutes--;
//           seconds = 59;
//         } else {
//           timer.cancel();
//         }
//       }
//       notifyListeners();
//     });
//   }
//
//   // void resetTime() {
//   //   _timer.cancel();
//   //   resendOTP((bool status, String message) {
//   //     if (status) {
//   //       showToastMessage(message, isError: false);
//   //     } else {
//   //       showToastMessage(message);
//   //     }
//   //   });
//   //   notifyListeners();
//   // }
//
//   Future resendOTP() async {
//     _isLoading = true;
//     _timer.cancel();
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.resendOTP();
//     _isLoading = false;
//     log(apiResponse.response.data.toString());
//     if (apiResponse.response.statusCode == 200) {
//       dateTime = DateTime.parse(apiResponse.response.data['value']['signupOtpExpiry']);
//       startTimerForOTP();
//       showToastMessage(apiResponse.response.data['message']);
//     } else {
//       showToastMessage(apiResponse.error.toString());
//     }
//     notifyListeners();
//   }
//
//   int getUserID() {
//     return authRepo.getUserID();
//   }
//
//   String userRole = "";
//
//   getUserInfoFromJW() {
//     Map<String, dynamic> payload = Jwt.parseJwt(getUserToken());
//     print('dsfdsfsdf ${payload["user-information"]}');
//     UserModel().username = payload["user-information"]["firstname"];
//     UserModel().fName = payload["user-information"]["firstname"];
//     UserModel().lName = payload["user-information"]["lastname"];
//     UserModel().email = payload["user-information"]["email"];
//     UserModel().phoneNo = payload["user-information"]["mobile"] ?? '';
//     UserModel().image = payload["user-information"]["image"];
//     // UserModel().uid = payload["user-information"]["role"]["id"];
//     UserModel().roles = payload["user-information"]["role"][0];
//     // userRole = payload["user-information"]["role"][0];
//     UserModel().dummyPassword = payload["user-information"]["dummy-password"];
//     UserModel().accessToken = getUserToken();
//     notifyListeners();
//     final authResponseData = payload["user-information"];
//     // print("ppppppppppppppp\$ ${payload["user-information"]}");
//   }
//
//   // direct  PDF Upload
//   bool isLoadingUpload = false;
//
//   Future uploadPDFThenGetLink(Function callback, BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc'],
//     );
//     if (result != null) {
//       _isLoading = true;
//       notifyListeners();
//       ApiResponse apiResponse = await authRepo.uploadPdfWord(File(result.files.single.path!));
//       _isLoading = false;
//       if (apiResponse.response.statusCode == 200) {
//         callback(true, apiResponse.response.data['value']['uploadedFile']['filePath']);
//         Helper.showSnack(context, getTranslated("CV Uploaded Successfully", context));
//       } else {
//         // isLoadingUpload = false;
//         //  Helper.showSnack(context, apiResponse.error.toString());
//         callback(false, apiResponse.error.toString());
//       }
//     } else {
//       //   isLoadingUpload = false;
//       Helper.showSnack(context, getTranslated("No Selected Any file", context));
//       callback(false, '');
//     }
//
//     notifyListeners();
//   }
//
//   // for Remember Me Section
//
//   bool _isActiveRememberMe = true;
//
//   bool get isActiveRememberMe => _isActiveRememberMe;
//
//   toggleRememberMe() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     _isActiveRememberMe = !_isActiveRememberMe;
//     if (!_isActiveRememberMe) {
//       clear();
//       sharedPreferences.clear();
//     }
//     notifyListeners();
//   }
//
//   void saveUserEmailAndPassword(String email, String password) {
//     authRepo.saveUserEmailAndPassword(email, password);
//   }
//
//   String getUserEmail() {
//     return authRepo.getUserEmail2();
//   }
//
//   Future<bool> clearUserEmailAndPassword() async {
//     return authRepo.clearUserEmailAndPassword();
//   }
//
//   String getUserPassword() {
//     return authRepo.getUserPassword();
//   }
//
//   // for user Section
//   String getUserToken() {
//     return authRepo.getUserToken();
//   }
//
//   // for user Section
//   int getUserId() {
//     return authRepo.getUserID();
//   }
//
//   // for Email
//   String getEmail2() {
//     return authRepo.getUserEmail2();
//   }
//
//   bool isLoggedIn() {
//     return authRepo.isLoggedIn();
//   }
//
//   clear() async {
//     await authRepo.clearToken();
//     notifyListeners();
//   }
//
//   int selectResetPasswordOption = 0;
//
//   initializeResetPassword() {
//     selectResetPasswordOption = 0;
//   }
//
//   void changeResetPasswordOption(int value) {
//     selectResetPasswordOption = value;
//     print(selectResetPasswordOption);
//     notifyListeners();
//   }
//
//   Future changeFcm(String token, {bool isGuest = false}) async {
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.changeFcm(token);
//     _isLoading = false;
//
//     if (apiResponse.response.statusCode == 200) {
//       if (authRepo.checkTokenExist()) {
//         clear();
//       }
//     }
//   }
//
//   // *********** count
//   int timeCount = 200;
//
//   resetTimeCount() {
//     timeCount = 200;
//   }
//
//   Timer? timer;
//
//   startTimer(BuildContext context) {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (timeCount <= 0) {
//         cancelTimer(context);
//       } else {
//         timeCount--;
//         notifyListeners();
//       }
//     });
//   }
//
//   cancelTimer(BuildContext context) {
//     Helper.toRemoveUntiScreen(context, LoginScreen());
//     timer!.cancel();
//     notifyListeners();
//   }
//
//   void timeCountStart() {}
//
//   bool isClearCache = false;
//
//   clearCache() {
//     isClearCache = true;
//     notifyListeners();
//   }
//
//   signSocial() {
//     //  ApiResponse apiResponse = await authRepo.signIn(email, password,id,otp:otp);
//   }
//
// //
//   Future<void> deleteAccount(Function callback, BuildContext ctx) async {
//     // _isLoading = true;
//     // notifyListeners();
//
//     ApiResponse apiResponse = await authRepo.deleteAccount();
//     //_isLoading = false;
//
//     if (apiResponse.response.statusCode == 200) {
//       print(apiResponse.response.data.toString());
//       Helper.showSnack(ctx, 'The account has been deleted successfully');
//
//       callback(true, apiResponse.response.data['message']);
//       // UserModel().accessToken = apiResponse.response.data['value']['accessToken'];
//     } else {
//       print('sadasdasdsa ${apiResponse.response}');
//       Helper.showSnack(ctx, 'The account has not been deleted');
//
//       callback(false, '${apiResponse.error.toString()}');
//     }
//     notifyListeners();
//   }
//
// //LOGOUT
//   Future<void> logOut(Function callback, BuildContext ctx) async {
//     _isLoading = true;
//     notifyListeners();
//     ApiResponse apiResponse = await authRepo.logout();
//     _isLoading = false;
//
//     await authRepo.clearToken();
//     //  Helper.showSnack(ctx,'The account has been deleted successfully');
//
//     callback(true, apiResponse.response.data!=null?apiResponse.response.data['message']:apiResponse.error.toString());
//
//
//     //
//     //
//     // print('shuvooo ${apiResponse.response.data.toString()} ${apiResponse.response.statusCode} ${apiResponse.error.toString()}');
//     //
//     // if (apiResponse.response.statusCode == 404 || apiResponse.response.statusCode == 200) {
//     //
//     //
//     //   await authRepo.clearToken();
//     //   //  Helper.showSnack(ctx,'The account has been deleted successfully');
//     //
//     //   callback(true, apiResponse.response.data['message']);
//     //   // UserModel().accessToken = apiResponse.response.data['value']['accessToken'];
//     // } else {
//     //   print('sadasdasdsa ${apiResponse.response}');
//     //   // Helper.showSnack(ctx,'The account has not been deleted');
//     //
//     //   callback(false, '${apiResponse.error.toString()}');
//     // }
//     notifyListeners();
//   }
}

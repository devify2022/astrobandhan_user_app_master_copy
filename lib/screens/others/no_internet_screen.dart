import 'dart:async';
import 'dart:developer';

import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/widgets/custom_text2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoInternetOrDataScreen extends StatefulWidget {
  final bool isNoInternet;
  final bool isNoSearchData;
  final Function? callBackFunction;

  const NoInternetOrDataScreen({super.key, required this.isNoInternet, this.isNoSearchData = false, this.callBackFunction});

  @override
  State<NoInternetOrDataScreen> createState() => _NoInternetOrDataScreenState();
}

class _NoInternetOrDataScreenState extends State<NoInternetOrDataScreen> {
  Timer? _timer;
  int i = 0;

  init(BuildContext context) async {
    //   try {
    //     final result = await InternetAddress.lookup('example.com');
    //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //       if(widget.isNoInternet) {
    //
    //         if (Provider.of<AuthProvider>(context, listen: false).getUserID() != -1) {
    //           await Provider.of<SettingProvider>(context, listen: false).getUser(context);
    //         }else{
    //           await Provider.of<AuthProvider>(context, listen: false).getUserInfoFromJW();
    //         }
    //
    //         Provider.of<HomePageProvider>(context, listen: false).newRealEstateContentModelList.clear();
    //         final result = await Provider.of<HomePageProvider>(context, listen: false).getRealEstate();
    //
    //         if (result.toString().compareTo("realEstate List") == 0) {
    //           if(_timer != null) {
    //             _timer!.cancel();
    //             //    Helper.toRemoveUntiScreen(context, DashBoardScreen());
    //           }
    //
    //           print(result.toString());
    //           // await Provider.of<RentProvider>(context, listen: false).getWish();
    //           //  Navigator.of(context).pop();
    //           //  Helper.toRemoveUntiScreen(context, DashBoardScreen());
    //         }
    //         else if(result.toString().compareTo('no internet') == 0) {
    //
    //         }
    //         else {
    //           if(_timer != null) {
    //             _timer!.cancel();
    //           }
    //
    //           //    Navigator.of(context).pop();
    //           await Provider.of<RentProvider>(context, listen: false).getWish();
    //           await Provider.of<HomePageProvider>(context, listen: false)
    //               .initializeHomeData(context, (bool status) {});
    //
    //           Helper.toRemoveUntiScreen(context, DashBoardScreen());
    //           // Helper.toRemoveUntiScreen(context, MainHomePageScreen());
    //           print(result.toString());
    //         }
    //
    //       }
    //     }
    //   } on SocketException catch (_) {
    //     i=i+1;
    //
    //     print('not connectedddd');
    //   }
    // if(widget.isNoInternet && i<3) {
    //
    //   if (Provider.of<AuthProvider>(context, listen: false).getUserID() != -1) {
    //     await Provider.of<SettingProvider>(context, listen: false).getUser(context);
    //   }else{
    //     await Provider.of<AuthProvider>(context, listen: false).getUserInfoFromJW();
    //   }
    //
    //   Provider.of<HomePageProvider>(context, listen: false).newRealEstateContentModelList.clear();
    //   final result = await Provider.of<HomePageProvider>(context, listen: false).getRealEstate();
    //
    //   if (result.toString().compareTo("realEstate List") == 0) {
    //     if(_timer != null) {
    //       _timer!.cancel();
    //   //    Helper.toRemoveUntiScreen(context, DashBoardScreen());
    //     }
    //
    //     print(result.toString());
    //    // await Provider.of<RentProvider>(context, listen: false).getWish();
    //   //  Navigator.of(context).pop();
    //    //  Helper.toRemoveUntiScreen(context, DashBoardScreen());
    //   }
    //   else if(result.toString().compareTo('no internet') == 0) {
    //
    //   }
    //   else {
    //     if(_timer != null) {
    //       _timer!.cancel();
    //     }
    //     //    Navigator.of(context).pop();
    //     await Provider.of<RentProvider>(context, listen: false).getWish();
    //     await Provider.of<HomePageProvider>(context, listen: false)
    //         .initializeHomeData(context, (bool status) {});
    //     Helper.toRemoveUntiScreen(context, DashBoardScreen());
    //     // Helper.toRemoveUntiScreen(context, MainHomePageScreen());
    //     print(result.toString());
    //   }
    //
    // }
    // else {
    //  // widget.callBackFunction!();
    // }
  }

  void startTimer(BuildContext context) {
    const oneSec = Duration(seconds: 5);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        init(context);
      },
    );
  }

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    setState(() {});
  }

  bool isServerTime = true;

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   // if(widget.isRent==true || widget.isBuy==true) {
  //   //   setState(() {
  //   //     var _connectionStatusTemp = _connectionStatus;
  //   //     _connectionStatus = result;
  //   //     if (result.name.toLowerCase() != 'none' &&
  //   //         _connectionStatusTemp != _connectionStatus) {
  //   //       Provider.of<RentProvider>(context, listen: false)
  //   //           .realEstateFilterData(incomeType: widget.isBuy==true ? 'sale' : 'rent');
  //   //     }
  //   //     print(_connectionStatus.toString());
  //   //   });
  //   // }
  //   setState(() {
  //     var _connectionStatusTemp = _connectionStatus;
  //     _connectionStatus = result;
  //     if (result.name.toLowerCase() != 'none' && _connectionStatusTemp != _connectionStatus) {
  //     }
  //     print(_connectionStatus.toString());
  //   });
  // }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  bool isMobile = false;

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    var connectionStatusTemp = _connectionStatus;
    _connectionStatus = result.first;
    if (result.first.name.toLowerCase() != 'none') {}
    if (result.first.name.toLowerCase() != 'none' && connectionStatusTemp != _connectionStatus) {
    }
    if (_connectionStatus.name.toLowerCase() == 'none') {
      isServerTime = false;
    } else if (_connectionStatus.name.toLowerCase() == 'wifi') {
      Future.delayed(Duration(seconds: 6), () {
        isServerTime = true;
      });
    } else if (_connectionStatus.name.toLowerCase() == 'mobile') {
      Future.delayed(Duration(seconds: 6), () {
        isServerTime = true;
      });
    }

    setState(() {});
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    startTimer(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Color for Android
        statusBarIconBrightness: Brightness.dark,
      ),
      sized: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: _connectionStatus.name.toLowerCase() != 'none' && isServerTime == true ? Text('Server Error') : previousNoServerWidget(context),
      ),
    );
  }

  Widget previousNoServerWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(widget.isNoInternet ? ImageResources.no_internet : ImageResources.no_data, width: 200, height: 200),
            CustomText2(
              title: widget.isNoInternet ? 'Opps!' : 'Sorry !',
              fontSize: 30,
              color: widget.isNoInternet ? Colors.black : kPrimaryColor,
            ),
            SizedBox(height: 5),
            CustomText2(
                title: widget.isNoInternet
                    ? 'No internet connection'
                    : widget.isNoSearchData
                        ? "No Product Found"
                        : 'No data found',
                color: darkBlueColor,
                textAlign: TextAlign.center),
            SizedBox(height: 40),
            widget.isNoInternet
                ? Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: MaterialButton(
                      onPressed: () async {
                        i = 1;
                        init(context);
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: CustomText2(title: 'retry now', fontSize: 16, color: whiteColor),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

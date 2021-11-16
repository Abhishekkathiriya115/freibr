import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/model/device.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/service/autentication.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/authentication/login.dart';
import 'package:freibr/view/home.dart';
import 'package:freibr/view/profile/profile.dart';
import 'package:freibr/view/walkthrough.dart';

import 'package:get/get.dart';

class AuthenticationController extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;

  var authUser = new UserModel();
  String fcmToken = "";

  Future<void> getFcmToken() async {
    var existedFcmToken = await AppSharedPreferences.getFcmToken();
    if (existedFcmToken == null) {
    } else {
      this.fcmToken = existedFcmToken;
    }

    FirebaseMessaging.instance.getToken().then((token) {
      fcmToken = token;
      registerDevice();
    }).catchError((err) {});
  }

  Future<void> registerDevice() async {
    DeviceInfo _deviceDetail = await getDeviceDetail();
    try {
      _deviceDetail.userId = authUser != null ? authUser.id : 0;
      _deviceDetail.fcmToken = fcmToken;

      final response =
          await AuthenticationService.registerDevice(_deviceDetail);
      if (response["status"] == true) {
        await AppSharedPreferences.setDeviceInfo(_deviceDetail);
        return response["status"];
      }
    } catch (e) {}
    return null;
  }

  Future<DeviceInfo> getDeviceDetail() async {
    DeviceInfo _obj = new DeviceInfo();
    DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        _obj.deviceName = build.model;
        //  _obj.deviceId = build.version.toString();
        _obj.deviceId = build.androidId; //UUID for Android
        _obj.deviceType = 'android';
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        _obj.deviceName = data.name;
        // deviceVersion = data.systemVersion;
        _obj.deviceId = data.identifierForVendor; //UUID for iOS
        _obj.deviceType = 'ios';
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return _obj;
  }

  Future<void> checkIsLoggedIn() async {
    var loginStatus = await AppSharedPreferences.isUserLoggedIn();
    bool isFirstTimeUser = await AppSharedPreferences.isFirstTimeUser();
    if (loginStatus == true) {
      isLoggedIn = loginStatus;
      authUser = await AppSharedPreferences.getUserProfile();
      try {
        Map refreshToken = await AuthenticationService.refreshToken();
        if (refreshToken['status']) {
          await AppSharedPreferences.setToken(refreshToken['data']);
          notifyListeners();
          Get.off(() => Home());
        } else {
          Get.off(() => Login());
        }
      } catch (e) {
        Get.off(() => Login());
      }
      // // refreshToken
      // notifyListeners();
      // Get.off(() => Home());
    } else {
      if (isFirstTimeUser != null && isFirstTimeUser) {
        Get.off(() => Login());
      } else {
        Get.off(() => Walkthrough());
      }
    }
  }

  Future<void> changePassword(String username, String password) async {
    try {
      showLoadingDialog();
      var result =
          await AuthenticationService.changePassword(username, password);
      if (result['status']) {
        showToast(message: result['message']);
        await Future.delayed(Duration(seconds: 1));
        Get.offAll(Login());
      } else {
        showToast(message: result['message']);
      }
    } finally {
      dismissDialogToast();
    }
  }

  Future<void> userLogin(String username, String password) async {
    try {
      showLoadingDialog();
      var result = await AuthenticationService.userLogin(username, password);
      if (result['status']) {
        await this.storeUserLocal(result);

        var tempUser = UserModel.fromJson(result["data"]['user']);
        if (int.parse(tempUser.noOfLogins.toString()) > 1) {
          this.registerDevice();
          Get.offAll(Home());
        } else {
          Get.offAll(() => Home());
          Get.to(() => Profile(
                isFirstTime: true,
              ));
        }
      } else {
        showToast(message: "invalid username password.");
      }
    } finally {
      dismissDialogToast();
    }
  }

  Future<void> storeUserLocalProfile(UserModel param) async {
    await AppSharedPreferences.setUserProfile(param);
    this.authUser = param;
    // notifyListeners();
  }

  Future<void> storeUserLocal(dynamic result) async {
    var tempUser = UserModel.fromJson(result["data"]['user']);
    await AppSharedPreferences.setUserLoggedIn(result['status']);
    await AppSharedPreferences.setUserProfile(tempUser);
    await AppSharedPreferences.setToken(
        result["data"]['refresh_token']['original']['data']);
    this.authUser = tempUser;
    this.isLoggedIn = true;
    notifyListeners();
  }

  void setAuthUser(UserModel param) {
    this.authUser = param;
    notifyListeners();
  }

  Future<void> logout() async {
    await AppSharedPreferences.setUserLoggedIn(false);
    await AppSharedPreferences.setUserProfile(null);
    await AppSharedPreferences.setToken(null);
    // this.authUser = null;
    this.isLoggedIn = false;
    Get.offAll(Login());
    notifyListeners();
  }

  Future<void> changeCurrentPassword(data) async {
    showLoadingDialog();
    Map result = await AuthenticationService.changeCurrentPassword(data);
    if (result != null) {
      if (result['status']) {
        Get.back();
        showToast(message: result['data']['message']);
        return;
      } else {
        if (result['errors'].keys.length > 0) {
          // result
          String message = result['errors'][result['errors'].keys[0]];
          showToast(message: message);
        }
      }
    }
    showToast(message: 'Something went wrong');
  }
}

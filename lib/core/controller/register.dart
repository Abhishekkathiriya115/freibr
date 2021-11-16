import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/service/autentication.dart';
import 'package:freibr/core/service/profile.dart';
import 'package:freibr/util/enum.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/authentication/upload_profile.dart';
import 'package:freibr/view/authentication/verify_otp.dart';
import 'package:freibr/view/home.dart';
import 'package:get/get.dart';

class RegisterController extends ChangeNotifier {
  FacebookLogin facebookSignIn = new FacebookLogin();
  UserModel _registerUser = new UserModel();
  UserModel get registerUser => _registerUser;
  bool isLoading = false;
  bool isFacebookRegisterLogin = false;

  final AuthenticationController authController;

  RegisterController({this.authController});

  Future<void> facebookLogin() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        showLoadingDialog();
        FacebookAccessToken accessToken = result.accessToken;
        await AppSharedPreferences.setFacebookToken(accessToken.token);
        var graphProfile =
            await AuthenticationService.getFacebookProfile(accessToken.token);
        if (graphProfile != null) {
          _registerUser.email = graphProfile['email'];
          _registerUser.username = graphProfile['email'];
          _registerUser.name = graphProfile['name'];
          this.isFacebookRegisterLogin = true;
          var isExist =
              await AuthenticationService.isExistEmail(graphProfile['email']);
          if (isExist != null && isExist['status']) {
            var isCompleted =
                await this.checkIsProfileCompleted(graphProfile['email']);
            if (!isCompleted) {
              showToast(message: 'Please complete your profile.');
              await this.sendNewRegisterOtp(graphProfile['email']);
              Get.to(() => VerifyOtp(
                verificationOtpType: VerificationOtpType.approveAndLogin,
              ));
            } else {
              this.saveUser();
            }
          } else {
            var rng = new Random();
            var password = rng.nextInt(900000) + 100000;
            _registerUser.password = password.toString();

            Future.delayed(Duration(seconds: 1), () {
              Get.back();
              Get.to(() => UploadProfile());
            });
          }
          notifyListeners();
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        showToast(message: 'Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        showToast(
            message: 'Something went wrong with the login process.\n'
                'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Future<void> saveUser() async {
    try {
      showLoadingDialog();
      if (!this.isFacebookRegisterLogin) {
        var result = await AuthenticationService.registerUser(registerUser);
        if (result != null) {
          await AppSharedPreferences.setChoosenCategories([]);
          showToast(
              message: "we have send you an otp. Please check your email.");
          Get.offAll(
              VerifyOtp(verificationOtpType: VerificationOtpType.approve));
        } else {
          showToast(message: "something is wrong");
        }
      } else {
        var result =
            await AuthenticationService.loginRegisterFacebook(registerUser);
        if (result['status']) {
          if (result['data'].length > 0 && result['data']['token'] != null) {
            this.isFacebookRegisterLogin = false;
            authController.storeUserLocal(result);
            var tempUser = UserModel.fromJson(result["data"]['user']);
            if (tempUser.noOfLogins != '0') {
              // Get.offAll(EditProfile(
              //   isFirstTime: true,
              // ));
            } else {
              Get.offAll(Home());
            }
          } else {
            await AppSharedPreferences.setChoosenCategories([]);
            showToast(
                message: "we have send you an otp. Please check your email.");
            Get.offAll(VerifyOtp(
                verificationOtpType: VerificationOtpType.approveAndLogin));
          }
        }
      }
    } finally {
      dismissDialogToast();
    }
  }

  Future<void> sendNewRegisterOtp(param) async {
    try {
      showLoadingDialog();
      var result =
          await AuthenticationService.sendNewRegisterOtp({'username': param});
      if (result['status']) {
        showToast(message: 'Otp is sent to your email.');
      }
    } finally {
      dismissDialogToast();
    }
  }

  Future<bool> checkIsProfileCompleted(String param) async {
    try {
      showLoadingDialog();
      var result = await AuthenticationService.isProfileCompleted(param);
      if (result['status']) {
      } else {
        showToast(message: result['message']);
      }
      return result['status'];
    } finally {
      dismissDialogToast();
    }
  }

  Future<bool> verifyOtp(String otpParam, String username) async {
    try {
      showLoadingDialog();
      var result = await AuthenticationService.verifyOtp(otpParam, username);
      if (result['status']) {
        // showToast(message: message);
        // Get.offAll(Login());
        // approveUser();
      } else {
        showToast(message: result['message']);
      }
      return result['status'];
    } finally {
      Get.back();
    }
  }

  Future<void> approveUser() async {
    try {
      String message = 'Thankyou for registering with us.';
      showLoadingDialog();
      var result =
          await AuthenticationService.approveUser(_registerUser.username);
      if (result['status']) {
        showToast(message: message);
        // Get.offAll(Login());
        await authController.userLogin(
            _registerUser.username, _registerUser.password);
      } else {
        showToast(message: result['message']);
      }
    } finally {
      dismissDialogToast();
    }
  }

  Future<void> uploadProfileImage(File param, String userCode) async {
    try {
      isLoading = true;
      var result = await ProfileService.uploadFileAsFormData(param, userCode);
      if (result != null) {
        this._registerUser.avatar = result["avatar"];
        this._registerUser.thumbnailAvatar = result["thumbnail"];
        this._registerUser.userCode = result["usercode"];
      }
    } finally {
      isLoading = false;
    }
  }

  Future<bool> isExistEmail(String param) async {
    var isExist = await AuthenticationService.isExistEmail(param);
    if (isExist != null && isExist['status']) {
      return true;
    }
    return false;
  }
}

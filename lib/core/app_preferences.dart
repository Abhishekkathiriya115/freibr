import 'dart:async';
import 'dart:convert';
import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/model/device.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceKeys {
  static const String IS_USER_LOGGED_IN = "IS_USER_LOGGED_IN";
  static const String USER = "USER";
  static const String API_TOKEN = "API_TOKEN";
  static const String DEVICE_INFO = "DEVICE_INFO";
  static const String IS_FIRST_TIME = "IS_FIRST_TIME";
  static const String FCM_TOKEN = "FCM_TOKEN";
  static const String FACEBOOK_TOKEN = "FACEBOOK_TOKEN";
  static const String CHOOSEN_CATEGORIES = "CHOOSEN_CATEGORIES";
}

class AppSharedPreferences {
///////////////////////////////////////////////////////////////////////////////
  static Future<SharedPreferences> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

///////////////////////////////////////////////////////////////////////////////
  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

///////////////////////////////////////////////////////////////////////////////
  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.IS_USER_LOGGED_IN);
  }

  static Future<bool> isFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.IS_FIRST_TIME);
  }

  static Future<void> setisFirstTimeUser(bool param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.IS_FIRST_TIME, param);
  }

  static Future<void> setUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.IS_USER_LOGGED_IN, isLoggedIn);
  }

///////////////////////////////////////////////////////////////////////////////
  static Future<UserModel> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserModel.fromJson(
        json.decode(prefs.getString(SharedPreferenceKeys.USER)));
  }

  static Future<void> setUserProfile(UserModel param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileJson = json.encode(param);
    return prefs.setString(SharedPreferenceKeys.USER, userProfileJson);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.API_TOKEN);
  }

  static Future<void> setToken(String param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileJson = json.encode(param);
    return prefs.setString(SharedPreferenceKeys.API_TOKEN, userProfileJson);
  }

  static Future<String> getFacebookToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.FACEBOOK_TOKEN);
  }

  static Future<void> setFacebookToken(String param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileJson = json.encode(param);
    return prefs.setString(
        SharedPreferenceKeys.FACEBOOK_TOKEN, userProfileJson);
  }

  static Future<String> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.FCM_TOKEN);
  }

  static Future<void> setFcmToken(String param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileJson = json.encode(param);
    return prefs.setString(SharedPreferenceKeys.FCM_TOKEN, userProfileJson);
  }

  static Future<DeviceInfo> getDeviceInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return DeviceInfo.fromJson(
        json.decode(prefs.getString(SharedPreferenceKeys.DEVICE_INFO)));
  }

  static Future<void> setDeviceInfo(DeviceInfo param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileJson = json.encode(param);
    return prefs.setString(SharedPreferenceKeys.DEVICE_INFO, userProfileJson);
  }

  static Future<List<CategoryModel>> getChoosenCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(SharedPreferenceKeys.CHOOSEN_CATEGORIES);
    if (data != null) {
      return CategoryModel.toListFromJson(json.decode(data));
    }
    return List.filled(0, CategoryModel());
  }

  static Future<void> setChoosenCategories(List<CategoryModel> param) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileJson = json.encode(param);
    return prefs.setString(
        SharedPreferenceKeys.CHOOSEN_CATEGORIES, userProfileJson);
  }
}

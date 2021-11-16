import 'dart:convert';

import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/model/device.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:http/http.dart' as http;
import 'package:freibr/config/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  static Future<dynamic> registerUser(UserModel param) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    var response = await http.post(stringToUri(UrlDto.registerUser),
        headers: userheaders, body: json.encode(param));

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return true;
    }
    return null;
  }

  static dynamic getFacebookProfile(String token) async {
    final graphResponse = await http.get(stringToUri(
        'https://graph.facebook.com/v2.12/me?fields=name,picture,first_name,last_name,email&access_token=' +
            token));
    return json.decode(graphResponse.body);
  }

  static Future<dynamic> verifyOtp(String otpNumber, String username) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    try {
      var response = await http.post(stringToUri(UrlDto.verifyOtp),
          headers: userheaders,
          body: json.encode({'username': username, 'otp_number': otpNumber}));

      var result = json.decode(response.body);
      return result;
    } catch (error) {}
  }

  static Future<dynamic> approveUser(String username) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    try {
      var response = await http.post(stringToUri(UrlDto.approveUser),
          headers: userheaders, body: json.encode({'username': username}));

      var result = json.decode(response.body);
      return result;
    } catch (error) {}
  }

  static Future<dynamic> isProfileCompleted(String username) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    try {
      var response = await http.post(stringToUri(UrlDto.isProfileCompleted),
          headers: userheaders, body: json.encode({'username': username}));

      var result = json.decode(response.body);
      return result;
    } catch (error) {}
  }

  static Future<dynamic> isExistEmail(String username) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    try {
      var response = await http.post(stringToUri(UrlDto.isExistEmail),
          headers: userheaders, body: json.encode({'username': username}));
      var result = json.decode(response.body);

      return result;
    } catch (error) {}
  }

  static Future<dynamic> isExistPhone(String username) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    try {
      var response = await http.post(stringToUri(UrlDto.isExistPhone),
          headers: userheaders, body: json.encode({'username': username}));

      var result = json.decode(response.body);
      return result;
    } catch (error) {}
  }

  static Future<dynamic> loginRegisterFacebook(UserModel param) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    var response = await http.post(stringToUri(UrlDto.loginOrRegisterFacebook),
        headers: userheaders, body: json.encode(param));

    var result = json.decode(response.body);
    return result;
  }

  static Future<dynamic> changePassword(
      String username, String password) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    var response = await http.post(stringToUri(UrlDto.changePassword),
        headers: userheaders,
        body: json.encode({'username': username, 'password': password}));

    var result = json.decode(response.body);
    return result;
  }

  static Future<dynamic> userLogin(String username, String password) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    var response = await http.post(stringToUri(UrlDto.userLogin),
        headers: userheaders,
        body: json.encode({'username': username, 'password': password}));

    var result = json.decode(response.body);
    return result;
  }

  static Future<dynamic> sendNewRegisterOtp(dynamic param) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    var response = await http.post(stringToUri(UrlDto.sendNewRegisterOtp),
        headers: userheaders, body: json.encode(param));

    var data = json.decode(response.body);
    return data;
  }

  static Future<dynamic> registerDevice(DeviceInfo param) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
    };
    http.Response response = await http.post(stringToUri(UrlDto.registerDevice),
        headers: userheaders, body: json.encode(param));

    var data = json.decode(response.body);
    return data;
  }

  static Future<dynamic> refreshToken() async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token.replaceAll('"', '')
    };
    http.Response response =
        await http.get(stringToUri(UrlDto.refreshToken), headers: userheaders);
    var data = json.decode(response.body);
    return data;
  }

  static Future<Map<String, dynamic>> changeCurrentPassword(
      Map<String, dynamic> data) async {
    String token = await AppSharedPreferences.getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token.replaceAll('"', '')
    };

    var requestData = json.encode(data);

    var response = await http.post(stringToUri(UrlDto.changeCurrentPassword),
        headers: headers, body: requestData);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    }
    return null;
  }
}

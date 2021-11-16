import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freibr/config/url.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/model/user/user_expertise.dart';
import 'package:freibr/util/util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static Future<dynamic> uploadFileAsFormData(
      File param, String userCode) async {
    try {
      final dio = Dio();
      dio.options.headers = {
        // 'Content-Type': 'application/x-www-form-urlencoded',
        "Accept": "application/json",
      };

      final file = await MultipartFile.fromFile(param.path,
          filename: param.path.split('/').last);

      // final formData = FormData.fromMap({'picked_file': file});
      var formData = FormData();
      formData.files.addAll([
        MapEntry("picked_files_1", file),
      ]);
      formData.fields.add(MapEntry("user_code", userCode));
      final response = await dio.post(
        UrlDto.singleUploadProfileImageFile,
        data: formData,
      );
      if (response.data["status"]) {
        return response.data["data"];
      }
      return null;
    } catch (err) {
      print('uploading error: $err');
    }
  }

  static Future<dynamic> changeProfilePic(PlatformFile param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      final dio = Dio();
      dio.options.headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        HttpHeaders.authorizationHeader: 'Bearer ' + token.replaceAll('"', ''),
      };
      final file =
          await MultipartFile.fromFile(param.path, filename: param.name);

      final formData = FormData.fromMap({'picked_file': file});

      final response = await dio.post(
        UrlDto.changeProfilePic,
        data: formData,
      );

      if (response.data["status"]) {
        return response.data["data"];
      }
      return null;
    } catch (err) {
      print('uploading error: $err');
    }
  }

  static Future<dynamic> changeProfilePic1(PickedFile param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      final dio = Dio();
      dio.options.headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        HttpHeaders.authorizationHeader: 'Bearer ' + token.replaceAll('"', ''),
      };
      final file = await MultipartFile.fromFile(param.path,
          filename: param.path.split('/').last);

      final formData = FormData.fromMap({'picked_file': file});

      final response = await dio.post(
        UrlDto.changeProfilePic,
        data: formData,
      );

      if (response.data["status"]) {
        return response.data["data"];
      }
      return null;
    } catch (err) {
      print('uploading error: $err');
    }
  }

  static Future<dynamic> changeRoomPic(
      PickedFile param, dynamic callback) async {
    try {
      String token = await AppSharedPreferences.getToken();
      final dio = Dio();
      dio.options.headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        HttpHeaders.authorizationHeader: 'Bearer ' + token.replaceAll('"', ''),
      };
      final file = await MultipartFile.fromFile(param.path,
          filename: param.path.split('/').last);
      final formData = FormData.fromMap({'picked_file': file});

      final response = await dio.post(UrlDto.changeRoomPic, data: formData,
          onSendProgress: (int sent, int total) {
        // String percentage = (sent / total * 100).toStringAsFixed(2);
        callback((sent / total * 100));
      });
      print(response.data);
      if (response.data["status"]) {
        return response.data["data"];
      }
      return null;
    } catch (err) {
      print('uploading error: $err');
    }
  }

  static Future<dynamic> updateUserProfile(UserModel param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.updateProfile),
          headers: userheaders, body: json.encode(param));

      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('uploading error: $err');
    }
    return null;
  }

  static Future<dynamic> removeExpertise(UserExpertise param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.removeExpertise),
          headers: userheaders, body: json.encode(param));

      var result = json.decode(response.body);
      if (result['status']) {
        return result;
      }
    } catch (err) {
      print('uploading error: $err');
    }
    return null;
  }

  static Future<UserExpertise> createExpertise(UserExpertise param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.createExpertise),
          headers: userheaders, body: json.encode(param));

      var result = json.decode(response.body);
      if (result['status']) {
        return UserExpertise.fromJson(result['data']);
      }
    } catch (err) {}
    return null;
  }

  static Future<dynamic> updateExpertise(UserExpertise param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.updateExpertise),
          headers: userheaders, body: json.encode(param));

      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('uploading error: $err');
    }
    return null;
  }

  static Future<UserModel> getProfile() async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token.replaceAll('"', ''),
    };
    var response =
        await http.get(stringToUri(UrlDto.getProfile), headers: userheaders);
    var result = json.decode(response.body);
    if (result['status']) {
      return UserModel.fromJson(result['data']);
    }
    return null;
  }

  static Future<UserModel> getOtherUserProfile(String userID) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token.replaceAll('"', ''),
    };

    var response = await http.post(stringToUri(UrlDto.getOtherUserProfile),
        headers: userheaders, body: json.encode({'userID': userID}));
    var result = json.decode(response.body);
    if (result['status']) {
      return UserModel.fromJson(result['data']);
    }
    return null;
  }
}

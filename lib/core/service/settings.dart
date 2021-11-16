import 'dart:convert';

import 'package:freibr/config/url.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:http/http.dart' as http;

class BlockUserService {
  static Future<Map> getBlockedUsers({int pageNumber = 1}) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    var jsonBody = json.encode({});
    final response = await http.post(
        stringToUri(UrlDto.allBlockUsers + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return {
        'current_page': result['data']['current_page'],
        'last_page': result['data']['last_page'],
        'list': UserModel.toListFromJson(result['data']['data'])
      };
    }
    return null;
  }

  static Future<dynamic> blockUser(int userId) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    try {
      var response = await http.post(stringToUri(UrlDto.blockUser),
          body: json.encode({"block_user_id": userId}), headers: userheaders);
      var result = json.decode(response.body);

      return result;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> unBlockUser(int userId) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    try {
      var response = await http.post(stringToUri(UrlDto.unblockUser),
          body: json.encode({"block_user_id": userId}), headers: userheaders);
      var result = json.decode(response.body);

      return result;
    } catch (e) {
      return null;
    }
  }
}

import 'dart:convert';

import 'package:freibr/config/url.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/util/util.dart';
import 'package:http/http.dart' as http;

class BankDetailsService {
  static Future<dynamic> saveBankDetails(final data) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody = json.encode(data);
    final response = await http.post(stringToUri(UrlDto.saveBankDetails),
        body: jsonBody, headers: userheaders);
    var result = json.decode(response.body);
    return result;
  }

  static Future<dynamic> getBankDetails(final data) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody = json.encode(data);
    final response = await http.post(stringToUri(UrlDto.getBankDetails),
        body: jsonBody, headers: userheaders);
    var result = json.decode(response.body);
    return result;
  }
}

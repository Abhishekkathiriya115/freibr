import 'dart:convert';

import 'package:freibr/config/url.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/util/util.dart';
import 'package:http/http.dart' as http;

class OfferService {
  static Future<Map> saveOfferLog(String status, int offerId) async {
    try {
      String token = await AppSharedPreferences.getToken();

      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': "Bearer " + token.replaceAll('"', ''),
      };

      final data = {'offer_status': status, 'offer_id': offerId};

      var response = await http.post(stringToUri(UrlDto.saveOfferLog),
          headers: userheaders, body: json.encode(data));
      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('uploading error: $err');
    }
  }

  static Future<Map> savePaymentTransaction(final data) async {
    try {
      String token = await AppSharedPreferences.getToken();

      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': "Bearer " + token.replaceAll('"', ''),
      };

      var response = await http.post(stringToUri(UrlDto.savePaymentTransaction),
          headers: userheaders, body: json.encode(data));
      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('uploading error: $err');
    }
  }

  static Future<void> getPagedPaymentHistory() async {
    try {
      String token = await AppSharedPreferences.getToken();

      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': "Bearer " + token.replaceAll('"', ''),
      };

      var response = await http.post(stringToUri(UrlDto.getPagedPaymentHistory),
          headers: userheaders, body: json.encode({}));
      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('uploading error: $err');
    }
  }
}

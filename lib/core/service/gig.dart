import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freibr/config/url.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/model/gig/faq.dart';
import 'package:freibr/core/model/gig/gig.dart';
import 'package:freibr/core/model/gig/gig_media.dart';
import 'package:freibr/core/model/gig/gig_pricing.dart';
import 'package:freibr/core/model/paging/paging.dart';
import 'package:freibr/util/util.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class GigService {
  static Future<PageModel<GigModel>> getPagedGigs(
      dynamic pageNumber, dynamic pageSize) async {
    String token = await AppSharedPreferences.getToken();

    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody = json.encode({'itemsPerPage': pageSize});
    print(UrlDto.getPagedGigs + '?page=$pageNumber');
    final response = await http.post(
        stringToUri(UrlDto.getPagedGigs + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);

    if (result["status"] == true) {
      return PageModel<GigModel>.fromJson(
          result['data'], GigModel.fromJsonModel);
    }
    return null;
  }

  static Future<dynamic> saveGig(GigModel param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.saveGig),
          headers: userheaders, body: json.encode(param));

      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('uploading error: $err');
    }
    return null;
  }

  static Future<dynamic> editGig(GigModel param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.editGig),
          headers: userheaders, body: json.encode(param));

      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('uploading error: $err');
    }
    return null;
  }

  static Future<dynamic> saveGigPricing(GigPricingModel param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.saveGig),
          headers: userheaders, body: json.encode(param));

      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('uploading error: $err');
    }
    return null;
  }

  static Future<dynamic> saveFaq(GigFaqModel param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.saveGigFaq),
          headers: userheaders, body: json.encode(param));

      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('faq error: $err');
    }
    return null;
  }

  static Future<dynamic> removeFAQ(GigFaqModel param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.removeFaq),
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

  static Future<dynamic> saveQuestion(GigFaqModel param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.saveGigAskedQuestion),
          headers: userheaders, body: json.encode(param));

      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('faq error: $err');
    }
    return null;
  }

  static Future<dynamic> removeQuestion(GigFaqModel param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.removeGigAskedQuestion),
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

  static Future<dynamic> saveGalleryFile(PickedFile param, String gigID) async {
    try {
      String token = await AppSharedPreferences.getToken();
      final dio = Dio();
      dio.options.headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        HttpHeaders.authorizationHeader: 'Bearer ' + token.replaceAll('"', ''),
      };

      var formData = FormData();
      formData.files.addAll([
        MapEntry("picked_file", await MultipartFile.fromFile(param.path)),
      ]);

      formData.fields.add(MapEntry("gig_id", gigID));
      final response = await dio.post(
        UrlDto.saveGalleryFile,
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

  static Future<dynamic> removeGalleryFile(GigMediaModel param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.removeGalleryFile),
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

  static Future<dynamic> removeCategory(CategoryModel param) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.removeCategory),
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
}

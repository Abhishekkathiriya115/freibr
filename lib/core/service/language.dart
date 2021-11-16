import 'dart:convert';

import 'package:freibr/config/url.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/model/paging/paging.dart';
import 'package:freibr/core/model/language.dart';
import 'package:freibr/util/util.dart';
import 'package:http/http.dart' as http;

class LanguageService {
  static Future<PageModel<LanguageModel>> getPagedLanguages(
      String pageNumber, String pageSize, String queryParam) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody =
        json.encode({'itemsPerPage': pageSize, 'queryParam': queryParam});
    final response = await http.post(
        stringToUri(UrlDto.getPagedLanguages + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);
    print(response.body);
    var result = json.decode(response.body);
    if (result["status"] == true) {
      return PageModel<LanguageModel>.fromJson(
          result['data'], LanguageModel.fromJsonModel);
    }

    return null;
  }
}

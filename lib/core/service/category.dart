import 'dart:convert';

import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/model/paging/paging.dart';
import 'package:freibr/util/util.dart';
import 'package:http/http.dart' as http;
import 'package:freibr/config/url.dart';

class CategoryService {
  static Future<PageModel<CategoryModel>> getCategoriesWithParent(
      String pageNumber,
      String pageSize,
      CategoryModel param,
      String queryParam) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      // 'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody = param.id == null
        ? json.encode({'itemsPerPage': pageSize, 'queryParam': queryParam})
        : json.encode({
            'itemsPerPage': pageSize,
            'parent_id': param.id,
            'queryParam': queryParam
          });

    final response = await http.post(
        stringToUri(UrlDto.loadSubcategoriesWithParent +
            param.slug +
            '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return PageModel<CategoryModel>.fromJson(
          result['data'], CategoryModel.fromJsonModel);
    }
    return null;
  }

  
  static Future<PageModel<CategoryModel>> getCategories(
      String pageNumber, String pageSize, String queryParam) async {
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      // 'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody =
        json.encode({'itemsPerPage': pageSize, 'queryParam': queryParam});
    final response = await http.post(
        stringToUri(UrlDto.loadCategories + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return PageModel<CategoryModel>.fromJson(
          result['data'], CategoryModel.fromJsonModel);
    }
    return null;
  }
}

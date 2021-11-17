import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freibr/config/url.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/model/paging/paging.dart';
import 'package:freibr/core/model/post/post_comment.dart';
import 'package:freibr/core/model/post/post_model.dart';
import 'package:freibr/util/util.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:http/http.dart' as http;

class PostService {
  static Future<dynamic> uploadPost(
      PostModel param, Set<MediaFile> mediaFiles, dynamic callback) async {
    try {
      String token = await AppSharedPreferences.getToken();
      final dio = Dio();
      dio.options.headers = {
        // 'Content-Type': 'application/x-www-form-urlencoded',
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ' + token.replaceAll('"', ''),
      };

      var formData = FormData();
      int index = 1;
      for (var file in mediaFiles) {
        formData.files.addAll([
          MapEntry(
              "picked_files_$index", await MultipartFile.fromFile(file.path)),
        ]);
        index++;
      }

      formData.fields.add(MapEntry("post", jsonEncode(param)));

      final response = await dio.post(UrlDto.uploadPost, data: formData,
          onSendProgress: (int sent, int total) {
        // String percentage = (sent / total * 100).toStringAsFixed(2);

        // callback({
        //   'message': "$sent" +
        //       " Bytes of " "$total Bytes - " +
        //       percentage +
        //       " % uploaded",
        //   'sent': sentCount++
        // });
        callback((sent / total * 100));
      });

      return response.data;
    } catch (err) {
      return null;
    }
  }

  static Future uploadPostUpdate(PostModel postModel, dynamic callback) async {
    String token = await AppSharedPreferences.getToken();
print( postModel.id);
    Map<String, dynamic> body = {
      'title': postModel.title,
      'description': postModel.description,
      'is_active': 1,
      'post_id': postModel.id
    };
    var requestData = json.encode(body);
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var url = stringToUri(UrlDto.postUpdate);
    final response =
        await http.post(url, body: requestData, headers: userheaders);
    print(response.body);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      return result;
    }
    return null;
  }

  static Future<dynamic> uploadTestPost(
      PostModel param, Set<MediaFile> mediaFiles, dynamic callback) async {
    try {
      final dio = Dio();
      dio.options.headers = {
        // 'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var formData = FormData();
      int index = 1;
      for (var file in mediaFiles) {
        formData.files.addAll([
          MapEntry(
              "picked_files_$index", await MultipartFile.fromFile(file.path)),
        ]);
        index++;
      }

      final response = await dio.post(UrlDto.uploadFileTest, data: formData,
          onSendProgress: (int sent, int total) {
        // String percentage = (sent / total * 100).toStringAsFixed(2);
        callback((sent / total * 100));
      });
      return response.data;
    } catch (err) {
      return null;
    }
  }

  static Future<PageModel<PostModel>> getPostsList(
      dynamic pageNumber, dynamic pageSize) async {
    String token = await AppSharedPreferences.getToken();

    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    final response = await http.post(
        stringToUri(UrlDto.postList + '?page=$pageNumber'),
        headers: userheaders);

    var result = json.decode(response.body);

    if (result["status"] == true) {
      return PageModel<PostModel>.fromJson(
          result['data'], PostModel.fromJsonModel);
    }
    return null;
  }

  static Future<PageModel<PostModel>> getPostsWithUser(
      dynamic pageNumber, dynamic pageSize, dynamic userID) async {
    String token = await AppSharedPreferences.getToken();

    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody = json
        .encode({'itemsPerPage': pageSize, 'other_user_id': userID.toString()});

    final response = await http.post(
        stringToUri(UrlDto.getTimelinePostsWithUser + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);

    if (result["status"] == true) {
      return PageModel<PostModel>.fromJson(
          result['data'], PostModel.fromJsonModel);
    }
    return null;
  }

  static Future setLike(int postId) async {
    String token = await AppSharedPreferences.getToken();

    Map<String, dynamic> body = {'post_id': postId};
    var requestData = json.encode(body);
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var url = stringToUri(UrlDto.postLike);
    final response =
        await http.post(url, body: requestData, headers: userheaders);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return result;
    }
    return null;
  }

  static Future setDislike(int postId) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, dynamic> body = {'post_id': postId};
    var requestData = json.encode(body);
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    final response = await http.post(stringToUri(UrlDto.postDislike),
        body: requestData, headers: userheaders);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return result;
    }
    return null;
  }

  static Future getPostComments(int postId, {int page}) async {
    String token = await AppSharedPreferences.getToken();
    var url = stringToUri(UrlDto.postComments + '?page=${page}');
    Map<String, dynamic> body = {'post_id': postId, 'itemsPerPage': 20};
    var requestData = json.encode(body);
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    final response =
        await http.post(url, body: requestData, headers: userheaders);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if (result['status']) {
        PageModel<PostComment> data = PageModel<PostComment>.fromJson(
            result['data'], PostComment.fromJsonModel);
        return data;
      }
      return null;
    }
    return null;
  }

  static Future<PostComment> setPostComment(Map<String, dynamic> data) async {
    String token = await AppSharedPreferences.getToken();
    var requestData = json.encode(data);
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var url = stringToUri(UrlDto.setPostComments);

    var response =
        await http.post(url, body: requestData, headers: userheaders);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if (result['status']) {
        return PostComment.fromJson(result['data']);
      }
    }

    return null;
  }

  static Future<Map> bookmarkAdd(Map data) async {
    String token = await AppSharedPreferences.getToken();
    var requestData = json.encode(data);
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var url = stringToUri(UrlDto.bookmarkAdd);
    var response =
        await http.post(url, body: requestData, headers: userheaders);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return result;
    }

    return null;
  }

  static Future<Map> bookmarkRemove(Map data) async {
    String token = await AppSharedPreferences.getToken();
    var requestData = json.encode(data);
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var url = stringToUri(UrlDto.bookmarkRemove);
    var response =
        await http.post(url, body: requestData, headers: userheaders);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return result;
    }

    return null;
  }

  static Future<Map> postDelete(int id) async {
    String token = await AppSharedPreferences.getToken();
    Map data = {'post_id': id};
    var requestData = json.encode(data);
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    var url = stringToUri(UrlDto.postDelete);
    var response =
        await http.post(url, body: requestData, headers: userheaders);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return result;
    }

    return null;
  }
  static Future<Map> commentDelete(int id,int commentid) async {
    String token = await AppSharedPreferences.getToken();
    Map data = {'post_id': id,'comment_id' : commentid};
    var requestData = json.encode(data);
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    var url = stringToUri(UrlDto.commentDelete);
    var response =
    await http.post(url, body: requestData, headers: userheaders);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return result;
    }

    return null;
  }
}

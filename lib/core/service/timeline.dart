import 'dart:convert';

import 'package:freibr/config/url.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/model/notification_model.dart';
import 'package:freibr/core/model/paging/paging.dart';
import 'package:freibr/core/model/post/post_comment.dart';
import 'package:freibr/core/model/post/post_model.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/model/user/user_follow.dart';
import 'package:freibr/util/util.dart';
import 'package:http/http.dart' as http;

import '../model/paging/paging.dart';
import '../model/user/user_follow.dart';

class TimelineService {
  static Future<List<PostModel>> getPosts(String pageNumber) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody = json.encode({'itemsPerPage': 6});
    final response = await http.post(
        stringToUri(UrlDto.getTimelinePosts + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return PostModel.toListFromJson(result["data"]["data"]);
    }
    return [];
  }

  static Future<PageModel<UserModel>> getTimelineUser(
      String pageNumber, String pageSize) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': "Bearer " + token.replaceAll('"', ''),
      };

      var jsonBody = json.encode({'itemsPerPage': pageSize});
      final response = await http.post(
          stringToUri(UrlDto.getTimelineUsers + '?page=$pageNumber'),
          headers: userheaders,
          body: jsonBody);

      var result = json.decode(response.body);

      if (result["status"] == true) {
        return PageModel<UserModel>.fromJson(
            result['data'], UserModel.fromJsonModel);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<PageModel<UserFollowModel>> getTimelineLiveUsers(
      String pageNumber, String pageSize) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': "Bearer " + token.replaceAll('"', ''),
      };
      var jsonBody = json.encode({'itemsPerPage': pageSize});
      final response = await http.post(
          stringToUri(UrlDto.getTimelineLiveUsers + '?page=$pageNumber'),
          headers: userheaders,
          body: jsonBody);

      var result = json.decode(response.body);
      if (result["status"] == true) {
        return PageModel<UserFollowModel>.fromJson(
            result['data'], UserFollowModel.fromJsonModel);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<List<PostComment>> getComments(
      String pageNumber, PostModel post) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody = json.encode({'itemsPerPage': 10, 'post_id': post.id});
    final response = await http.post(
        stringToUri(UrlDto.getPostComments + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);

    if (result["status"] == true) {
      return PostComment.toListFromJson(result["data"]["data"]);
    }
    return [];
  }

  static Future<dynamic> setLikePost(PostModel param) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody = json.encode({'post_id': param.id});
    final response = await http.post(stringToUri(UrlDto.setLikePost),
        headers: userheaders, body: jsonBody);

    var result = json.decode(response.body);
    return result;
  }

  static Future<dynamic> setDislikePost(PostModel param) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody = json.encode({'post_id': param.id});
    final response = await http.post(stringToUri(UrlDto.setDislikePost),
        headers: userheaders, body: jsonBody);

    var result = json.decode(response.body);
    return result;
  }

  static Future<dynamic> setPostComment(
      PostModel param, String commentText) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody = json.encode({'post_id': param.id, 'comment': commentText});
    final response = await http.post(stringToUri(UrlDto.setComment),
        headers: userheaders, body: jsonBody);

    var result = json.decode(response.body);
    return result;
  }

  static Future<UserModel> setFollowUser(String userID) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.setFollowUser),
          headers: userheaders, body: json.encode({'other_user_id': userID}));

      var result = json.decode(response.body);
      if (result['status'] == true) {
        return UserModel.fromJson(result['record']);
      }
    } catch (err) {}
    return null;
  }

  static Future<dynamic> followApproveReject(
      String followID, String status) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token.replaceAll('"', ''),
      };
      var response = await http.post(stringToUri(UrlDto.followApproveReject),
          headers: userheaders,
          body: json.encode({'id': followID, 'status': status}));
      var result = json.decode(response.body);
      return result;
    } catch (err) {
      print('error: $err');
    }
    return null;
  }

  static Future<PageModel<UserFollowModel>> getPagedFollowings(
      String userID, String pageNumber, String pageSize) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    var jsonBody =
        json.encode({'itemsPerPage': pageSize, 'otherUserID': userID});
    final response = await http.post(
        stringToUri(UrlDto.getPagedFollowings + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return PageModel<UserFollowModel>.fromJson(
          result['data'], UserFollowModel.fromJsonModel);
    }
    return null;
  }

  static Future<PageModel<UserFollowModel>> getPagedFollowRequests(
      String pageNumber, String pageSize) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': "Bearer " + token.replaceAll('"', ''),
      };

      var jsonBody = json.encode({'itemsPerPage': pageSize});
      final response = await http.post(
          stringToUri(UrlDto.getPagedFollowRequests + '?page=$pageNumber'),
          headers: userheaders,
          body: jsonBody);

      var result = json.decode(response.body);
      if (result["status"] == true) {
        return PageModel<UserFollowModel>.fromJson(
            result['data'], UserModel.fromJsonModel);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<PageModel<UserFollowModel>> getPagedFollowers(
      String userID, String pageNumber, String pageSize) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    var jsonBody =
        json.encode({'itemsPerPage': pageSize, 'otherUserID': userID});
    final response = await http.post(
        stringToUri(UrlDto.getPagedFollowers + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return PageModel<UserFollowModel>.fromJson(
          result['data'], UserFollowModel.fromJsonModel);
    }
    return null;
  }

  static Future<dynamic> goLive() async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    final response = await http.post(stringToUri(UrlDto.goLive),
        headers: userheaders, body: json.encode({}));
    var result = json.decode(response.body);

    return result;
  }

  static Future<List<UserModel>> getPagedGroupChats(
      String pageNumber, String pageSize) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': "Bearer " + token.replaceAll('"', ''),
      };

      var jsonBody = json.encode({'itemsPerPage': pageSize});
      final response = await http.post(
          stringToUri(UrlDto.getPagedGroupChats + '?page=$pageNumber'),
          headers: userheaders,
          body: jsonBody);

      var result = json.decode(response.body);
      if (result["status"] == true) {
        List<UserModel> items = [];
        for (dynamic key in result["data"]['data']) {
          items.add(UserModel.fromJson(key['host']));
        }
        return items;
        // return UserModel.toListFromJson(result["data"]["data"]);
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  static Future<PageModel<UserModel>> getUserSearch(
      String pageNumber, String pageSize, String queryParam) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody =
        json.encode({'itemsPerPage': pageSize, 'queryParam': queryParam});
    final response = await http.post(
        stringToUri(UrlDto.getPagedUserProfiles + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return PageModel<UserModel>.fromJson(
          result['data'], UserModel.fromJsonModel);
    }

    return null;
  }

  static Future<PageModel<UserModel>> getUserSearchLiveSessions(
      String pageNumber, String pageSize, String queryParam) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };
    var jsonBody =
        json.encode({'itemsPerPage': pageSize, 'queryParam': queryParam});
    final response = await http.post(
        stringToUri(UrlDto.getUserSearchLiveSessions + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return PageModel<UserModel>.fromJson(
          result['data'], UserModel.fromJsonModel);
    }

    return null;
  }

  static Future<bool> checkIsLive(String userID) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    final response = await http.get(
        stringToUri(UrlDto.checkIsLive + '/$userID'),
        headers: userheaders);

    var result = json.decode(response.body);
    return result["status"];
  }

  static Future<bool> closeLiveConference(String userID) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    final response = await http.get(
        stringToUri(UrlDto.closeLiveConference + '/$userID'),
        headers: userheaders);

    var result = json.decode(response.body);
    return result["status"];
  }

  static Future<PageModel<NotificationModel>> getPagedNotifications(
      String pageNumber, String pageSize) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': "Bearer " + token.replaceAll('"', ''),
      };

      var jsonBody = json.encode({'itemsPerPage': pageSize});
      final response = await http.post(
          stringToUri(UrlDto.getPagedNotifications + '?page=$pageNumber'),
          headers: userheaders,
          body: jsonBody);

      var result = json.decode(response.body);

      if (result["status"] == true) {
        return PageModel<NotificationModel>.fromJson(
            result['data'], NotificationModel.fromJsonModel);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}

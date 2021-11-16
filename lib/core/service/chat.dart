import 'dart:convert';

import 'package:freibr/config/url.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/model/chat/chat.dart';
import 'package:freibr/core/model/chat/personal.dart';
import 'package:freibr/core/model/paging/paging.dart';
import 'package:freibr/util/util.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static Future<PageModel<GroupChatModel>> getPagedGroupChats(
      String pageNumber, String pageSize) async {
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
      return PageModel<GroupChatModel>.fromJson(
          result['data'], GroupChatModel.fromJsonModel);
    }
    return null;
  }

  static Future<PageModel<GroupChatModel>> getGroupMessages(
      String roomID, String pageNumber, String pageSize) async {
    try {
      String token = await AppSharedPreferences.getToken();
      Map<String, String> userheaders = {
        "Content-Type": "application/json",
        'Authorization': "Bearer " + token.replaceAll('"', ''),
      };

      var jsonBody = json.encode({'itemsPerPage': pageSize, 'roomID': roomID});
      final response = await http.post(
          stringToUri(UrlDto.getGroupMessages + '?page=$pageNumber'),
          headers: userheaders,
          body: jsonBody);

      var result = json.decode(response.body);
      if (result["status"] == true) {
        return PageModel<GroupChatModel>.fromJson(
            result['data'], GroupChatModel.fromJsonModel);
      }
    } catch (e) {}
    return null;
  }

  static Future<PageModel<PersonalChatModel>> getPagedPersonalChatUser(
      String pageNumber, String pageSize) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    var jsonBody = json.encode({'itemsPerPage': pageSize});
    final response = await http.post(
        stringToUri(UrlDto.getPagedPersonalChatUser + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return PageModel<PersonalChatModel>.fromJson(
          result['data'], PersonalChatModel.fromJsonModel);
    }
    return null;
  }

  static Future<PageModel<PersonalChatModel>> getPagedPersonalChat(
      String pageNumber, String pageSize, String otherUserID) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    var jsonBody =
        json.encode({'itemsPerPage': pageSize, 'otherUserID': otherUserID});
    final response = await http.post(
        stringToUri(UrlDto.getPagedPersonalChat + '?page=$pageNumber'),
        headers: userheaders,
        body: jsonBody);

    var result = json.decode(response.body);
    if (result["status"] == true) {
      return PageModel<PersonalChatModel>.fromJson(
          result['data'], PersonalChatModel.fromJsonModel);
    }
    return null;
  }

  static Future<Map> deleteChatUser(senderID, receiverID) async {
    String token = await AppSharedPreferences.getToken();
    Map<String, String> userheaders = {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + token.replaceAll('"', ''),
    };

    var jsonBody =
        json.encode({'sender_id': senderID, 'receiver_id': receiverID});
    final response = await http.post(stringToUri(UrlDto.deletePersonalChatUser),
        headers: userheaders, body: jsonBody);
    var result = json.decode(response.body);
    return result;
  }
}

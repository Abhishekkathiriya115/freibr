import 'dart:convert';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/model/user/user_follow.dart';

class NotificationModel {
  NotificationModel({
    this.id,
    this.to,
    this.sender,
    this.message,
    this.messageType,
    this.jsonData,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.toUser,
    this.follower,
    this.fromUser,
  });

  int id;
  dynamic to;
  dynamic sender;
  String message;
  String messageType;
  String jsonData;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel toUser;
  UserFollowModel follower;
  UserModel fromUser;

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"] == null ? null : json["id"],
        to: json["to"] == null ? null : json["to"],
        sender: json["sender"] == null ? null : json["sender"],
        message: json["message"] == null ? null : json["message"],
        messageType: json["message_type"] == null ? null : json["message_type"],
        jsonData: json["json_data"] == null ? null : json["json_data"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
         follower: json["follower"] == null
            ? null
            : UserFollowModel.fromJson(json["follower"]),
        toUser: json["to_user"] == null
            ? null
            : UserModel.fromJson(json["to_user"]),
        fromUser: json["from_user"] == null
            ? null
            : UserModel.fromJson(json["from_user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "to": to == null ? null : to,
        "sender": sender == null ? null : sender,
        "message": message == null ? null : message,
        "message_type": messageType == null ? null : messageType,
        "json_data": jsonData == null ? null : jsonData,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "to_user": toUser == null ? null : toUser.toJson(),
        "follower": follower == null ? null : follower.toJson(),
        "from_user": fromUser == null ? null : fromUser.toJson(),
      };

  static NotificationModel fromJsonModel(Map<String, dynamic> json) =>
      NotificationModel.fromJson(json);
}

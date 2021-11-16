// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

import 'package:freibr/core/model/user/user.dart';

class GroupChatModel {
  GroupChatModel(
      {this.id,
      this.roomId,
      this.otherUserId,
      this.isMe,
      this.message,
      this.messageType,
      this.createdAt,
      this.updatedAt,
      this.host,
      this.messenger});

  int id;
  int roomId;
  int otherUserId;
  dynamic isMe;
  String message;
  String messageType;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel host;
  UserModel messenger;

  factory GroupChatModel.fromRawJson(String str) =>
      GroupChatModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GroupChatModel.fromJson(Map<String, dynamic> json) => GroupChatModel(
        id: json["id"] == null ? null : json["id"],
        roomId: json["room_id"] == null ? null : json["room_id"],
        otherUserId:
            json["other_user_id"] == null ? null : json["other_user_id"],
        isMe: json["isMe"] == null ? null : json["isMe"],
        message: json["message"] == null ? null : json["message"],
        messageType: json["message_type"] == null ? null : json["message_type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        host: json["host"] == null ? null : UserModel.fromJson(json["host"]),
        messenger: json["messenger"] == null
            ? null
            : UserModel.fromJson(json["messenger"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "room_id": roomId == null ? null : roomId,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "isMe": isMe == null ? null : isMe,
        "message": message == null ? null : message,
        "message_type": messageType == null ? null : messageType,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "host": host == null ? null : host.toJson(),
        "messenger": messenger == null ? null : messenger.toJson(),
      };

  static GroupChatModel fromJsonModel(Map<String, dynamic> json) =>
      GroupChatModel.fromJson(json);
}

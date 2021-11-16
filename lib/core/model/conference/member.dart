import 'dart:convert';

import 'package:freibr/core/model/user/user.dart';

class RoomMemberModel {
  RoomMemberModel({
    this.id,
    this.roomId,
    this.otherUserId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int id;
  int roomId;
  int otherUserId;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel user;

  factory RoomMemberModel.fromRawJson(String str) =>
      RoomMemberModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoomMemberModel.fromJson(Map<String, dynamic> json) =>
      RoomMemberModel(
        id: json["id"] == null ? null : json["id"],
        roomId: json["room_id"] == null ? null : json["room_id"],
        otherUserId:
            json["other_user_id"] == null ? null : json["other_user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "room_id": roomId == null ? null : roomId,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "user": user == null ? null : user.toJson(),
      };

  static List<RoomMemberModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<RoomMemberModel>.from(
            json.map((x) => RoomMemberModel.fromJson(x)));
  }
}

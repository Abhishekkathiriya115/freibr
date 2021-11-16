import 'dart:convert';

import 'user.dart';

class UserFollowModel {
  UserFollowModel({
    this.id,
    this.userId,
    this.otherUserId,
    this.status,
    this.totalFollowRequests,
    this.createdAt,
    this.updatedAt,
    this.follower,
    this.following,
  });

  dynamic id;
  dynamic userId;
  dynamic otherUserId;
  String status;
  dynamic totalFollowRequests;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel follower;

  UserModel following;

  factory UserFollowModel.fromRawJson(String str) =>
      UserFollowModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserFollowModel.fromJson(Map<String, dynamic> json) =>
      UserFollowModel(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        otherUserId:
            json["other_user_id"] == null ? null : json["other_user_id"],
        status: json["status"] == null ? null : json["status"],
        totalFollowRequests: json["totalFollowRequests"] == null
            ? null
            : json["totalFollowRequests"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        follower: json["follower"] == null
            ? null
            : UserModel.fromJson(json["follower"]),
        following: json["following"] == null
            ? null
            : UserModel.fromJson(json["following"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "status": status == null ? null : status,
        "totalFollowRequests":
            totalFollowRequests == null ? null : totalFollowRequests,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "follower": follower == null ? null : follower.toJson(),
        "followers": following == null ? null : following.toJson(),
      };

  static List<UserFollowModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<UserFollowModel>.from(
            json.map((x) => UserFollowModel.fromJson(x)));
  }

  static UserFollowModel fromJsonModel(Map<String, dynamic> json) =>
      UserFollowModel.fromJson(json);
}

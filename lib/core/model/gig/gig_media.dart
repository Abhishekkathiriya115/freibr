// To parse this JSON data, do
//
//     final GigMediaModel = GigMediaModelFromJson(jsonString);

import 'dart:convert';

class GigMediaModel {
  GigMediaModel({
    this.id,
    this.mediaUrl,
    this.size,
    this.mediaType,
    this.gigId,
    this.otherUserId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String mediaUrl;
  String size;
  String mediaType;
  dynamic gigId;
  dynamic otherUserId;
  DateTime createdAt;
  DateTime updatedAt;

  factory GigMediaModel.fromJson(Map<String, dynamic> json) {
    return GigMediaModel(
      id: json["id"] == null ? null : json["id"],
      mediaUrl: json["media_url"] == null ? null : json["media_url"],
      size: json["size"] == null ? null : json["size"].toString(),
      mediaType: json["media_type"] == null ? null : json["media_type"],
      gigId: json["gig_id"] == null ? null : json["gig_id"],
      otherUserId: json["other_user_id"] == null ? null : json["other_user_id"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "media_url": mediaUrl == null ? null : mediaUrl,
        "size": size == null ? null : size,
        "media_type": mediaType == null ? null : mediaType,
        "gig_id": gigId == null ? null : gigId,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  GigMediaModel gigMediaModelFromJson(String str) =>
      GigMediaModel.fromJson(json.decode(str));

  String gigMediaModelToJson(GigMediaModel data) => json.encode(data.toJson());

  static List<GigMediaModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<GigMediaModel>.from(json.map((x) => GigMediaModel.fromJson(x)));
  }
}

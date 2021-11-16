// To parse this JSON data, do
//
//     final gigFaqModel = gigFaqModelFromJson(jsonString);

import 'dart:convert';

class GigFaqModel {
  GigFaqModel({
    this.id,
    this.title,
    this.description,
    this.gigId,
    this.otherUserId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  String description;
  dynamic gigId;
  dynamic otherUserId;
  DateTime createdAt;
  DateTime updatedAt;

  factory GigFaqModel.fromJson(Map<String, dynamic> json) => GigFaqModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        gigId: json["gig_id"] == null ? null : json["gig_id"],
        otherUserId:
            json["other_user_id"] == null ? null : json["other_user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "gig_id": gigId == null ? null : gigId,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  GigFaqModel gigFaqModelFromJson(String str) =>
      GigFaqModel.fromJson(json.decode(str));

  String gigFaqModelToJson(GigFaqModel data) => json.encode(data.toJson());

  static List<GigFaqModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<GigFaqModel>.from(json.map((x) => GigFaqModel.fromJson(x)));
  }
}

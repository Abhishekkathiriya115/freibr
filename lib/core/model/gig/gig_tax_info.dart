// To parse this JSON data, do
//
//     final gigTaxinfoModel = gigTaxinfoModelFromJson(jsonString);

import 'dart:convert';

class GigTaxinfoModel {
  GigTaxinfoModel({
    this.id,
    this.name,
    this.country,
    this.state,
    this.gigId,
    this.otherUserId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String country;
  String state;
  dynamic gigId;
  dynamic otherUserId;
  DateTime createdAt;
  DateTime updatedAt;

  factory GigTaxinfoModel.fromJson(Map<String, dynamic> json) =>
      GigTaxinfoModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        country: json["country"] == null ? null : json["country"],
        state: json["state"] == null ? null : json["state"],
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
        "name": name == null ? null : name,
        "country": country == null ? null : country,
        "state": state == null ? null : state,
        "gig_id": gigId == null ? null : gigId,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  GigTaxinfoModel gigTaxinfoModelFromJson(String str) =>
      GigTaxinfoModel.fromJson(json.decode(str));

  String gigTaxinfoModelToJson(GigTaxinfoModel data) =>
      json.encode(data.toJson());
}

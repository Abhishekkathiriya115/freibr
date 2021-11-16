// To parse this JSON data, do
//
//     final gigCategoryModel = gigCategoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:freibr/core/model/category.dart';

class GigCategoryModel {
  GigCategoryModel({
    this.id,
    this.categoryId,
    this.category,
    this.gigId,
    this.otherUserId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic categoryId;
  dynamic gigId;
  dynamic otherUserId;
  CategoryModel category;
  DateTime createdAt;
  DateTime updatedAt;

  factory GigCategoryModel.fromJson(Map<String, dynamic> json) =>
      GigCategoryModel(
        id: json["id"] == null ? null : json["id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
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
        "category_id": categoryId == null ? null : categoryId,
        "gig_id": gigId == null ? null : gigId,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  GigCategoryModel gigCategoryModelFromJson(String str) =>
      GigCategoryModel.fromJson(json.decode(str));

  String gigCategoryModelToJson(GigCategoryModel data) =>
      json.encode(data.toJson());

  static List<GigCategoryModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<GigCategoryModel>.from(
            json.map((x) => GigCategoryModel.fromJson(x)));
  }
}

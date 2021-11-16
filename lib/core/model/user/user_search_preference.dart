// To parse this JSON data, do
//
//     final userSearchPreference = userSearchPreferenceFromJson(jsonString);

import 'dart:convert';

import 'package:freibr/core/model/category.dart';

class UserSearchPreference {
  UserSearchPreference({
    this.id,
    this.categoryId,
    this.userId,
    this.category,
    this.searhType,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic categoryId;
  dynamic userId;
  String searhType;
  dynamic createdAt;
  dynamic updatedAt;
  CategoryModel category;

  factory UserSearchPreference.fromRawJson(String str) =>
      UserSearchPreference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserSearchPreference.fromJson(Map<String, dynamic> json) =>
      UserSearchPreference(
        id: json["id"] == null ? null : json["id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        category: json["categories"] == null
            ? null
            : CategoryModel.fromJson(json["categories"]),
        searhType: json["searh_type"] == null ? null : json["searh_type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "category_id": categoryId == null ? null : categoryId,
        "user_id": userId == null ? null : userId,
        "searh_type": searhType == null ? null : searhType,
        "categories": category == null ? null : category,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  static List<UserSearchPreference> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<UserSearchPreference>.from(
            json.map((x) => UserSearchPreference.fromJson(x)));
  }
}

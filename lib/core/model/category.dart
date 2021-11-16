// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

class CategoryModel {
  CategoryModel(
      {this.id,
      this.avatar,
      this.name,
      this.slug,
      this.description,
      this.parentCategoryId,
      this.parent,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.childrenCount,
      this.checked = false});

  dynamic id;
  String avatar;
  String name;
  String slug;
  String description;
  dynamic parentCategoryId;
  CategoryModel parent;
  dynamic isActive;
  dynamic checked;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic childrenCount;

  factory CategoryModel.fromRawJson(String str) =>
      CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] == null ? null : json["id"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        parent: json["parent"] == null
            ? null
            : CategoryModel.fromJson(json["parent"]),
        description: json["description"] == null ? null : json["description"],
        parentCategoryId: json["parent_category_id"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        childrenCount:
            json["children_count"] == null ? null : json["children_count"],
        checked: json["checked"] == null ? false : true,
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "avatar": avatar == null ? null : avatar,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "description": description == null ? null : description,
        "parent": parent == null ? null : parent,
        "parent_category_id": parentCategoryId,
        "is_active": isActive == null ? null : isActive,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "children_count": childrenCount == null ? null : childrenCount,
        "checked": checked == null ? false : true,
      };

  static List<CategoryModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<CategoryModel>.from(json.map((x) => CategoryModel.fromJson(x)));
    
  }

  static CategoryModel fromJsonModel(Map<String, dynamic> json) =>
      CategoryModel.fromJson(json);
}

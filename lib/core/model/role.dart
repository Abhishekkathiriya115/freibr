class RoleModel {
  RoleModel({
    this.id,
    this.name,
    this.slug,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
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
        "slug": slug == null ? null : slug,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  static List<RoleModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<RoleModel>.from(json.map((x) => RoleModel.fromJson(x)));
  }
}

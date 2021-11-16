import 'dart:convert';

class UserExpertise {
  UserExpertise({
    this.id,
    this.title,
    this.rating,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  String rating;
  dynamic userId;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserExpertise.fromJson(Map<String, dynamic> json) => UserExpertise(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        rating: json["rating"] == null ? '0.0' : json["rating"],
        userId: json["user_id"] == null ? null : json["user_id"],
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
        "rating": rating == null ? '3.0' : rating,
        "user_id": userId == null ? null : userId,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  factory UserExpertise.fromRawJson(String str) =>
      UserExpertise.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static List<UserExpertise> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<UserExpertise>.from(json.map((x) => UserExpertise.fromJson(x)));
  }
}

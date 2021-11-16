import 'dart:convert';

class RoomModel {
  RoomModel(
      {this.id,
      this.otherUserId,
      this.title,
      this.slug,
      this.description,
      this.totalMembers,
      this.conferenceDate,
      this.imageUrl,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.isSubscribed = false});

  int id;
  int otherUserId;
  String title;
  String slug;
  String description;
  DateTime conferenceDate;
  int status;
  String imageUrl;
  dynamic totalMembers;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSubscribed;

  factory RoomModel.fromRawJson(String str) =>
      RoomModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json["id"] == null ? null : json["id"],
        otherUserId:
            json["other_user_id"] == null ? null : json["other_user_id"],
        title: json["title"] == null ? null : json["title"],
        slug: json["slug"] == null ? null : json["slug"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        conferenceDate: json["conference_date"] == null
            ? null
            : DateTime.parse(json["conference_date"]),
        description: json["description"] == null ? null : json["description"],
        totalMembers:
            json["totalMembers"] == null ? null : json["totalMembers"],
        isSubscribed:
            json["isSubscribed"] == null ? null : json["isSubscribed"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "title": title == null ? null : title,
        "slug": slug == null ? null : slug,
        "image_url": imageUrl == null ? null : imageUrl,
        "description": description == null ? null : description,
        "totalMembers": totalMembers == null ? null : totalMembers,
        "status": status == null ? null : status,
        "conference_date":
            conferenceDate == null ? null : conferenceDate.toIso8601String(),
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  static List<RoomModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<RoomModel>.from(json.map((x) => RoomModel.fromJson(x)));
  }
}

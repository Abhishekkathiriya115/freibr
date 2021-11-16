import 'package:freibr/core/model/user/user.dart';

class PostComment {
  PostComment({
    this.id,
    this.otherUserId,
    this.postId,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int id;
  dynamic otherUserId;
  dynamic postId;
  String comment;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel user;

  PostComment copyWith({
    int id,
    String otherUserId,
    String postId,
    String comment,
    DateTime createdAt,
    DateTime updatedAt,
    UserModel user,
  }) =>
      PostComment(
        id: id ?? this.id,
        otherUserId: otherUserId ?? this.otherUserId,
        postId: postId ?? this.postId,
        comment: comment ?? this.comment,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );

  factory PostComment.fromJson(Map<String, dynamic> json) => PostComment(
        id: json["id"] == null ? null : json["id"],
        otherUserId: json["other_user_id"] == null
            ? null
            : json["other_user_id"].toString(),
        postId: json["post_id"] == null ? null : json["post_id"],
        comment: json["comment"] == null ? null : json["comment"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "post_id": postId == null ? null : postId,
        "comment": comment == null ? null : comment,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "user": user == null ? null : user.toJson(),
      };

  static List<PostComment> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<PostComment>.from(json.map((x) => PostComment.fromJson(x)));
  }

  static PostComment fromJsonModel(Map<String, dynamic> json) =>
      PostComment.fromJson(json);
}

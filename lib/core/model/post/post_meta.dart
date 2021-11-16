class PostMetaModel {
  PostMetaModel({
    this.id,
    this.userId,
    this.postId,
    this.postExpression,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  int postId;
  int postExpression;
  DateTime createdAt;
  DateTime updatedAt;

  factory PostMetaModel.fromJson(Map<String, dynamic> json) => PostMetaModel(
        id: json["id"] == null ? null : json["id"],
        userId: json["other_user_id"] == null ? null : json["other_user_id"],
        postId: json["post_id"] == null ? null : json["post_id"],
        postExpression:
            json["post_expression"] == null ? null : json["post_expression"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "other_user_id": userId == null ? null : userId,
        "post_id": postId == null ? null : postId,
        "post_expression": postExpression == null ? null : postExpression,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  static List<PostMetaModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<PostMetaModel>.from(json.map((x) => PostMetaModel.fromJson(x)));
  }
}

class PostMediaModel {
  PostMediaModel({
    this.id,
    this.postId,
    this.mediaType,
    this.mediaUrl,
    this.mediaSize,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic postId;
  String mediaUrl;
  String mediaSize;
  String mediaType;
  DateTime createdAt;
  DateTime updatedAt;

  factory PostMediaModel.fromJson(Map<String, dynamic> json) => PostMediaModel(
        id: json["id"] == null ? null : json["id"],
        postId: json["post_id"] == null ? null : json["post_id"],
        mediaSize: json["size"] == null ? null : json["size"],
        mediaType: json["media_type"] == null ? null : json["media_type"],
        mediaUrl: json["media_url"] == null ? null : json["media_url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "post_id": postId == null ? null : postId,
        "size": mediaSize == null ? null : mediaSize,
        "media_type": mediaType == null ? null : mediaType,
        "media_url": mediaUrl == null ? null : mediaUrl,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };

  static List<PostMediaModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<PostMediaModel>.from(
            json.map((x) => PostMediaModel.fromJson(x)));
  }
}

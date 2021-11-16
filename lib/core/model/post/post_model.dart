import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/model/post/post_media.dart';
import 'package:freibr/core/model/post/post_meta.dart';
import 'package:freibr/core/model/user/user.dart';

class PostModel {
  PostModel(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.totalLikes,
      this.totalComments,
      this.postMeta,
      this.postMedia,
      this.categories,
      this.isLiked,
      this.isSaved,
      this.postPrivacy,
      this.user,
      // this.comments,
      this.commentOn,
      this.isAdult,
      this.saveGallery});

  int id;
  dynamic userId;

  String title;
  String description;
  dynamic isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic totalLikes;
  dynamic totalComments;
  dynamic commentOn;
  dynamic saveGallery;
  dynamic isAdult;
  List<PostMetaModel> postMeta;
  List<PostMediaModel> postMedia = [];
  List<CategoryModel> categories;
  String postPrivacy;
  bool isLiked, isSaved;
  UserModel user;
  // List<CommentModel> comments;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        totalLikes: json["totalLikes"] == null ? null : json["totalLikes"],
        totalComments:
            json["totalComments"] == null ? null : json["totalComments"],
        postMeta: json["post_meta"] == null
            ? null
            : List<PostMetaModel>.from(
                json["post_meta"].map((x) => PostMetaModel.fromJson(x))),
        isLiked: json["isLiked"] == null ? null : json["isLiked"],
        isSaved: json["isSaved"] == null ? null : json["isSaved"],
        commentOn: json["comment_on"] == null ? null : json["comment_on"],
        saveGallery: json["save_gallery"] == null ? null : json["save_gallery"],
        isAdult: json["is_adult"] == null ? 0 : json["is_adult"],

        postMedia: json["post_media"] == null
            ? null
            : List<PostMediaModel>.from(
                json["post_media"].map((x) => PostMediaModel.fromJson(x))),
        categories: json["categories"] == null
            ? null
            : List<CategoryModel>.from(
                json["categories"].map((x) => CategoryModel.fromJson(x))),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        // comments: json["comments"] == null
        //     ? null
        //     : List<CommentModel>.from(
        //         json["comments"].map((x) => CommentModel.fromJson(x))
        // ),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "is_active": isActive == null ? null : isActive,

        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "totalLikes": totalLikes == null ? null : totalLikes,
        "totalComments": totalComments == null ? null : totalComments,
        "post_meta": postMeta == null
            ? null
            : List<dynamic>.from(postMeta.map((x) => x.toJson())),
        "isLiked": isLiked == null ? null : isLiked,
        "user": user == null ? null : user.toJson(),
        "comment_on": commentOn == null ? null : commentOn,
        "is_adult": isAdult == null ? null : isAdult,
        "post_privacy": postPrivacy == null ? null : postPrivacy,

        // "hashtag": hashtag == null ? null : hashtag.toJson(),
        "save_gallery": saveGallery == null ? null : saveGallery,
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories.map((x) => x.toJson())),
        // "comments": comments == null
        //     ? null
        //     : List<dynamic>.from(comments.map((x) => x.toJson())),
      };

  static List<PostModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<PostModel>.from(json.map((x) => PostModel.fromJson(x)));
  }

  static PostModel fromJsonModel(Map<String, dynamic> json) =>
      PostModel.fromJson(json);
}

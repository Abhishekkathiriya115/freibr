// To parse this JSON data, do
//
//      userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:freibr/core/model/language.dart';
import 'package:freibr/core/model/role.dart';
import 'package:freibr/core/model/user/user_expertise.dart';
import 'package:freibr/core/model/user/user_search_preference.dart';

class UserModel {
  UserModel(
      {this.id,
      this.name,
      this.profileName,
      this.username,
      this.email,
      this.phone,
      this.password,
      this.alternateContact,
      this.language,
      this.bio,
      this.location,
      this.gender,
      this.avatar,
      this.follow,
      this.totalFollower,
      this.totalFollowing,
      this.categoryId,
      this.roomAvatar,
      this.thumbnailAvatar,
      this.roleId,
      this.isActive,
      this.isLive,
      this.userStatus,
      this.createdAt,
      this.updatedAt,
      this.role,
      this.noOfLogins,
      this.userSearchPrefrences,
      this.userCode,
      this.profileType,
      this.languages,
      this.userExpertises});

  int id;
  String name;
  String profileName;
  String userCode;
  String username;
  String email;
  String phone;
  String password;
  dynamic alternateContact;
  dynamic location;
  dynamic language;
  dynamic bio;
  dynamic gender;
  String avatar;
  String thumbnailAvatar;
  dynamic categoryId;
  dynamic noOfLogins;
  String follow;
  dynamic totalFollower;
  dynamic totalFollowing;
  dynamic roleId;
  String profileType;
  String roomAvatar;
  dynamic isActive;
  dynamic isLive;
  String userStatus;
  DateTime createdAt;
  DateTime updatedAt;
  RoleModel role;
  List<UserSearchPreference> userSearchPrefrences;
  List<UserExpertise> userExpertises;
  List<LanguageModel> languages;

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        profileName: json["profile_name"] == null ? null : json["profile_name"],
        username: json["username"] == null ? null : json["username"],
        userCode: json["usercode"] == null ? null : json["usercode"],
        profileType: json["profile_type"] == null ? null : json["profile_type"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        password: json["password"] == null ? null : json["password"],
        alternateContact: json["alternate_contact"],
        gender: json["gender"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        follow: json["follow"] == null ? null : json["follow"],
        totalFollower:
            json["totalFollower"] == null ? null : json["totalFollower"],
        totalFollowing:
            json["totalFollowing"] == null ? null : json["totalFollowing"],
        thumbnailAvatar:
            json["thumbnail_avatar"] == null ? null : json["thumbnail_avatar"],
        roomAvatar: json["room_avatar"] == null ? null : json["room_avatar"],
        location: json["location"] == null ? null : json["location"],
        language: json["language"] == null ? null : json["language"],
        bio: json["bio"] == null ? null : json["bio"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        roleId: json["role_id"] == null ? null : json["role_id"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        isLive: json["is_live"] == null ? null : json["is_live"],
        userStatus: json["user_status"] == null ? null : json["user_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        role: json["role"] == null ? null : RoleModel.fromJson(json["role"]),
        noOfLogins: json["no_of_logins"] == null ? null : json["no_of_logins"],
        languages: json["languages"] == null
            ? []
            : List<LanguageModel>.from(
                json["languages"].map((x) => LanguageModel.fromJson(x))),
        userSearchPrefrences: json["user_search_prefrences"] == null
            ? []
            : List<UserSearchPreference>.from(json["user_search_prefrences"]
                .map((x) => UserSearchPreference.fromJson(x))),
        userExpertises: json["user_expertises"] == null
            ? []
            : List<UserExpertise>.from(
                json["user_expertises"].map((x) => UserExpertise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "profile_name": profileName == null ? null : profileName,
        "username": username == null ? null : username,
        "usercode": userCode == null ? null : userCode,
        "profile_type": profileType == null ? null : profileType,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "password": password == null ? null : password,
        "alternate_contact": alternateContact == null ? null : alternateContact,
        "totalFollower": totalFollower == null ? null : totalFollower,
        "totalFollowing": totalFollowing == null ? null : totalFollowing,
        "follow": follow == null ? null : follow,
        "gender": gender,
        "avatar": avatar == null ? null : avatar,
        "location": location == null ? null : location,
        "language": language == null ? null : language,
        "bio": bio == null ? null : bio,
        "category_id": categoryId == null ? null : categoryId,
        "thumbnail_avatar": thumbnailAvatar == null ? null : thumbnailAvatar,
        "room_avatar": roomAvatar == null ? null : roomAvatar,
        "role_id": roleId == null ? null : roleId,
        "is_active": isActive == null ? null : isActive,
        "is_live": isLive == null ? null : isLive,
        "user_status": userStatus == null ? null : userStatus,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "role": role == null ? null : role.toJson(),
        "languages": languages == null
            ? null
            : List<dynamic>.from(languages.map((x) => x.toJson())),
        "user_search_prefrences": userSearchPrefrences == null
            ? null
            : List<dynamic>.from(userSearchPrefrences.map((x) => x.toJson())),
        "user_expertises": userExpertises == null
            ? null
            : List<dynamic>.from(userExpertises.map((x) => x.toJson())),
      };

  static List<UserModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<UserModel>.from(json.map((x) => UserModel.fromJson(x)));
  }

  static UserModel fromJsonModel(Map<String, dynamic> json) =>
      UserModel.fromJson(json);
}

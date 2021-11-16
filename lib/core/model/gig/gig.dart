import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/model/gig/faq.dart';
import 'package:freibr/core/model/gig/gig_media.dart';
import 'package:freibr/core/model/gig/gig_pricing.dart';
import 'package:freibr/core/model/gig/gig_tax_info.dart';
import 'package:freibr/core/model/user/user.dart';

class GigModel {
  GigModel({
    this.id,
    this.otherUserId,
    this.title,
    this.slug,
    this.description,
    this.tags,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.gigAskedQuestions,
    this.user,
    this.taxInformation,
    this.faqs,
    this.pricing,
    this.gigCategories,
    this.gigCategoriesIds,
    this.gigMedia,
  });

  int id;
  dynamic otherUserId;
  String title;
  String slug;
  String description;
  String tags;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;
  List<GigFaqModel> gigAskedQuestions;
  UserModel user;
  GigTaxinfoModel taxInformation;
  List<GigFaqModel> faqs = [];
  List<GigPricingModel> pricing;
  List<CategoryModel> gigCategories;
  String gigCategoriesIds;
  List<GigMediaModel> gigMedia;

  factory GigModel.fromJson(Map<String, dynamic> json) => GigModel(
        id: json["id"] == null ? null : json["id"],
        otherUserId:
            json["other_user_id"] == null ? null : json["other_user_id"],
        title: json["title"] == null ? null : json["title"],
        slug: json["slug"] == null ? null : json["slug"],
        description: json["description"] == null ? null : json["description"],
        tags: json["tags"] == null ? null : json["tags"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        gigAskedQuestions: json["gig_asked_questions"] == null
            ? []
            : List<GigFaqModel>.from(json["gig_asked_questions"]
                .map((x) => GigFaqModel.fromJson(x))),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        taxInformation: json["tax_information"] == null
            ? GigTaxinfoModel()
            : GigTaxinfoModel.fromJson(json["tax_information"]),
        faqs: json["faqs"] == null
            ? []
            : List<GigFaqModel>.from(
                json["faqs"].map((x) => GigFaqModel.fromJson(x))),
        pricing: json["pricing"] == null
            ? null
            : List<GigPricingModel>.from(json["pricing"].map((x) => x)),
        gigCategories: json["gig_categories"] == null
            ? null
            : List<CategoryModel>.from(
                json["gig_categories"].map((x) => CategoryModel.fromJson(x))),
        gigMedia: json["gig_media"] == null
            ? null
            : List<GigMediaModel>.from(
                json["gig_media"].map((x) => GigMediaModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "title": title == null ? null : title,
        "slug": slug == null ? null : slug,
        "description": description == null ? null : description,
        "tags": tags == null ? null : tags,
        "gigCategoriesIds": gigCategoriesIds == null ? null : gigCategoriesIds,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "gig_asked_questions": gigAskedQuestions == null
            ? []
            : List<dynamic>.from(gigAskedQuestions.map((x) => x.toJson())),
        "user": user == null ? null : user.toJson(),
        "tax_information":
            taxInformation == null ? null : taxInformation.toJson(),
        "faqs":
            faqs == null ? [] : List<dynamic>.from(faqs.map((x) => x.toJson())),
        "pricing":
            pricing == null ? null : List<dynamic>.from(pricing.map((x) => x)),
        "gig_categories": gigCategories == null
            ? null
            : List<dynamic>.from(gigCategories.map((x) => x.toJson())),
        "gig_media": gigMedia == null
            ? null
            : List<dynamic>.from(gigMedia.map((x) => x.toJson())),
      };

  static GigModel fromJsonModel(Map<String, dynamic> json) =>
      GigModel.fromJson(json);
}

// To parse this JSON data, do
//
//     final gigPricingModel = gigPricingModelFromJson(jsonString);

import 'dart:convert';

class GigPricingModel {
  GigPricingModel({
    this.id,
    this.packageName,
    this.packageId,
    this.noOfPages,
    this.designCustomization,
    this.contentUpload,
    this.responsiveDesign,
    this.includeSourceCode,
    this.noOfRevisions,
    this.price,
    this.gigId,
    this.otherUserId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String packageName;
  dynamic packageId;
  dynamic noOfPages;
  dynamic designCustomization;
  dynamic contentUpload;
  dynamic responsiveDesign;
  dynamic includeSourceCode;
  dynamic noOfRevisions;
  String price;
  dynamic gigId;
  dynamic otherUserId;
  dynamic createdAt;
  dynamic updatedAt;

  factory GigPricingModel.fromJson(Map<String, dynamic> json) =>
      GigPricingModel(
        id: json["id"] == null ? null : json["id"],
        packageName: json["package_name"] == null ? null : json["package_name"],
        packageId: json["package_id"] == null ? null : json["package_id"],
        noOfPages: json["no_of_pages"] == null ? null : json["no_of_pages"],
        designCustomization: json["design_customization"] == null
            ? null
            : json["design_customization"],
        contentUpload:
            json["content_upload"] == null ? null : json["content_upload"],
        responsiveDesign: json["responsive_design"] == null
            ? null
            : json["responsive_design"],
        includeSourceCode: json["include_source_code"] == null
            ? null
            : json["include_source_code"],
        noOfRevisions:
            json["no_of_revisions"] == null ? null : json["no_of_revisions"],
        price: json["price"] == null ? null : json["price"],
        gigId: json["gig_id"] == null ? null : json["gig_id"],
        otherUserId:
            json["other_user_id"] == null ? null : json["other_user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "package_name": packageName == null ? null : packageName,
        "package_id": packageId == null ? null : packageId,
        "no_of_pages": noOfPages == null ? null : noOfPages,
        "design_customization":
            designCustomization == null ? null : designCustomization,
        "content_upload": contentUpload == null ? null : contentUpload,
        "responsive_design": responsiveDesign == null ? null : responsiveDesign,
        "include_source_code":
            includeSourceCode == null ? null : includeSourceCode,
        "no_of_revisions": noOfRevisions == null ? null : noOfRevisions,
        "price": price == null ? null : price,
        "gig_id": gigId == null ? null : gigId,
        "other_user_id": otherUserId == null ? null : otherUserId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  GigPricingModel gigPricingModelFromJson(String str) =>
      GigPricingModel.fromJson(json.decode(str));

  String gigPricingModelToJson(GigPricingModel data) =>
      json.encode(data.toJson());

  static List<GigPricingModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<GigPricingModel>.from(
            json.map((x) => GigPricingModel.fromJson(x)));
  }
}

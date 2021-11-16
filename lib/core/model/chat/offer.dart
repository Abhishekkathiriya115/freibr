// To parse this JSON data, do
//
//     final offerModel = offerModelFromJson(jsonString);

import 'dart:convert';

OfferModel offerModelFromJson(String str) =>
    OfferModel.fromJson(json.decode(str));

String offerModelToJson(OfferModel data) => json.encode(data.toJson());

class OfferModel {
  OfferModel({
    this.id,
    this.offerId,
    this.otherUserId,
    this.offerStatus,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int offerId;
  int otherUserId;
  String offerStatus;
  DateTime createdAt;
  DateTime updatedAt;

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json["id"],
        offerId: json["offer_id"],
        otherUserId: json["other_user_id"],
        offerStatus: json["offer_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offer_id": offerId,
        "other_user_id": otherUserId,
        "offer_status": offerStatus,
        "created_at": createdAt == null
            ? DateTime.now().toIso8601String()
            : createdAt.toIso8601String(),
        "updated_at": updatedAt == null
            ? DateTime.now().toIso8601String()
            : updatedAt.toIso8601String(),
      };
}

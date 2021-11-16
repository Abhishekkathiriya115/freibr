import 'dart:convert';

import 'package:freibr/core/model/chat/offer.dart';
import 'package:freibr/core/model/user/user.dart';

class PersonalChatModel {
  PersonalChatModel(
      {this.id,
      this.senderID,
      this.receiverID,
      this.message,
      this.messageType,
      this.createdAt,
      this.updatedAt,
      this.sender,
      this.receiver,
      this.offerStatus});

  int id;
  int senderID;
  int receiverID;
  String message;
  String messageType;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel sender;
  UserModel receiver;
  OfferModel offerStatus;

  factory PersonalChatModel.fromRawJson(String str) =>
      PersonalChatModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonalChatModel.fromJson(Map<String, dynamic> json) =>
      PersonalChatModel(
          id: json["id"] == null ? null : json["id"],
          senderID: json["sender_id"] == null ? null : json["sender_id"],
          receiverID: json["receiver_id"] == null ? null : json["receiver_id"],
          message: json["message"] == null ? null : json["message"],
          messageType:
              json["message_type"] == null ? null : json["message_type"],
          createdAt: json["created_at"] == null
              ? null
              : DateTime.parse(json["created_at"]),
          updatedAt: json["updated_at"] == null
              ? null
              : DateTime.parse(json["updated_at"]),
          sender: json["sender"] == null
              ? null
              : UserModel.fromJson(json["sender"]),
          receiver: json["receiver"] == null
              ? null
              : UserModel.fromJson(json["receiver"]),
          offerStatus: json["offer_status"] == null
              ? null
              : OfferModel.fromJson(json["offer_status"]));

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "sender_id": senderID == null ? null : senderID,
        "receiver_id": receiverID == null ? null : receiverID,
        "message": message == null ? null : message,
        "message_type": messageType == null ? null : messageType,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "sender": sender == null ? null : sender.toJson(),
        "receiver": receiver == null ? null : receiver.toJson(),
        "offer_status": offerStatus == null ? null : offerStatus.toJson()
      };

  static PersonalChatModel fromJsonModel(Map<String, dynamic> json) =>
      PersonalChatModel.fromJson(json);
}

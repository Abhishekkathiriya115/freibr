// To parse this JSON data, do
//
//     final gigFaqModel = gigFaqModelFromJson(jsonString);

import 'dart:convert';

class CustomOrderModel {
  String price, deliveryTime, describeOffer;

  CustomOrderModel(
      {this.price = '0', this.deliveryTime = '0', this.describeOffer = ''});

  factory CustomOrderModel.fromJson(Map<String, dynamic> json) =>
      CustomOrderModel(
          price: json['price'],
          deliveryTime: json['deliveryTime'],
          describeOffer: json['describeOffer']);

  Map<String, dynamic> toJson() => {
        "price": price,
        "deliveryTime": deliveryTime,
        "describeOffer": describeOffer
      };

  CustomOrderModel customOrderModelFromJson(String str) =>
      CustomOrderModel.fromJson(json.decode(str));

  String customOrderModelToJson(Map data) => json.encode(data);
}

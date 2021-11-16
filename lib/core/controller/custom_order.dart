import 'package:flutter/material.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/model/custom_order/custom_order.dart';
import 'package:freibr/util/util.dart';

class CustomOrderController extends ChangeNotifier {
  final AuthenticationController authController;

  CustomOrderModel model;

  CustomOrderController({this.authController});

  void updateDeliveryTime(String value) {
    model.deliveryTime = value;
    notifyListeners();
  }

  void modifyModel() {
    model = CustomOrderModel();
  }

  bool validateForm() {
    bool isValid = true;

    if (model.describeOffer.length < 5) {
      showToast(message: "Describe offer should contain at least 5 characters");
      isValid = false;
    } else if (model.price == '' || double.parse(model.price) <= 0) {
      showToast(message: "Price should be greater then 0");
      isValid = false;
    } else if (int.parse(model.deliveryTime) == 0) {
      showToast(message: "Select delivery time");
      isValid = false;
    }
    return isValid;
  }
}

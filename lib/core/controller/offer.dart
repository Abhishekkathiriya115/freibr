import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freibr/core/controller/chat.dart';
import 'package:freibr/core/model/chat/offer.dart';
import 'package:freibr/core/model/custom_order/custom_order.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/service/offer.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/chat/common/single/offer_card.dart';

class OfferController extends ChangeNotifier {
  final ChatController chatController;
  final int index;

  OfferController(this.index, this.chatController);

  Future<void> changeStatus(String status, int offerId) async {
    try {
      showLoadingDialog();
      var result = await OfferService.saveOfferLog(status, offerId);
      if (result != null) {
        if (result['status']) {
          // chatController

          if (status == OfferStatus.PENDING) {
            chatController.personalChatMessageController.items[index]
                .offerStatus = OfferModel.fromJson(result['data']);
            print(chatController.personalChatMessageController.items[index]
                .offerStatus.offerStatus);
          }
          chatController.updateOfferStatus(
              index, result['data']['offer_status']);
          notifyListeners();
          showToast(message: result["message"]);
        } else {
          showToast(message: result["message"]);
        }
      }
    } catch (e) {
      dismissDialogToast();
    }
  }

  Future<void> savePaymentTransaction(
      {UserModel user,
      CustomOrderModel customOrderModel,
      String orderId,
      String paymentId,
      int offerId}) async {
    try {
      final transaction_data = {
        "accountingCode": {
          "id": chatController.authController.authUser.id,
          "code": "1",
          "name": customOrderModel.describeOffer,
          "quantity": 1.000,
          "unitAmount": customOrderModel.price
        },
        "description": customOrderModel.describeOffer,
        "quantity": 1.000,
        "unitAmountExcludingTax": 0.00,
        "unitAmountIncludingTax": 0.00,
        "taxable": false
      };

      final data = {
        'offer_id': offerId,
        'transaction_no': paymentId,
        'order_id': orderId,
        'transaction_data': json.encode(transaction_data)
      };

      //      'price': customOrderModel.price,
      // 'description': customOrderModel.describeOffer,
      // 'email': user.email,
      // 'phone': user.phone,
      // 'name': user.name,
      // 'user_id': user.name
      showLoadingDialog();
      final result = await OfferService.savePaymentTransaction(data);
      if (result != null) {
        if (result['status']) {
          showToast(message: result["message"]);
        } else {
          showToast(message: result["message"]);
        }
      }
    } catch (e) {
      print("uploading error $e");
      dismissDialogToast();
    }
  }
}

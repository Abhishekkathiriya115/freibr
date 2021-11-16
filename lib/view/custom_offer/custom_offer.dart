import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRMultilieTextField.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/chat.dart';
import 'package:freibr/core/controller/custom_order.dart';
import 'package:freibr/core/controller/offer.dart';
import 'package:freibr/core/model/chat/offer.dart';
import 'package:freibr/core/model/chat/personal.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/view/chat/common/single/offer_card.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CustomOffer extends StatelessWidget {
  static const double padding = 20.0;

  CustomOffer({
    Key key,
    this.user,
    this.socket,
    this.userId,
    this.authUserId,
  }) : super(key: key);

  final UserModel user;
  final int userId, authUserId;
  final IO.Socket socket;
  int offerId;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Get.theme;

    CustomOrderController _controller = Provider.of(context);
    ChatController chatController = Provider.of(context);
    OfferController _offerController = OfferController(0, chatController);

    dynamic getModel(String message, int sourceID, int targetID) {
      PersonalChatModel personalMessage = PersonalChatModel();
      personalMessage.message = message;
      personalMessage.receiverID = targetID;
      personalMessage.senderID = sourceID;
      personalMessage.messageType = 'offer';
      personalMessage.createdAt = DateTime.now();
      personalMessage.updatedAt = DateTime.now();
      personalMessage.offerStatus =
          OfferModel(offerStatus: OfferStatus.PENDING);
      return personalMessage.toJson();
    }

    void setMessage(dynamic param) {
      print(param);
      chatController.addPersonalMessage(PersonalChatModel.fromJson(param));
    }

    void sendMessage(String message, int sourceID, int targetID) {
      var model = getModel(message, sourceID, targetID);
      setMessage(model);
      final resonse =
          socket.emit('message', {"message": message, "param": model});
    }

    return StatefulWrapper(
      onInit: () {
        print("socket is connected on custom order ");
        print(socket.connected);
        socket
            .on("offer-" + chatController.authController.authUser.id.toString(),
                (res) {
          print(res);
          _offerController.changeStatus(OfferStatus.PENDING, res['insertId']);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create an offer'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(left: padding),
                child: Text(
                  "Describe Your Offer",
                  style: Get.theme.textTheme.subtitle1,
                )),
            Container(
              margin: EdgeInsets.fromLTRB(0, 13, 0, 15),
              child: FRMultilineTextField(
                hintText: "Describe Your Offer",
                keyboardType: TextInputType.multiline,
                onChanged: (res) {
                  _controller.model.describeOffer = res;
                },
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Single Payment",
                  style: Get.theme.textTheme.subtitle1,
                )),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Price',
                              style: Get.theme.textTheme.subtitle2,
                            ),
                            SizedBox(
                              width: 100,
                              child: FRTextField(
                                hintText: '\u{20B9}',
                                onChanged: (res) {
                                  _controller.model.price = res;
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Time',
                              style: Get.theme.textTheme.subtitle2,
                            ),
                            DropdownButton(
                              value: _controller.model != null
                                  ? _controller.model.deliveryTime
                                  : '0',
                              items: Iterable<DropdownMenuItem>.generate(91,
                                  (value) {
                                return DropdownMenuItem(
                                    value: value.toString(),
                                    child: value == 0
                                        ? Text('select')
                                        : Text('$value Days'));
                              }).toList(),
                              onChanged: (res) {
                                _controller.updateDeliveryTime(res);
                              },
                            ),
                          ]),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - padding,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(theme.accentColor),
                            ),
                            onPressed: () {
                              // _controller.saveOrder();
                              if (_controller.validateForm()) {
                                sendMessage(
                                    json.encode(_controller.model.toJson()),
                                    chatController.authController.authUser.id,
                                    user.id);
                                Get.back();
                              }
                            },
                            child: Text("Save")))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

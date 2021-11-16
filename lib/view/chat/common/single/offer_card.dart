import 'package:flutter/material.dart';
import 'package:freibr/core/controller/chat.dart';
import 'package:freibr/core/controller/offer.dart';
import 'package:freibr/core/model/chat/personal.dart';
import 'package:freibr/core/model/custom_order/custom_order.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/custom_offer/payment.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class OfferStatus {
  static const APPROVED = 'approved';
  static const PENDING = 'pending';
  static const REJECTED = 'rejected';
  static const SUBMITTED = 'submitted';
  static const WITHDRAWN = 'withdrawn';
  static const ACCEPTED = 'accepted';
  static const PAID = 'paid';
}

class OfferCard extends StatelessWidget {
  final ChatController chatController;
  final int index;
  final PersonalChatModel model;
  final bool isReply;
  final UserModel user;
  CustomOrderModel customOrderModel;
  Payment payment;
  OfferController _offerController;

  OfferCard(
      {Key key,
      this.model,
      this.isReply = false,
      this.user,
      this.chatController,
      this.index}) {
    payment = Payment(success: onSuccess, error: onError, offerId: model.id);
    _offerController = OfferController(index, chatController);
  }

  void onSuccess(
    String orderId,
    String paymentId,
  ) {
    _offerController.savePaymentTransaction(
        user: user,
        customOrderModel: customOrderModel,
        paymentId: paymentId,
        orderId: orderId,
        offerId: model.id);
    _offerController.changeStatus(OfferStatus.PAID, model.id);
  }

  void onError(String message) {
    showToast(message: message);
  }

  @override
  Widget build(BuildContext context) {
    customOrderModel =
        CustomOrderModel().customOrderModelFromJson(model.message);
    ThemeData theme = Get.theme;

    return Align(
      alignment: isReply ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Get.size.width - 85,
          minWidth: Get.size.width / 2.8,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: isReply
              ? Get.theme.accentColor.withOpacity(0.5)
              : Get.theme.accentColor,
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 30, 20),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customOrderModel.describeOffer ?? 'Offer title',
                            style: Get.theme.textTheme.subtitle1),
                        ListTile(
                          leading: Text(
                            '\u{20B9}',
                            style: TextStyle(fontSize: 24),
                          ),
                          title: Text(
                              'Offer price: ${customOrderModel.price ?? "0"}'),
                        ),
                        ListTile(
                          leading: Icon(Icons.schedule),
                          title: Text(
                              '${customOrderModel.deliveryTime ?? "0"} day\s delivery'),
                        ),
                        getActionButtons(theme)
                      ],
                    ),
                  )),
              SizedBox(height: 2),
              Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(children: [
                    Text(
                      convertToAgo(model.createdAt),
                      style: Get.theme.textTheme.bodyText1
                          .copyWith(fontSize: 8.sp),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.done_all,
                      size: 8.sp,
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  Widget getActionButtons(ThemeData theme) {
    Color activeBtnColor = theme.accentColor;
    Color inactiveBtnColor = Colors.white60;
    Color activeBackgroundColor = Colors.white;
    Color inactiveBackgroundColor = Colors.white24;

    switch (model.offerStatus != null ? model.offerStatus.offerStatus : '') {
      case OfferStatus.PENDING:
        return isReply
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OfferButton(
                    text: "Accept",
                    color: activeBtnColor,
                    backGroundColor: activeBackgroundColor,
                    onPressed: () {
                      _offerController.changeStatus(
                          OfferStatus.ACCEPTED, model.id);
                    },
                  ),
                  OfferButton(
                    text: "Reject",
                    color: activeBtnColor,
                    backGroundColor: activeBackgroundColor,
                    onPressed: () {
                      _offerController.changeStatus(
                          OfferStatus.REJECTED, model.id);
                    },
                  ),
                ],
              )
            : OfferButton(
                text: "Withdraw",
                color: activeBtnColor,
                backGroundColor: activeBackgroundColor,
                onPressed: () {
                  _offerController.changeStatus(
                      OfferStatus.WITHDRAWN, model.id);
                },
              );
      case OfferStatus.ACCEPTED:
        return isReply
            ? OfferButton(
                text: "Accepted",
                color: inactiveBtnColor,
                backGroundColor: inactiveBackgroundColor,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OfferButton(
                    text: "Pay",
                    color: activeBtnColor,
                    backGroundColor: activeBackgroundColor,
                    onPressed: () {
                      payment.processPayment(customOrderModel, user);
                    },
                  ),
                  Text(
                    'Offer accepted.',
                    style: theme.textTheme.caption,
                  )
                ],
              );
      case OfferStatus.REJECTED:
        return OfferButton(
          text: "Rejected",
          color: inactiveBtnColor,
          backGroundColor: inactiveBackgroundColor,
        );
      case OfferStatus.PAID:
        return isReply
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OfferButton(
                    text: "Submit",
                    color: activeBtnColor,
                    backGroundColor: activeBackgroundColor,
                    onPressed: () {
                      _offerController.changeStatus(
                          OfferStatus.SUBMITTED, model.id);
                    },
                  ),
                  Text(
                    'amount has been paid.',
                    style: theme.textTheme.caption,
                  )
                ],
              )
            : OfferButton(
                text: "Paid",
                color: inactiveBtnColor,
                backGroundColor: inactiveBackgroundColor,
              );
      case OfferStatus.SUBMITTED:
        return isReply
            ? OfferButton(
                text: "Submmited",
                color: inactiveBtnColor,
                backGroundColor: inactiveBackgroundColor,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OfferButton(
                    text: "Approve",
                    color: activeBtnColor,
                    backGroundColor: activeBackgroundColor,
                    onPressed: () {
                      _offerController.changeStatus(
                          OfferStatus.APPROVED, model.id);
                    },
                  ),
                  Text(
                    'Offer submitted.',
                    style: theme.textTheme.caption,
                  )
                ],
              );
      case OfferStatus.APPROVED:
        return OfferButton(
          text: "Approved",
          color: inactiveBtnColor,
          backGroundColor: inactiveBackgroundColor,
        );
      case OfferStatus.WITHDRAWN:
        return OfferButton(
          text: "Withdrawn",
          color: inactiveBtnColor,
          backGroundColor: inactiveBackgroundColor,
        );
      default:
        return Container();
    }
  }
}

class OfferButton extends StatelessWidget {
  final String text;
  final bool visible;
  final Color color, backGroundColor;
  final VoidCallback onPressed;

  const OfferButton(
      {Key key,
      this.text,
      this.visible = true,
      this.color = Colors.white,
      this.backGroundColor = Colors.white,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backGroundColor),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: color),
          ),
        ));
  }
}

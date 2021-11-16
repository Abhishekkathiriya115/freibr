import 'package:freibr/core/model/custom_order/custom_order.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment {
  Razorpay _razorpay;
  final Function(String) error, externalWallet;
  final Function(String, String) success;
  final int offerId;
  UserModel userModel;
  CustomOrderModel model;

  Payment({this.error, this.externalWallet, this.success, this.offerId}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void processPayment(CustomOrderModel model, UserModel userModel) {
    userModel = userModel;
    model = model;
    var options = {
      'key': 'rzp_test_sYV96pRKh4ETJl',
      'amount': double.parse(model.price) * 100,
      'name': userModel.name,
      'description': model.describeOffer,
      'prefill': {'contact': userModel.phone, 'email': userModel.email}
    };
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    success(response.orderId, response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    error(response.message);
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // externalWallet('Selected extenal wallet');
  }

  void dispose() {
    _razorpay.clear();
  }
}

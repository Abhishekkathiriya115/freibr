import 'package:flutter/foundation.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/model/bank_details.dart';
import 'package:freibr/core/service/bank_details.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';

class BankDetailsContoller extends ChangeNotifier {
  AuthenticationController authController;

  BankDetailsModel model = BankDetailsModel();
  bool isAddedBankDetails = false;

  BankDetailsContoller({this.authController});

  void saveBankDetails() async {
    model.userID = authController.authUser.id.toString();

    try {
      showLoadingDialog();
      final result = await BankDetailsService.saveBankDetails(model.toJson());
      print(result);
      if (result['status']) {
        isAddedBankDetails = result['status'];
        showToast(message: result['message']);
        Get.back();
        notifyListeners();
      } else {
        showToast(message: "Something went wrong");
      }
    } catch (e) {
      print(e);
      showToast(message: "Something went wrong");
    }
  }

  Future<void> getBankDetails() async {
    try {
      showLoadingDialog();
      final result = await BankDetailsService.getBankDetails(
          {'userID': authController.authUser.id.toString()});
      if (result['status'] && result['data']['account_details'] != null) {
        print(result['data']);
        model = BankDetailsModel.fromJson(result['data']['account_details']);
        isAddedBankDetails = result['status'];
        dismissDialogToast();
        notifyListeners();
      } else {
        dismissDialogToast();
      }
    } catch (e) {
      showToast(message: "Something went wrong");
    }
  }
}

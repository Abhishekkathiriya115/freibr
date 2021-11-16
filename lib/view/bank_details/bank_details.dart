import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/bank_details.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BankDetails extends StatelessWidget {
  BankDetails({Key key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const double spacing = 20;

  BankDetailsContoller _contoller;
  TextEditingController _accountHolderNameCtlr = TextEditingController();
  TextEditingController _accountNumberCtlr = TextEditingController();
  TextEditingController _ifscCodeCtlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _contoller = Provider.of(context);
    ThemeData theme = Get.theme;

    return StatefulWrapper(
      onInit: () async {
        await _contoller.getBankDetails();
        _accountHolderNameCtlr.text = _contoller.model.accountHolderName;
        _accountNumberCtlr.text = _contoller.model.accountNumber;
        _ifscCodeCtlr.text = _contoller.model.ifscCode;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bank Details",
              style: theme.textTheme.subtitle1.copyWith(fontSize: 14.sp)),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin:
                EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 20.0.sp),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FRTextField(
                    hintText: 'Account holder name',
                    textEditingController: _accountHolderNameCtlr,
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'please enter account holder name'),
                    ]),
                    onChanged: (res) {
                      _contoller.model.accountHolderName = res;
                    },
                  ),
                  SizedBox(
                    height: spacing,
                  ),
                  FRTextField(
                    hintText: 'Account number',
                    textEditingController: _accountNumberCtlr,
                    keyboardType: TextInputType.number,
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'please enter account number'),
                    ]),
                    onChanged: (res) {
                      _contoller.model.accountNumber = res;
                    },
                  ),
                  SizedBox(
                    height: spacing,
                  ),
                  FRTextField(
                    hintText: 'IFSC code',
                    textEditingController: _ifscCodeCtlr,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'please enter IFSC code'),
                    ]),
                    onChanged: (res) {
                      _contoller.model.ifscCode = res;
                    },
                  ),
                  SizedBox(
                    height: spacing * 2,
                  ),
                  FRButton(
                      onPressed: () async {
                        final bool isValid = _formKey.currentState.validate();
                        if (isValid) _contoller.saveBankDetails();
                      },
                      label: 'Save'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/register.dart';
import 'package:freibr/util/enum.dart';
import 'package:freibr/view/authentication/verify_otp.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


// ignore: must_be_immutable
class ForgotPassword extends StatelessWidget {
  String username = '';

  @override
  Widget build(BuildContext context) {
    final RegisterController registerController =
        Provider.of<RegisterController>(context, listen: true);
    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        //resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
              height: 100.h,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Forgot Password ?',
                      style:
                          Get.theme.textTheme.headline1,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'enter Email or Phone',
                      style: Get.theme.textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FRTextField(
                      hintText: 'enter Email or Phone'.toLowerCase(),
                      onChanged: (res) {
                        username = res;
                      },
                    ),
                    SizedBox(height: 20.0),
                    FRButton(
                      onPressed: () async {
                        await registerController.sendNewRegisterOtp(username);
                        Get.to(() => VerifyOtp(
                          verificationOtpType:
                              VerificationOtpType.forgotPassword,
                          username: this.username,
                        ));
                      },
                      label: "Send",
                    ),
                  ])),
        ),
      ),
    );
  }
}

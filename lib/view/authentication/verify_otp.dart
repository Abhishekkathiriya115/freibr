// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/register.dart';
import 'package:freibr/util/enum.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/authentication/new_password.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class VerifyOtp extends StatelessWidget {
  bool isEmail = true;
  String otpNumber = '';
  var verificationOtpType = VerificationOtpType.none;
  String username = '';

  VerifyOtp({Key key, @required this.verificationOtpType, this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegisterController controller =
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
                      'Enter confirmation code'.toUpperCase(),
                      style: Get.theme.textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RichText(
                      text: new TextSpan(
                        text: 'Enter the confirmation code that we sent to ',
                        style: Get.theme.textTheme.bodyText1,
                        children: <TextSpan>[
                          new TextSpan(
                              text: username,
                              style: Get.theme.textTheme.bodyText1.copyWith(
                                  // color: greenLight,

                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    FRTextField(
                      hintText: 'Confirmation code',
                      onChanged: (res) {
                        otpNumber = res;
                      },
                    ),
                    SizedBox(height: 20.0),
                    FRButton(
                      onPressed: () async {
                        username = controller.registerUser.username ?? username;
                        var status =
                            await controller.verifyOtp(otpNumber, username);
                        dismissDialogToast();
                        if (status) {
                          if (verificationOtpType ==
                              VerificationOtpType.approveAndLogin) {
                            controller.approveUser().then((_) {
                              controller.saveUser();
                            });
                          }
                          if (verificationOtpType ==
                              VerificationOtpType.approve) {
                            controller.approveUser();
                          }
                          if (verificationOtpType ==
                              VerificationOtpType.forgotPassword) {
                            Get.off(NewPassword(
                              username: username,
                            ));
                          }
                        }
                      },
                      label: 'Submit'.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "If do no not recieve any otp ?",
                            style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 10.sp),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          InkWell(
                            onTap: () async {
                              username =
                                  controller.registerUser.username ?? username;
                              await controller.sendNewRegisterOtp(username);
                            },
                            child: Text(
                              'send again',
                              style: Get.theme.textTheme.bodyText1.copyWith(color: Get.theme.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  ])),
        ),
      ),
    );
  }
}

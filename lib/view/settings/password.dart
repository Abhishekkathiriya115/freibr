import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Password extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Password({Key key}) : super(key: key);

  static const space = SizedBox(
    height: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {
      'password': '',
      'confirm_password': '',
      'current_password': ''
    };

    AuthenticationController _controller =
        Provider.of<AuthenticationController>(context);

    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Password',
              style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 15.sp),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FRTextField(
                    isSecured: true,
                    hintText: 'Current password',
                    onChanged: (res) {
                      data['current_password'] = res;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter current password';
                      }
                      return null;
                    },
                  ),
                  space,
                  FRTextField(
                    isSecured: true,
                    hintText: 'New password',
                    onChanged: (res) {
                      data['password'] = res;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password';
                      }
                      return null;
                    },
                  ),
                  space,
                  FRTextField(
                    isSecured: true,
                    hintText: 'New password, again',
                    onChanged: (res) {
                      data['confirm_password'] = res;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password, again';
                      } else if (value != data['password']) {
                        return 'Password doesn\'t match';
                      }
                      return null;
                    },
                  ),
                  space,
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Get.theme.accentColor),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _controller.changeCurrentPassword(data);
                              }
                            },
                            child: Text(
                              "Change password",
                              style: Get.textTheme.bodyText1,
                            ))),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

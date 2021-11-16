import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/FRPasswordTextField.dart';
import 'package:freibr/common/widget/FRTransparentButton.dart';
import 'package:freibr/common/widget/logo_widget.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/register.dart';
import 'package:freibr/view/authentication/forgot_password.dart';
import 'package:freibr/view/authentication/register.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  String username = '';
  String password = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final RegisterController registerController =
        Provider.of<RegisterController>(context, listen: true);

    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              // height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.symmetric(horizontal: 20.0.sp),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Center(
                        child: FRLogo(),
                      ),
                      Text(
                        "Welcome,",
                        style: Get.theme.textTheme.headline1
                            .copyWith(fontSize: 20.0.sp),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Sign up to get started",
                        style: Get.theme.textTheme.subtitle1,
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "Username",
                        style: Get.theme.textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FRTextField(
                        hintText: 'Phone number, email address, or username',
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText:
                                  'please enter your email or username or phone'),
                        ]),
                        onChanged: (res) {
                          username = res;
                        },
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        'Password',
                        style: Get.theme.textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FRPasswordField(
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'please enter your password'),
                        ]),
                        // fieldKey: _passwordFieldKey,
                        helperText: 'No more than 8 characters.',

                        onChanged: (res) {
                          password = res;
                        },
                        hintText: 'Password',
                        onFieldSubmitted: (String value) {},
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () => Get.to(ForgotPassword()),
                              child: Text(
                                "Forgot Password ?",
                                style: Get.theme.textTheme.bodyText1
                                    .copyWith(color: Get.theme.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      FRButton(
                          onPressed: () async {
                            final isValid = _formKey.currentState.validate();
                            if (!isValid) {
                              return;
                            }
                            registerController.authController
                                .userLogin(username, password);
                          },
                          label: 'Login'),
                      SizedBox(height: 15.0),
                      FRTransparentButton(
                        onPressed: () async {
                          registerController.facebookLogin();
                        },
                        label: "Login With Facebook",
                        icon: FontAwesome.facebook_square,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don`t have an account ?",
                                  style: Get.theme.textTheme.bodyText1),
                              SizedBox(
                                width: 10.0,
                              ),
                              InkWell(
                                onTap: () => Get.to(Register()),
                                child: Text('Sign Up',
                                    style: Get.theme.textTheme.bodyText1
                                        .copyWith(
                                            color: Get.theme.primaryColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                    ]),
              )),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FRPasswordTextField.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/register.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/authentication/upload_profile.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Step1 extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final RegisterController _controller =
        Provider.of<RegisterController>(context, listen: true);

    Widget buttonContainer() {
      return Column(
        children: [
          FRButton(
            onPressed: () async {
              final isValid = _formKey.currentState.validate();
              if (!isValid) {
                showToast(message: "please correct all the errors.");
                return;
              }
              showLoadingDialog();
              Future.delayed(Duration(seconds: 1), () {
                dismissDialogToast();
                Get.to(() => UploadProfile());
              });
            },
            label: 'Continue',
          ),
        ],
      );
    }

    Widget formContainer() {
      return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: Get.theme.textTheme.bodyText1,
            ),
            SizedBox(
              height: 5.0,
            ),
            FRTextField(
              hintText: 'Full Name',
              validator:
                  RequiredValidator(errorText: 'this field is required.'),
              onChanged: (res) => _controller.registerUser.name = res,
            ),
             SizedBox(
              height: 2.h,
            ),
            Text(
              'Password',
              style: Get.theme.textTheme.bodyText1,
            ),
            SizedBox(
              height: 5.0,
            ),
            FRPasswordField(
              validator:
                  RequiredValidator(errorText: 'this field is required.'),
              helperText: 'No more than 8 characters.',
              hintText: 'Password',
              onChanged: (res) => _controller.registerUser.password = res,
              onFieldSubmitted: (String value) {
                _controller.registerUser.password = value;
              },
            ),
            SizedBox(height: 20.0),
            buttonContainer(),
          ],
        ),
      );
    }

    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              child: Icon(FontAwesome.arrow_left),
              onTap: () => Get.back(),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
                height: 90.h,
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Welcome,",
                        style: Get.theme.textTheme.headline1,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Sign up to get started',
                        style: Get.theme.textTheme.subtitle1,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      formContainer(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                          child: Column(
                        children: [
                          Text(
                            'By Continueing you agree Friber`s\nTerms and conditions',
                            textAlign: TextAlign.center,
                            style: Get.theme.textTheme.bodyText1,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "already have an account ?",
                                    style: Get.theme.textTheme.bodyText1,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  InkWell(
                                    onTap: () => Get.back(),
                                    child: Text(
                                      'Login',
                                      style: Get.theme.textTheme.bodyText1
                                          .copyWith(
                                              color: Get.theme.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ))
                    ])),
          ),
        ));
  }
}

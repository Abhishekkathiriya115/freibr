import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NewPassword extends StatelessWidget {
  final String username;
  String password = '';

  NewPassword({Key key, @required this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthenticationController authenticationController =
        Provider.of<AuthenticationController>(context, listen: true);
    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        //resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Forgot password ?',
                      style:
                          Get.theme.textTheme.headline1.copyWith(fontSize: 30),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'enter your new password to change.'.capitalize,
                      style: Get.theme.textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FRTextField(
                      hintText:
                          'enter your new password to change.'.toLowerCase(),
                      onChanged: (res) {
                        password = res;
                      },
                    ),
                    SizedBox(height: 20.0),
                    FRButton(
                      onPressed: () async {
                        await authenticationController.changePassword(
                            username, password);
                      },
                      label: 'send'.toUpperCase(),
                    ),
                  ])),
        ),
      ),
    );
  }
}

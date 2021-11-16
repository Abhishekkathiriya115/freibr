import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FRPhoneTextField.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/register.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/authentication/step1.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller?.dispose();
    super.dispose();
  }

  var _formKey = GlobalKey<FormState>();
  bool alreadyExist = true;
  bool isChecking = false;
  @override
  Widget build(BuildContext context) {
    // final _authController = AuthenticationController.to;
    final RegisterController _controller =
        Provider.of<RegisterController>(context, listen: true);

    Future<bool> isExist(String param) async {
      var result = await _controller.isExistEmail(param);
      return result;
    }

    String _validator(String value) {
      if (value == null || value == '') {
        return 'email address is required.'.capitalize;
      }

      var isValidEmail = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value);
      if (!isValidEmail) {
        return 'enter a valid email address.'.capitalize;
      }
      // isExist(value);
      // return alreadyExist
      //     ? 'this email already taken. Please another one.'.capitalize
      //     : null;
      return null;
    }

    Widget buttonContainer(bool isEmail) {
      return Column(
        children: [
          FRButton(
            onPressed: () async {
              final isValid = _formKey.currentState.validate();
              if (!isValid) {
                showToast(message: "please correct all the errors.");
                return;
              }
              _formKey.currentState.save();
              showLoadingDialog();
              var isExistEmail = await isExist(_controller.registerUser.email);
              if (!isExistEmail) {
                Future.delayed(Duration(seconds: 1), () {
                  dismissDialogToast();
                  Get.to(() => Step1());
                });
              } else {
                showToast(message: "email already exist.");
              }
            },
            label: 'Next',
          )
        ],
      );
    }

    Widget emailAddressContainer() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emaill address',
            style: Get.theme.textTheme.bodyText1,
          ),
          SizedBox(
            height: 10.0,
          ),
          FRTextField(
            hintText: 'email address',
            validator: _validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (res) {
              // if (GetUtils.isPhoneNumber(res)) {
              //   _controller.registerUser.phone = res;
              // }
              // if (GetUtils.isEmail(res)) {}
              _controller.registerUser.email = res.toLowerCase();
              _controller.registerUser.username = res.toLowerCase();
            },
          ),
          SizedBox(height: 20.0),
          buttonContainer(true),
        ],
      );
    }

    Widget phoneContainer() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mobile No',
            style: Get.theme.textTheme.bodyText1,
          ),
          SizedBox(
            height: 10.0,
          ),
          FRPhoneTextField(
            phoneTextController: controller,
            onPhoneNumberChange:
                (phoneNumber, internationalizedPhoneNumber, isoCode) {
              _controller.registerUser.phone = phoneNumber;
              _controller.registerUser.username = phoneNumber;
            },
          ),
          SizedBox(height: 14.0),
          Text(
            'You may receive SMS updates from freibr and can out at any time.',
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.bodyText1.copyWith(),
          ),
          SizedBox(height: 20.0),
          buttonContainer(false),
        ],
      );
    }

    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
                // height: MediaQuery.of(context).size.height / 1.1,
                height: 90.h,
                margin: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 30, bottom: 0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Welcome,",
                          style: Get.theme.textTheme.headline1
                             ,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'sign up to get started',
                          style: Get.theme.textTheme.subtitle1
                             
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TabBar(
                          isScrollable: false,
                          // indicatorColor: lightBackgroundColor,
                          tabs: [
                            Tab(
                              child: Text(
                                'PHONE NUMBER',
                                style: Get.theme.textTheme.bodyText1
                                    .copyWith(fontSize: 9.sp),
                              ),
                            ),
                            Tab(
                              child: Text('EMAIL ADDRESS',
                                  style: Get.theme.textTheme.bodyText1
                                      .copyWith(fontSize: 9.sp)),
                            )
                          ],
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: TabBarView(
                            children: [
                              Container(
                                  child: Center(
                                child: phoneContainer(),
                              )),
                              Container(
                                  child:
                                      Center(child: emailAddressContainer())),
                            ],
                            controller: _tabController,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Center(
                              child: Column(
                            children: [
                              Text(
                                'By Continueing you agree Friber`s\nTerms and conditions',
                                textAlign: TextAlign.center,
                                style: Get.theme.textTheme.bodyText1
                                   
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Already have an account ?",
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
                                              .copyWith(color: Get.theme.primaryColor ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                        )
                      ]),
                )),
          ),
        ));
  }
}

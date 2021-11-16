import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/register.dart';
import 'package:freibr/util/util.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:sizer/sizer.dart';


class UploadProfile extends StatefulWidget {
  @override
  _UploadProfileState createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  PickedFile _image;
  var uuid = Uuid();
  String userCode;

  @override
  Widget build(BuildContext context) {
    final RegisterController _controller =
        Provider.of<RegisterController>(context, listen: true);
    if (userCode == null) {
      userCode = uuid.v1();
      _controller.registerUser.userCode = userCode;
    }
    void registerUser(PickedFile param) {
      if (param != null) {
        setState(() {
          _image = param;
        });
        showLoadingDialog();
        showToast(message: 'please do not press back button'.capitalizeFirst);
        if (!_controller.isLoading) {
          _controller
              .uploadProfileImage(File(_image.path), userCode)
              .then((_) async {
            dismissDialogToast();
            await _controller.saveUser();
          });
        }
      }
    }

    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            height: 80.h,
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    
                    Text(
                      'Upload a Profile \nimage',
                      style: Get.theme.textTheme.headline1
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 50.h,
                      
                      child: Center(
                        child: _image == null
                            ? Icon(
                                FontAwesome.user,
                                size: MediaQuery.of(context).size.width / 1.5,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(150),
                                child: Image.file(
                                  File(_image.path),
                                  width: 100.h,
                                  height:  100.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Get.theme.primaryColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5)),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    FRButton(
                      onPressed: () async {
                        if (!_controller.isLoading) {
                          Get.bottomSheet(Container(
                            color: Get.theme.primaryColorDark,
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                    leading: Icon(Icons.camera),
                                    title: Text(
                                      'CAMERA',
                                      style: Get.theme.textTheme.bodyText1
                                          .copyWith(),
                                    ),
                                    onTap: () async {
                                      PickedFile _file =
                                          await getImageFromPicker(
                                              ImageSource.camera);
                                      Get.back();
                                      registerUser(_file);
                                    }),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text('GALLERY',
                                      style: Get.theme.textTheme.bodyText1
                                          .copyWith()),
                                  onTap: () async {
                                    PickedFile _file = await getImageFromPicker(
                                        ImageSource.gallery);
                                    Get.back();
                                    registerUser(_file);
                                  },
                                ),
                              ],
                            ),
                          ));
                          // var _file = await getSingleImage();

                        }
                      },
                      label: 'choose photo'.capitalize
                    ),
                    SizedBox(height: 15.0),
                    Center(
                      child: GestureDetector(
                          child: Text(
                            'skip for now'.capitalize,
                            style: Get.theme.textTheme.bodyText1.copyWith(),
                          ),
                          onTap: () async {
                            if (!_controller.isLoading) {
                              // Get.to(Category());
                              await _controller.saveUser();
                            } else {
                              showToast(message: 'uploading image...');
                            }
                          }),
                    ),
                  ])),
        ),
      ),
    );
  }
}

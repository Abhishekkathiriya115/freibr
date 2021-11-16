import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRMultilieTextField.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:get/get.dart';

class SendFeedBack extends StatelessWidget {
  const SendFeedBack({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Send a feedback'),
            actions: [
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 6.0),
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: Get.textTheme.bodyText1.fontSize,
                          fontStyle: Get.textTheme.bodyText1.fontStyle,
                          fontFamily: Get.textTheme.bodyText1.fontFamily,
                          color: Get.theme.accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          ),
          body: Container(
            child: FRMultilineTextField(
              hintText: "feedback",
              initialValue: '',
              keyboardType: TextInputType.multiline,
              onChanged: (res) {},
            ),
          ),
        ));
  }
}

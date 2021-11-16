import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRMultilieTextField.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:get/get.dart';

class ReportProblem extends StatelessWidget {
  const ReportProblem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Report a Problem'),
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
              hintText: "Breifly explain what happened or what's not working",
              initialValue: '',
              keyboardType: TextInputType.multiline,
              onChanged: (res) {},
            ),
          ),
        ));
  }
}

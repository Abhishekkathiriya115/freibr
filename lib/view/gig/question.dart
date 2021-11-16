import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FRMultilieTextField.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/gig.dart';
import 'package:freibr/core/model/gig/faq.dart';
import 'package:freibr/util/styles.dart';
import 'package:freibr/view/gig/media.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class GigQuestion extends StatelessWidget {
  GigQuestion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Get.theme;
    GigController gigController = Provider.of(context);

    void showQuestionDialog(GigFaqModel param) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(17),
              // contentPadding: EdgeInsets.zero,
              scrollable: true,
              content: Container(
                width: Get.size.width,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Enter Title", style: Get.theme.textTheme.bodyText1),
                      SizedBox(
                        height: 10.0,
                      ),
                      FRTextField(
                        initialValue: param.title ?? "",
                        onChanged: (res) {
                          param.title = res;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text("Description", style: Get.theme.textTheme.bodyText1),
                      SizedBox(
                        height: 7.0,
                      ),
                      FRMultilineTextField(
                        hintText: "",
                        // textEditingController: profileController.bioTextController,
                        keyboardType: TextInputType.multiline,
                        onChanged: (res) {
                          param.description = res;
                        },
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancle', style: theme.textTheme.bodyText1),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  child: Text(
                    'Save',
                    style: theme.textTheme.bodyText1
                        .copyWith(color: theme.primaryColor),
                  ),
                  onPressed: () {
                    gigController.addGigQuestion(param);
                  },
                )
              ],
            );
          });
    }

    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Information from Buyers',
            style: theme.appBarTheme.titleTextStyle,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text(
                      'Add questions to help buyers provide you with exactly what you need to start working on their order.',
                      style: Get.theme.textTheme.bodyText1
                          .copyWith(fontSize: 12.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add Question", style: Get.theme.textTheme.bodyText1),
                    InkWell(
                        onTap: () {
                          showQuestionDialog(
                              new GigFaqModel(gigId: gigController.gig.id));
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.add,
                              size: 30,
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: fabButtonLinearGradient))),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                gigController.gig?.faqs != null
                    ? Column(
                        children: gigController.gig.gigAskedQuestions
                            ?.mapIndexed(
                              ((index, e) => Card(
                                    child: ExpansionTile(
                                      trailing: IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          gigController.removeQuestion(
                                              index, e);
                                        },
                                      ),
                                      title: Text(
                                        e.title,
                                        style: theme.textTheme.bodyText1,
                                      ),
                                      children: <Widget>[
                                        ListTile(
                                          title: Text(
                                            e.description,
                                            style: theme.textTheme.bodyText1,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            )
                            ?.toList())
                    : Container(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: gigController.gig.gigAskedQuestions.length > 0
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
                child: FRButton(
                  label: "Save & continue",
                  onPressed: () {
                    Get.to(() => GigMedia());
                  },
                ),
              )
            : Text(''),
      ),
    );
  }
}

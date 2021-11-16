import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FRMultilieTextField.dart';
import 'package:freibr/common/widget/FRSimpleChip.dart';
import 'package:freibr/common/widget/category/category.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/model/post/post_model.dart';
import 'package:freibr/view/post/timeline.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/common/widget/mediapicker/fr_multiselector_model.dart';
import 'package:freibr/core/controller/post.dart';

class UploadPostEdit extends StatelessWidget {
  final PostModel postModel;
  const UploadPostEdit({this.postModel, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostController postController =
        Provider.of<PostController>(context, listen: true);
    postController.post.description = postModel.description;
    postController.post.id = postModel.id;
    postController.post.title = postModel.title;
    TextEditingController textEditingController =
        TextEditingController(text: postModel.description);
    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Post',
              style: Get.theme.textTheme.subtitle1.copyWith(fontSize: 16.sp)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description",
                        style: Get.theme.textTheme.bodyText1
                            .copyWith(fontSize: 16.0)),
                    SizedBox(
                      height: 10.0,
                    ),
                    FRMultilineTextField(
                      hintText: "write a short description",
                      textEditingController: textEditingController,
                      keyboardType: TextInputType.multiline,
                      onChanged: (res) {
                        postController.post.description = res;
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text("Category", style: Get.theme.textTheme.bodyText1),
                    SizedBox(
                      height: 7.0,
                    ),
                    if (postModel.categories != null)
                      Consumer<PostController>(
                        builder: (context, controller, child) {
                          return Wrap(
                            spacing: 8.0,
                            children: controller.choosenCategories
                                .map((e) => FRSimpleChip(
                                      onDeleted: () {
                                        controller.removeChoosenCategory(e);
                                      },
                                      title: e?.name ?? "",
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    Flexible(
                      child: MaterialButton(
                        padding: EdgeInsets.all(0),
                        child: Text(
                          "select categories".capitalize,
                          style: Get.theme.textTheme.bodyText1
                              .copyWith(color: Get.theme.primaryColor),
                        ),
                        onPressed: () {
                          Get.to(FRCategoryPicker(
                            selectedCategories:
                                postController.choosenCategories,
                            onDone: (List<CategoryModel> categories) {
                              if (categories.length > 0) {
                                postController
                                    .addChoosenCategoriesBulk(categories);
                              }
                            },
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10.0),
          child: FRButton(
            label: "Upload",
            onPressed: () async {
              print(postController.post.id);
              await postController.uploadPostUpdate(postController.post);
            },
          ),
        ),
      ),
    );
  }
}

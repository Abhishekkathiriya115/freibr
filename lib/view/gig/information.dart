import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FRMultilieTextField.dart';
import 'package:freibr/common/widget/FRSimpleChip.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/category/category.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/gig.dart';
import 'package:freibr/core/model/category.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class GigInformation extends StatelessWidget {
  GigInformation({Key key, this.isEditMode = false}) : super(key: key);
  TextEditingController tagEditingController = new TextEditingController();
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Get.theme;
    GigController gigController = Provider.of(context);

    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Service', style: theme.textTheme.bodyText1),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title", style: theme.textTheme.bodyText1),
                SizedBox(
                  height: 7.0,
                ),
                FRTextField(
                  hintText: 'enter service title',
                  initialValue: gigController.gig.title,
                  onChanged: (res) {
                    gigController.gig.title = res;
                    gigController.setIsEdited(true);
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text("Categories", style: Get.theme.textTheme.bodyText1),
                SizedBox(
                  height: 7.0,
                ),
                gigController.choosenCategories != null
                    ? Wrap(
                        spacing: 8.0,
                        children: gigController.choosenCategories
                            .map((e) => FRSimpleChip(
                                  onDeleted: () {
                                    gigController.removeChoosenCategory(e);
                                  },
                                  title: e?.name ?? "",
                                ))
                            .toList(),
                      )
                    : Container(),
                MaterialButton(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "select categories".capitalize,
                    style: Get.theme.textTheme.bodyText1
                        .copyWith(color: theme.primaryColor),
                  ),
                  onPressed: () {
                    Get.to(() => FRCategoryPicker(
                          selectedCategories:
                              gigController.choosenCategories ?? [],
                          onDone: (List<CategoryModel> categories) {
                            if (categories.length > 0) {
                              gigController
                                  .addChoosenCategoriesBulk(categories);
                            }
                          },
                        ));
                  },
                ),
                Text("Tags", style: Get.theme.textTheme.bodyText1),
                SizedBox(
                  height: 7.0,
                ),
                FRTextField(
                    hintText: 'enter tag',
                    onChanged: (res) {},
                    textEditingController: tagEditingController,
                    onFieldSubmitted: (res) {
                      gigController.addNewTag(res);
                      gigController.setIsEdited(true);
                      tagEditingController.text = "";
                    }),
                Container(
                  width: Get.size.width,
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Text(
                    "5 tags minimum use numbers and letters only.",
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodyText1.copyWith(fontSize: 7.sp),
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  children: gigController.choosenTags
                      .map((e) => FRSimpleChip(
                            onDeleted: () {
                              gigController.removeTag(e);
                            },
                            title: e ?? "",
                          ))
                      .toList(),
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
                  initialValue: gigController.gig.description,
                  keyboardType: TextInputType.multiline,
                  onChanged: (res) {
                    gigController.gig.description = res;
                    gigController.setIsEdited(true);
                  },
                ),
                gigController.isEdited
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 20.0),
                        child: FRButton(
                          label: "Save & continue",
                          onPressed: () {
                            gigController.gig.gigCategoriesIds =
                                gigController.choosenCategories != null
                                    ? gigController.choosenCategories
                                        .map((e) => e.id)
                                        .join(',')
                                    : '';

                            gigController.gig.tags =
                                gigController.choosenTags.join(',');
                            gigController.modifyGigModel(gigController.gig);
                            isEditMode
                                ? gigController.editGig()
                                : gigController.saveGig();
                          },
                        ),
                      )
                    : Text('')
              ],
            ),
          ),
        ),
      ),
    );
  }
}

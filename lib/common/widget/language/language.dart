import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/language.dart';
import 'package:freibr/core/model/language.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class FRLanguagePicker extends StatelessWidget {
  FRLanguagePicker({Key key, this.onDone, this.selectedLanguages})
      : super(key: key);

  final Function(List<LanguageModel> languages) onDone;
  final List<LanguageModel> selectedLanguages;
  int pageSize = 20;
  String queryParam;
  Timer timeHandle;

  @override
  Widget build(BuildContext context) {
    void getLanguages(LanguageController controller, {bool isRefresh = false}) {
      controller.getPagedLanguages(
          controller.languagePagingController.page, pageSize, queryParam,
          isRefresh: isRefresh);
    }

    return ChangeNotifierProvider(
      create: (BuildContext context) => LanguageController(),
      child: Consumer<LanguageController>(
        builder: (context, controller, child) {
          return StatefulWrapper(
            onInit: () {
              Future.delayed(Duration.zero, () {
                if (selectedLanguages.length > 0) {
                  controller.addChoosenItemBulk(selectedLanguages);
                }
                getLanguages(controller, isRefresh: true);
              });
            },
            child: Scaffold(
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    FRTextField(
                      hintText: "search".capitalize,
                      borderRadius: 3,
                      height: 50,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {},
                      ),
                      onChanged: (res) {
                        if (timeHandle != null) {
                          timeHandle.cancel();
                        }
                        timeHandle = Timer(Duration(seconds: 1), () {
                          controller.languagePagingController.clearItems();
                          this.queryParam = res;
                          getLanguages(controller, isRefresh: true);
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Card(
                        child: SmartRefresher(
                          enablePullDown: false,
                          enablePullUp: true,
                          controller: controller
                              .languagePagingController.refreshController,
                          onLoading: () => getLanguages(controller),
                          child: !controller.languagePagingController.hasData &&
                                  !controller.isLoading
                              ? FREmptyScreen(
                                  imageSrc: noMessage,
                                  title: 'Nothing to show',
                                  onTap: () =>
                                      getLanguages(controller, isRefresh: true),
                                )
                              : controller.isLoading &&
                                      !controller
                                          .languagePagingController.hasData
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                      itemBuilder: (c, index) {
                                        var item = controller
                                            .languagePagingController
                                            .items[index];
                                        return CheckboxListTile(
                                          title: Text(
                                            item.name,
                                            style:
                                                Get.theme.textTheme.bodyText1,
                                          ),
                                          autofocus: false,
                                          activeColor: Get.theme.primaryColor,
                                          selected: controller
                                              .isExistChoosenItem(item),
                                          dense: true,
                                          value: controller
                                              .isExistChoosenItem(item),
                                          onChanged: (bool value) {
                                            value
                                                ? controller
                                                    .addChoosenItem(item)
                                                : controller
                                                    .removeChoosenItem(item);
                                          },
                                        );
                                      },
                                      itemCount: controller
                                          .languagePagingController
                                          .items
                                          .length,
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: controller.choosenLanguages.length > 0
                  ? Container(
                      margin: EdgeInsets.all(20.0),
                      child: FRButton(
                        label:
                            "Selected (${controller.choosenLanguages.length})",
                        onPressed: () {
                          this.onDone(controller.choosenLanguages);
                          Get.back();
                        },
                      ),
                    )
                  : Text(''),
            ),
          );
        },
      ),
    );
  }
}

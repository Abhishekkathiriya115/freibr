import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/category.dart';
import 'package:freibr/core/model/category.dart';
import 'package:freibr/util/styles.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/appbar/FRAppbar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class FRSubcategoryPicker extends StatelessWidget {
  FRSubcategoryPicker({Key key, this.category}) : super(key: key);
  final CategoryModel category;
  int pageSize = 20;
  String queryParam;
  Timer timeHandle;

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Provider.of(context);
    void getCategories(CategoryController controller,
        {bool isRefresh = false}) {
      controller.getSubcategories(controller.subCategoryPagingController.page,
          pageSize, category, queryParam,
          isRefresh: true);
    }

    return StatefulWrapper(
      onInit: () {
        Future.delayed(Duration.zero, () {
          controller.subCategoryPagingController.clearItems(clearItems: true);
          getCategories(controller, isRefresh: true);
        });
      },
      child: Scaffold(
        appBar: FRUserAppBar(
          showBtnBack: true,
          title: category.name,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: FRTextField(
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
                            controller.categoryPagingController.clearItems();
                            this.queryParam = res;
                            getCategories(controller, isRefresh: true);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: buttonLinearGradient,
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                        color: Get.theme.primaryColor,
                      ),
                      child: ClipOval(
                        child: getProgressiveImage(
                            category.avatar, category.avatar,
                            height: 90, width: 90),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: Get.theme.textTheme.bodyText1,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: true,
                  controller:
                      controller.subCategoryPagingController.refreshController,
                  onLoading: () => getCategories(controller),
                  child: !controller.subCategoryPagingController.hasData &&
                          !controller.isLoading
                      ? FREmptyScreen(
                          imageSrc: noMessage,
                          title: 'Nothing to show',
                          onTap: () =>
                              getCategories(controller, isRefresh: true),
                        )
                      : ListView.builder(
                          itemBuilder: (c, index) {
                            var item = controller
                                .subCategoryPagingController.items[index];
                            return CheckboxListTile(
                              title: Text(
                                item.name,
                                style: Get.theme.textTheme.bodyText1,
                              ),
                              autofocus: false,
                              activeColor: Get.theme.primaryColor,
                              selected: controller.isExistChoosenItem(item),
                              dense: true,
                              value: controller.isExistChoosenItem(item),
                              onChanged: (bool value) {
                                value
                                    ? controller.addChoosenItem(item)
                                    : controller.removeChoosenItem(item);
                              },
                            );
                          },
                          itemCount: controller
                              .subCategoryPagingController.items.length,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

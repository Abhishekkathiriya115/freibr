import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/category.dart';
import 'package:freibr/core/model/category.dart';
import 'package:freibr/util/styles.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:freibr/common/widget/category/subcategory.dart';

// ignore: must_be_immutable
class FRCategoryPicker extends StatelessWidget {
  FRCategoryPicker({Key key, this.onDone, this.selectedCategories})
      : super(key: key);

  final Function(List<CategoryModel> selecatedCategories) onDone;
  final List<CategoryModel> selectedCategories;
  int pageSize = 20;
  String queryParam;
  Timer timeHandle;

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Provider.of(context);
    void getCategories(CategoryController controller,
        {bool isRefresh = false}) {
      controller.getCategories(
          controller.categoryPagingController.page, pageSize, queryParam,
          isRefresh: true);
    }

    return StatefulWrapper(
        onInit: () {
          Future.delayed(Duration.zero, () {
            if (selectedCategories.length > 0) {
              controller.addChoosenItemBulk(selectedCategories);
            }
            controller.categoryPagingController.clearItems(clearItems: true);
            getCategories(controller, isRefresh: true);
          });
        },
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
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
                Text(
                  'Select the category you \nare looking for',
                  style: Get.theme.textTheme.headline1
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    controller:
                        controller.categoryPagingController.refreshController,
                    onLoading: () => getCategories(controller),
                    child: !controller.categoryPagingController.hasData &&
                            !controller.isLoading
                        ? FREmptyScreen(
                            imageSrc: noMessage,
                            title: 'Nothing to show',
                            onTap: () =>
                                getCategories(controller, isRefresh: true),
                          )
                        : controller.isLoading &&
                                !controller.categoryPagingController.hasData
                            ? Center(child: CircularProgressIndicator())
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  // crossAxisSpacing: 5.0,
                                  // mainAxisSpacing: 5.0,
                                ),
                                itemBuilder: (c, index) {
                                  if (controller.categoryPagingController.items
                                          .length >
                                      0) {
                                    var item = controller
                                        .categoryPagingController.items[index];

                                    return GestureDetector(
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                              // decoration: BoxDecoration(
                                              //   gradient: buttonLinearGradient,
                                              //   borderRadius: BorderRadius.all(
                                              //       Radius.circular(80)),
                                              //   color: Get.theme.primaryColor,
                                              // ),
                                              height: 90, width: 90,
                                              child: ClipOval(
                                                child: getProgressiveImage(
                                                    item.avatar, item.avatar,
                                                    height: 90, width: 90),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              child: Text(
                                                item.name,
                                                textAlign: TextAlign.center,
                                                style: Get
                                                    .theme.textTheme.bodyText1
                                                    .copyWith(fontSize: 14.0),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        print(item.name);
                                        Get.to(() => FRSubcategoryPicker(
                                              category: item,
                                            ));
                                      },
                                    );
                                  }

                                  return Container();
                                },
                                itemCount: controller
                                    .categoryPagingController.items.length,
                              ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: controller.choosenCategories.length > 0
              ? Container(
                  margin: EdgeInsets.all(20.0),
                  child: FRButton(
                    label: "Selected (${controller.choosenCategories.length})",
                    onPressed: () {
                      this.onDone(controller.choosenCategories);
                      Get.back();
                    },
                  ),
                )
              : Text(''),
        ));
  }
}

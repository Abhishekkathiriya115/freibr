import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/FRListTileButton.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/timeline/common/story_box.dart';
import 'package:freibr/view/timeline/profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class UserSearch extends StatelessWidget {
  UserSearch({Key key}) : super(key: key);
  int pageSize = 12;
  String queryParam;
  Timer timeHandle;

  @override
  Widget build(BuildContext context) {
    TimelineController controller = Provider.of(context);

    void getUserSearch({bool isRefresh = false}) {
      controller.getUserSearch(
          controller.userSearchController.page, pageSize, queryParam,
          isRefresh: isRefresh);
    }

    void getUserLiveSessions({bool isRefresh = false}) {
      controller.getUserSearchLiveSessions(
          controller.storiesSearchPagingController.page, pageSize, queryParam,
          isRefresh: isRefresh);
    }

    return StatefulWrapper(
      onInit: () {
        this.queryParam = "";
        // getUserSearch(isRefresh: true);

        Future.delayed(Duration.zero, () {
          // controller.storiesSearchPagingController.clearItems();
          // getUserLiveSessions();
        });
      },
      child: Scaffold(
          // appBar: FRUserAppBar(
          //   title: 'Freibr',
          // ),
          body: Container(
        height: 100.h,
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    controller.userSearchController.clearItems();
                    controller.storiesSearchPagingController.clearItems();
                    this.queryParam = res;
                    getUserSearch(isRefresh: true);

                    getUserLiveSessions(isRefresh: true);
                  });
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 5.sp,
                    vertical: controller.storiesSearchPagingController.hasData
                        ? 20.sp
                        : 0),
                height: controller.storiesSearchPagingController.hasData &&
                        !controller.isLoading
                    ? 21.h
                    : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Suggested Chatrooms",
                      style: Get.textTheme.headline1.copyWith(fontSize: 11.sp),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: CustomHeader(
                          height: 0,
                          builder: (BuildContext context, RefreshStatus mode) {
                            return Container();
                          },
                        ),
                        controller: controller
                            .storiesSearchPagingController.refreshController,
                        footer: CustomFooter(
                          builder: (BuildContext context, LoadStatus mode) {
                            Widget body;
                            if (mode == LoadStatus.idle) {
                              body = Text("pull up load");
                            } else if (mode == LoadStatus.loading) {
                              body = frCircularLoader(height: 30, width: 30);
                            } else if (mode == LoadStatus.failed) {
                              body = Text("Load Failed!Click retry!");
                            } else if (mode == LoadStatus.canLoading) {
                              body = Text("release to load more");
                            } else {
                              body = Container();
                            }
                            return Container(
                              height: mode == LoadStatus.noMore ? 0 : 55,
                              child: Center(child: body),
                            );
                          },
                        ),
                        onRefresh: () {},
                        onLoading: () {
                          getUserLiveSessions();
                        },
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(0.0),
                          itemBuilder: (c, index) {
                            return Container(
                                child: TimelineStoryBox(
                                    user: controller
                                        .storiesSearchPagingController
                                        .items[index]));
                          },
                          // itemExtent: 100.0,
                          itemCount: controller
                              .storiesSearchPagingController.items.length,
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 15),
            Text(
              "Suggested Profiles",
              style: Get.textTheme.headline1.copyWith(fontSize: 11.sp),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: CustomHeader(
                  height: 20,
                  builder: (BuildContext context, RefreshStatus mode) {
                    return Container(
                      height: 0,
                      child: Center(
                        child: Text("Loading.."),
                      ),
                    );
                  },
                ),
                controller: controller.userSearchController.refreshController,
                onRefresh: () {
                  controller.userSearchController.clearItems();
                  getUserSearch(isRefresh: true);

                  controller.storiesSearchPagingController.clearItems();
                  getUserLiveSessions(isRefresh: true);
                },
                onLoading: () {
                  getUserSearch();
                },
                child: !controller.userSearchController.hasData &&
                        !controller.isLoading
                    ? FREmptyScreen(
                        imageSrc: noMessage,
                        title: 'Nothing to show',
                        onTap: () {
                          getUserSearch(isRefresh: true);
                          getUserLiveSessions(isRefresh: true);
                        },
                      )
                    : controller.isLoading &&
                            !controller.userSearchController.hasData
                        ? Center(child: frCircularLoader())
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    Divider(height: 25),
                            itemBuilder: (c, index) {
                              if (controller.userSearchController.items.length >
                                  0) {
                                var item = controller
                                    .userSearchController.items[index];
                                return FRListTileButton(
                                    onAvatarTap: () {
                                      Get.to(() => Profile(
                                            user: item,
                                          ));
                                    },
                                    onButtonTap: () async {
                                      if (item.follow != 'requested' &&
                                          item.follow != "following") {}
                                      var result = await controller.setFollower(
                                          item, index);
                                      controller.userSearchController
                                          .items[index] = result;
                                    },
                                    user: item);
                              }
                              return Container();
                            },
                            itemCount:
                                controller.userSearchController.items.length,
                          ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

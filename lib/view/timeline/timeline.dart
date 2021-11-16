import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/timeline/common/story_box.dart';
import 'package:freibr/view/timeline/common/timeline_feed.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:freibr/view/appbar/FRAppbar.dart';

// ignore: must_be_immutable
class Timeline extends StatelessWidget {
  Timeline({Key key}) : super(key: key);
  int pageSize = 3;

  @override
  Widget build(BuildContext context) {
    TimelineController controller = Provider.of<TimelineController>(context);

    void getFeedList({bool isRefresh = false}) {
      controller.getTimelineUsers(
          controller.postsPagingController.page, pageSize,
          isRefresh: true);
    }

    void getStories() {
      controller.getTimelineLiveUsers(
          controller.storiesPagingController.page, pageSize,
          isRefresh: true);
    }

    return StatefulWrapper(
      onInit: () {
        getFeedList();
        getStories();
      },
      child: Scaffold(
        appBar: FRUserAppBar(
          title: 'Freibr',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 15.sp,
                    vertical:
                        controller.storiesPagingController.hasData ? 10.sp : 0),
                height: controller.storiesPagingController.hasData &&
                        !controller.isLoading
                    ? 17.h
                    : 0,
                // height: 0,
                child: Container(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: CustomHeader(
                      height: 0,
                      builder: (BuildContext context, RefreshStatus mode) {
                        return Container();
                      },
                    ),
                    controller:
                        controller.storiesPagingController.refreshController,
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
                    onRefresh: () {
                      controller.storiesPagingController.clearItems();

                      controller.getTimelineLiveUsers(
                          controller.storiesPagingController.page, pageSize,
                          isRefresh: true);
                    },
                    onLoading: () {
                      controller.getTimelineLiveUsers(
                          controller.storiesPagingController.page, pageSize);
                    },
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (c, index) {
                        if (controller.storiesPagingController.items[index]
                                .following !=
                            null) {
                          return Container(
                              child: TimelineStoryBox(
                                  user: controller.storiesPagingController
                                      .items[index].following));
                        }

                        return Container();
                      },
                      // itemExtent: 100.0,
                      itemCount:
                          controller.storiesPagingController.items.length,
                    ),
                  ),
                )),
            controller.storiesPagingController.hasData
                ? Column(
                    children: [
                      Divider(
                        height: 2.sp,
                        thickness: 0.8.sp,
                      ),
                      SizedBox(height: 5),
                    ],
                  )
                : Container(),
            controller.hasFollowing
                ? Container()
                : Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      "Suggested Profiles",
                      style: Get.textTheme.headline1.copyWith(fontSize: 11.sp),
                    )),
            Expanded(
                child: Container(
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
                controller: controller.postsPagingController.refreshController,
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
                      body = Text("");
                    }
                    return Container(
                      height: mode == LoadStatus.noMore ? 0 : 55,
                      child: Center(child: body),
                    );
                  },
                ),
                onRefresh: () {
                  controller.postsPagingController.clearItems();
                  getFeedList(isRefresh: true);

                  controller.storiesPagingController.clearItems();
                  getStories();
                },
                onLoading: () {
                  getFeedList();
                },
                child: !controller.postsPagingController.hasData &&
                        !controller.isLoading
                    ? FREmptyScreen(
                        imageSrc: noMessageTimeline,
                        title: 'Nothing to show',
                        onTap: () {
                          getFeedList(isRefresh: true);
                        },
                      )
                    : controller.isLoading &&
                            !controller.postsPagingController.hasData
                        ? Center(child: frCircularLoader())
                        : ListView.builder(
                            itemBuilder: (c, index) {
                              return TimelineFeed(
                                  user: controller
                                      .postsPagingController.items[index]);
                            },
                            // itemExtent: 100.0,
                            itemCount:
                                controller.postsPagingController.items.length,
                          ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/util/util.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:freibr/view/timeline/common/timeline_feed.dart';

// ignore: must_be_immutable
class TimelineFeedList extends StatelessWidget {
  TimelineFeedList({Key key}) : super(key: key);
  int pageSize = 8;
  @override
  Widget build(BuildContext context) {
    TimelineController controller = Provider.of(context);

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

    return Container(
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
              body = frCircularLoader(height: 20, width: 20);
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
                imageSrc: noMessage,
                title: 'Nothing to show',
                onTap: () {
                  getFeedList(isRefresh: true);
                },
              )
            : controller.isLoading && !controller.postsPagingController.hasData
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemBuilder: (c, index) {
                      return TimelineFeed(
                          user: controller
                              .postsPagingController.items[index]);
                    },
                    // itemExtent: 100.0,
                    itemCount: controller.postsPagingController.items.length,
                  ),
      ),
    );
  }
}

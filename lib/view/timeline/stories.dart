import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/util/util.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:freibr/view/timeline/common/story_box.dart';

// ignore: must_be_immutable
class Stories extends StatelessWidget {
  Stories({Key key}) : super(key: key);
  int pageSize = 8;
  @override
  Widget build(BuildContext context) {
    TimelineController controller = Provider.of(context);
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: CustomHeader(
          height: 0,
          builder: (BuildContext context, RefreshStatus mode) {
            return Container();
          },
        ),
        controller: controller.storiesPagingController.refreshController,
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
            return Container(
                child: TimelineStoryBox(
                    user: controller
                        .storiesPagingController.items[index].following));
          },
          // itemExtent: 100.0,
          itemCount: controller.storiesPagingController.items.length,
        ),
      ),
    );
  }
}

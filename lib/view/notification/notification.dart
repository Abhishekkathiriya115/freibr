import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freibr/common/widget/FRListTileButtonNotification.dart';
import 'package:freibr/common/widget/FRUserListTile.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/config/url.dart';
import 'package:freibr/core/controller/notification.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/appbar/FRAppbar.dart';
import 'package:freibr/view/chat/join.dart';
import 'package:freibr/view/timeline/profile/profile.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class NotificationView extends StatelessWidget {
  NotificationView({Key key}) : super(key: key);
  int pageSize = 10;
  @override
  Widget build(BuildContext context) {
    NotificationController controller = Provider.of(context);

    void getNotifications({bool isRefresh = false}) {
      controller.getPagedNotifications(
          controller.notificationsPagingController.page, pageSize,
          isRefresh: true);
    }

    return StatefulWrapper(
      onInit: () {
        controller.notificationsPagingController.clearItems(clearItems: true);
        getNotifications(isRefresh: true);
      },
      child: Scaffold(
          appBar: FRUserAppBar(
            title: 'Notifications',
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () async {
                controller.notificationsPagingController
                    .clearItems(clearItems: true);
                await controller.getPagedNotifications(
                    controller.notificationsPagingController.page, pageSize,
                    isRefresh: true);
                controller.notificationsPagingController.refreshController
                    .refreshCompleted();
              },
              controller:
                  controller.notificationsPagingController.refreshController,
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
              onLoading: () {
                getNotifications();
              },
              child: controller.notificationsPagingController.items.length == 0
                  ? Center(
                      child: Container(
                        height: 60.h,
                        width: 60.w,
                        child: Image.asset('assets/images/no_notification.png'),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (c, index) {
                        if (controller
                                .notificationsPagingController.items.length >
                            0) {
                          var item = controller
                              .notificationsPagingController.items[index];
                          return item.messageType == 'follow'
                              ? FRListTileButtonNotification(
                                  onSuccessTap: () {
                                    Provider.of<TimelineController>(context,
                                            listen: false)
                                        .followApproveReject(
                                            item.follower, 'following');
                                    controller.updateNotification(
                                        index, 'following');
                                  },
                                  onCancleTap: () {
                                    Provider.of<TimelineController>(context,
                                            listen: false)
                                        .followApproveReject(
                                            item.follower, 'rejected');

                                    controller.removeNotification(index);
                                  },
                                  onAvatarTap: () {
                                    Get.to(() => Profile(
                                          user: item.fromUser,
                                        ));
                                  },
                                  model: item)
                              : FRUserListTile(
                                  onTap: () async {
                                    if (item.messageType == 'live') {
                                      bool isLive =
                                          await Provider.of<TimelineController>(
                                                  context,
                                                  listen: false)
                                              .checkIsLive(item.fromUser);

                                      if (isLive) {
                                        var authUser =
                                            Provider.of<TimelineController>(
                                                    context,
                                                    listen: false)
                                                .authController
                                                .authUser;
                                        String conferenceUrl = UrlDto
                                                .conferenceUrl +
                                            "/?room=${item.fromUser.id}&name=${authUser.name}&user=${authUser.id}&avatar=${authUser.avatar}";
                                        print("conference url is ");
                                        print(conferenceUrl);

                                        Get.to(() => JoinConference(
                                              conferenceUrl: conferenceUrl,
                                              host: item.fromUser,
                                            ));
                                      } else {
                                        showToast(
                                            message: item.fromUser.name +
                                                " is not live.",
                                            position: EasyLoadingToastPosition
                                                .center);
                                      }
                                    } else {
                                      Get.to(() => Profile(
                                            user: item.fromUser,
                                          ));
                                    }
                                  },
                                  subtitle: item.message,
                                  user: item.fromUser);
                        }
                        return Container();
                      },
                      // itemExtent: 100.0,
                      itemCount:
                          controller.notificationsPagingController.items.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                    ),
            ),
          )),
    );
  }
}

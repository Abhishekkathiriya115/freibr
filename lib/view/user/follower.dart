import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FRListTileButton.dart';
import 'package:get/get.dart';
import 'package:freibr/view/timeline/profile/profile.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/view/appbar/FRAppbar.dart';
import '../../core/controller/authentication.dart';

class Follower extends StatelessWidget {
  const Follower({Key key, this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    TimelineController controller = Provider.of(context);
    int pageSize = 12;
    void getFollowers({bool isRefresh = false}) {
      controller.getPagedFollowers(
          controller.followPagingController.page, pageSize, user.id.toString(),
          isRefresh: isRefresh);
    }

    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: FRUserAppBar(
          title: 'Followers',
          showBtnBack: true,
        ),
        body: Container(
          height: 100.h,
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: CustomHeader(
              height: 20,
              builder: (BuildContext context, RefreshStatus mode) {
                return Container(
                  height: 40,
                  child: Center(
                    child: Text("Loading.."),
                  ),
                );
              },
            ),
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
            controller: controller.followPagingController.refreshController,
            onRefresh: () {
              print("calling followers list");
              controller.followPagingController.clearItems();
              getFollowers(isRefresh: true);
            },
            onLoading: () {
              getFollowers();
            },
            child: !controller.followPagingController.hasData &&
                    !controller.isLoading
                ? FREmptyScreen(
                    imageSrc: noMessage,
                    title: 'Nothing to show',
                    onTap: () {
                      getFollowers(isRefresh: true);
                    },
                  )
                : controller.isLoading &&
                        !controller.followPagingController.hasData
                    ? Center(child: frCircularLoader())
                    : ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 25),
                        itemBuilder: (c, index) {
                          if (controller.followPagingController.items.length >
                              0) {
                            var item =
                                controller.followPagingController.items[index];

                            return item.follower != null &&
                                    item.follower.id !=
                                        Provider.of<AuthenticationController>(
                                                context,
                                                listen: false)
                                            .authUser
                                            .id
                                ? FRListTileButton(
                                    onAvatarTap: () {
                                      Get.to(() => Profile(
                                            user: item.follower,
                                          ));
                                    },
                                    onButtonTap: () async {
                                      if (item.follower.follow != 'requested' &&
                                          item.follower.follow !=
                                              "following") {}
                                      var result = await controller.setFollower(
                                          item.follower, index);

                                      controller.followPagingController
                                          .items[index].follower = result;
                                    },
                                    user: item.follower)
                                : Container();
                          }
                          return Container();
                        },
                        itemCount:
                            controller.followPagingController.items.length,
                      ),
          ),
        ),
      ),
    );
  }
}

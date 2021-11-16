import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/profile.dart';
import 'package:freibr/common/widget/FRProfileGrid.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/bottom.dart';
import 'package:freibr/view/chat/common/single.dart';
import 'package:freibr/view/chat/join.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:freibr/util/extension.dart';
import 'package:freibr/view/post/timeline.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/common/widget/profile/FRProfileIntroduction.dart';
import 'package:freibr/view/profile/view.dart';
import 'package:freibr/config/url.dart';

class Profile extends StatelessWidget {
  Profile({Key key, this.user, this.isRedirect = false, this.userId})
      : super(key: key);
  final UserModel user;
  final String userId;
  final bool isRedirect;

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Provider.of(context);
    double paddingDivider = user?.bio.toString().isNullOrEmpty() ? 3.0 : 3.7;
    final double itemHeight =
        (Get.size.height - kToolbarHeight - 24) / paddingDivider;
    final double itemWidth = Get.size.width / 2;

    return StatefulWrapper(
        onInit: () {
          if (this.isRedirect) {
            Future.microtask(
                () => controller.getOtherUserProfile(this.userId.toString()));
          } else {
            Future.delayed(Duration.zero, () {
              controller.setProfileUser(user, isMe: true);
              controller.getOtherUserProfile(user.id.toString());
            });
          }
        },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back), onPressed: () => Get.back()),
              title: Text('Profile',
                  style:
                      Get.theme.textTheme.bodyText1.copyWith(fontSize: 15.sp)),
            ),
            body: (user != null || this.isRedirect) &&
                    !controller
                        .isLoadingProfile //user != null && !controller.isLoadingProfile
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            child: FRProfileIntroduction(
                          user: controller.user,
                          onTapChat: () {
                            Get.to(() => SingleChat(
                                  user: controller.user,
                                ));
                          },
                          onTapFollow: () async {
                            if (controller.user.follow != 'requested' &&
                                controller.user.follow != "following") {}
                            await Provider.of<TimelineController>(context,
                                    listen: false)
                                .setFollowerWithoutIndex(controller.user,
                                    callback: (res) {
                              controller.setProfileUser(res, isMe: true);
                            });
                          },
                        )),
                        Container(
                          // height: 51.h,
                          child: FRProfileGrid(
                            childAspectRatio: (itemWidth / itemHeight),
                            user: user,
                            onAboutTap: () {
                              Get.to(() => ViewProfile());
                            },
                            onFeedbackTap: () {
                              print("feedback clicked");
                            },
                            onPostTap: () {
                              Get.to(() => PostTimeline(
                                    user: user,
                                  ));
                            },
                            onRoomTap: () async {
                              bool isLive =
                                  await Provider.of<TimelineController>(context,
                                          listen: false)
                                      .checkIsLive(user);

                              if (isLive) {
                                var authUser = Provider.of<TimelineController>(
                                        context,
                                        listen: false)
                                    .authController
                                    .authUser;

                                String conferenceUrl = UrlDto.conferenceUrl +
                                    "/?room=${user.id}&name=${authUser.name}&user=${authUser.id}&avatar=${authUser.avatar}";
                                print("conference url is ");
                                print(conferenceUrl);

                                // Get.to(() => Conference(
                                //       conferenceUrl: conferenceUrl,
                                //     ));
                                Get.to(() => JoinConference(
                                      conferenceUrl: conferenceUrl,
                                      host: user,
                                    ));
                              } else {
                                showToast(
                                    message: user.name + " is not live.",
                                    position: EasyLoadingToastPosition.center);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : Center(child: frCircularLoader()),
            bottomNavigationBar: FRBottomNavigation(
              isPageRoute: true,
            )));
  }
}

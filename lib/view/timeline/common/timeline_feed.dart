import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freibr/common/widget/FRUserListTile.dart';
import 'package:freibr/core/controller/settings/restricted_accounts.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/common/widget/FRProfileGrid.dart';
import 'package:freibr/core/service/share_app.dart';
import 'package:freibr/view/chat/join.dart';
import 'package:freibr/view/post/timeline.dart';
import 'package:freibr/view/timeline/profile/profile.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/config/url.dart';

class TimelineFeed extends StatelessWidget {
  const TimelineFeed({Key key, this.user}) : super(key: key);
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    RestrictedAccountController controller =
        Provider.of<RestrictedAccountController>(context);
    ThemeData theme = Get.theme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      height: 495,
      child: Column(
        children: [
          FRUserListTile(
            user: user,
            onTrailingTap: () {
              Get.bottomSheet(
                  Wrap(
                    children: <Widget>[
                      ListTile(
                        title: Text('BLOCK',
                            style: Get.theme.textTheme.bodyText1
                                .copyWith(fontSize: 14.0)),
                        onTap: () async {
                          controller.blockUser(user.id);
                        },
                      ),
                      ListTile(
                          title: Text(
                            user.follow == null &&
                                    user.follow != 'requested' &&
                                    user.follow != "following"
                                ? 'Follow'
                                : user.follow.toUpperCase(),
                            style: Get.theme.textTheme.bodyText1
                                .copyWith(fontSize: 14.0),
                          ),
                          onTap: () async {
                            controller.setFollow(user.id.toString(),
                                isUNFollow: user.follow == "following");
                          }),
                      ListTile(
                        title: Text('SHARE TO...',
                            style: Get.theme.textTheme.bodyText1
                                .copyWith(fontSize: 14.0)),
                        onTap: () async {
                          ShareAPP.shareProfile(
                              ShareAPP.buildProfileShareUrl(user.id));
                        },
                      ),
                      ListTile(
                        title: Text('REPORT...',
                            style: Get.theme.textTheme.bodyText1
                                .copyWith(fontSize: 14.0)),
                        onTap: () async {},
                      ),
                    ],
                  ),
                  backgroundColor: theme.scaffoldBackgroundColor);
            },
            onTap: () {
              Get.to(() => Profile(
                    user: user,
                  ));
            },
          ),
          Expanded(
              child: FRProfileGrid(
            user: user,
            onAboutTap: () {
              Get.to(() => Profile(
                    user: user,
                  ));
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
                  await Provider.of<TimelineController>(context, listen: false)
                      .checkIsLive(user);

              if (isLive) {
                var authUser =
                    Provider.of<TimelineController>(context, listen: false)
                        .authController
                        .authUser;
                String conferenceUrl = UrlDto.conferenceUrl +
                    "/?room=${user.id}&name=${authUser.name}&user=${authUser.id}&avatar=${authUser.avatar}";
                print('------------------->>$conferenceUrl');
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
          )),
          SizedBox(height: 8),
          Divider(
            thickness: 0.5,
          )
        ],
      ),
    );
  }
}

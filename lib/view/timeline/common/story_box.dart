import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/config/url.dart';
import 'package:freibr/view/chat/join.dart';

class TimelineStoryBox extends StatelessWidget {
  const TimelineStoryBox({Key key, this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool isLive =
            await Provider.of<TimelineController>(context, listen: false)
                .checkIsLive(user);

        if (isLive) {
          var authUser = Provider.of<TimelineController>(context, listen: false)
              .authController
              .authUser;
          String conferenceUrl = UrlDto.conferenceUrl +
              "/?room=${user.id}&name=${authUser.name}&user=${authUser.id}&avatar=${authUser.avatar}";
          print("conference url is ");
          print(conferenceUrl);

          Get.to(() => JoinConference(
                conferenceUrl: conferenceUrl,
                host: user,
              ));

          // Get.to(() => Conference(
          //       conferenceUrl: conferenceUrl,
          //     ));
        } else {
          showToast(
              message: user.name + " is not live.",
              position: EasyLoadingToastPosition.center);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(1),
              width: 20.h,
              height: 13.h,
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: user.thumbnailAvatar != null
                          ? getProgressiveImage(
                              user.thumbnailAvatar,
                              user.avatar,
                              width: 20.h,
                              height: 13.h,
                            )
                          : getProgressiveNoUserAvatar(
                              width: 20.h, height: 13.h)),
                  Container(
                      width: 20.h,
                      height: 13.h,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColorDark.withOpacity(0.7),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          'Followers: ' + user.totalFollower.toString(),
                          style: Get.theme.textTheme.bodyText1
                              .copyWith(fontSize: 10.sp),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: 20.h,
              child: Text(
                user.name,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 9.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}

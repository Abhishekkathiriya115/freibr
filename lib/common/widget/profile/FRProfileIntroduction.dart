import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/icons.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/service/share_app.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/authentication/settings.dart';
import 'package:freibr/view/profile/edit.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/view/user/follower.dart';
import 'package:freibr/view/user/following.dart';

// ignore: must_be_immutable
class FRProfileIntroduction extends StatelessWidget {
  FRProfileIntroduction(
      {Key key,
      this.user,
      this.onTapFollow,
      this.onTapChat,
      this.isSettingClickable = false})
      : super(key: key);
  final UserModel user;
  final VoidCallback onTapFollow;
  final VoidCallback onTapChat;
  final bool isSettingClickable;

  @override
  Widget build(BuildContext context) {
    var theme = Get.theme;
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Container(
                  width: 60,
                  height: 60,
                  child: Icon(
                      isSettingClickable ? FontAwesome.cogs : FontAwesome.share,
                      size: 4.h,
                      color: theme.primaryColor),
                ),
                onTap: () {
                  if (isSettingClickable)
                    Get.to(Settings());
                  else
                    ShareAPP.shareProfile(
                        ShareAPP.buildProfileShareUrl(user.id));
                },
              ),
              Container(width: 10),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: theme.primaryColor,
                    child: CircleAvatar(
                      radius: 49,
                      child: ClipOval(
                        child: user != null
                            ? getProgressiveImage(
                                user?.thumbnailAvatar,
                                user?.avatar,
                                height: 15.h,
                                width: 30.w,
                              )
                            : getProgressiveNoUserAvatar(
                                height: 15.h, width: 30.w),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isSettingClickable,
                    child: Positioned(
                      bottom: 0,
                      right: 0,
                      child: ClipOval(
                        child: Container(
                          color: theme.primaryColor,
                          padding: EdgeInsets.all(8.5),
                          child: InkWell(
                              onTap: () {
                                Get.to(() => EditProfile());
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(width: 10),
              InkWell(
                onTap: onTapChat,
                child: Container(
                  width: 60,
                  height: 60,
                  child: Icon(Icons.chat, size: 4.h, color: theme.primaryColor),
                ),
              )
            ],
          ),
          Container(height: 10),
          Text(user?.name ?? "no name",
              style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 12.sp)),
          // Container(height: 3),
          Text(user?.profileName ?? "no profile name",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyText1.copyWith()),
          Container(height: 3),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => Get.to(() => Follower(
                        user: user,
                      )),
                  child: Column(
                    children: <Widget>[
                      Text(user.totalFollower.toString(),
                          style: theme.textTheme.bodyText1.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold)),
                      Container(height: 5),
                      Text("Follower", style: theme.textTheme.bodyText1)
                    ],
                  ),
                ),
              ),
              onTapFollow != null
                  ? Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(top: 18),
                        child: FRButton(
                            borderRadius: 100,
                            btnHeight: 5.h,
                            fontWeight: FontWeight.w600,
                            btnColor: theme.primaryColor,
                            gradientButton: true,
                            fontSize: 8.sp,
                            onPressed: onTapFollow,
                            label: user.follow == null &&
                                    user.follow != 'requested' &&
                                    user.follow != "following"
                                ? 'Follow'
                                : user.follow.capitalize),
                      ),
                    )
                  : Container(),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => Get.to(() => Following(
                        user: user,
                      )),
                  child: Column(
                    children: <Widget>[
                      Text(user.totalFollowing.toString(),
                          style: theme.textTheme.bodyText1.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold)),
                      Container(height: 5),
                      Text("Following", style: theme.textTheme.bodyText1)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(),
          ),
          Container(
            height: 45,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(user?.bio ?? "no bio mentioned",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: theme.textTheme.bodyText1.copyWith(fontSize: 9.sp)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(),
          ),
        ],
      ),
    );
  }
}

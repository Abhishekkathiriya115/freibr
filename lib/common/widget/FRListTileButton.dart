import 'package:flutter/material.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/util/extension.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class FRListTileButton extends StatelessWidget {
  FRListTileButton({Key key, this.user, this.onAvatarTap, this.onButtonTap})
      : super(key: key);
  UserModel user;
  final VoidCallback onAvatarTap;
  final VoidCallback onButtonTap;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Get.theme;
    return InkWell(
      onTap: onAvatarTap,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipOval(
                child: user.thumbnailAvatar != null
                    ? getProgressiveImage(
                        user.thumbnailAvatar,
                        user.avatar,
                        width: 50,
                        height: 50,
                      )
                    : getProgressiveNoUserAvatar(width: 50, height: 50)),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: user.name,
                          style: theme.textTheme.subtitle1?.copyWith(
                              fontSize: 10.sp, fontWeight: FontWeight.bold)),
                      !user.profileName.isNullOrEmpty()
                          ? TextSpan(
                              text: " " + user.profileName,
                              style: theme.textTheme.subtitle1
                                  .copyWith(fontSize: 10.sp))
                          : TextSpan(),
                    ])))),
            Container(
              width: 40.w,
              child: OutlinedButton(
                onPressed: onButtonTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    user.follow != null
                        ? Icon(Icons.check_circle)
                        : Container(),
                    SizedBox(
                      width: user.follow != null ? 10 : 0,
                    ),
                    Text(
                      user.follow == null &&
                              user.follow != 'requested' &&
                              user.follow != "following"
                          ? 'Follow'
                          : user.follow,
                      style: Get.theme.textTheme.bodyText1,
                    )
                  ],
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(width: 1.8)))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

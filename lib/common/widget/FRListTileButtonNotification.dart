import 'package:flutter/material.dart';
import 'package:freibr/core/model/notification_model.dart';
import 'package:freibr/util/util.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class FRListTileButtonNotification extends StatelessWidget {
  FRListTileButtonNotification({
    Key key,
    this.model,
    this.onAvatarTap,
    this.onSuccessTap,
    this.onCancleTap,
  }) : super(key: key);
  NotificationModel model;
  final VoidCallback onAvatarTap;
  final VoidCallback onSuccessTap;
  final VoidCallback onCancleTap;

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
                child: model.fromUser.thumbnailAvatar != null
                    ? getProgressiveImage(
                        model.fromUser.thumbnailAvatar,
                        model.fromUser.avatar,
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
                        text: model.message,
                        style: theme.textTheme.subtitle1
                            .copyWith(fontSize: 12.sp)),
                  ]))),
            ),
            model == null && model.follower.status == 'following'
                ? Container()
                : Container(
                    width: 25.w,
                    child: Row(
                      children: [
                        onSuccessTap != null
                            ? IconButton(
                                icon: Icon(Icons.check_circle),
                                onPressed: onSuccessTap,
                                iconSize: 24.sp,
                              )
                            : Container(),
                        onCancleTap != null
                            ? IconButton(
                                icon: Icon(Icons.cancel_outlined),
                                onPressed: onCancleTap,
                                iconSize: 25.sp,
                              )
                            : Container(),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

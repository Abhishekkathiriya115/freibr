import 'package:flutter/material.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

Widget alertBubble(flag,
    {double left,
    double right,
    double top,
    double bottom,
    Color color = Colors.orange}) {
  return flag
      ? Positioned(
          top: top,
          right: right,
          left: left,
          bottom: bottom,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        )
      : Container();
}

Widget createDrawerBodyItem(
    {IconData icon,
    String text,
    GestureTapCallback onTap,
    isShowBubble = false}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Stack(
          children: [
            Icon(
              icon,
              size: isShowBubble ? 15.0 : 18.0,
            ),
            alertBubble(isShowBubble, left: -1),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text, style: Get.theme.textTheme.bodyText1),
        ),
      ],
    ),
    onTap: onTap,
  );
}

Widget createDrawerHeader(UserModel user) {
  return user != null
      ? DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: Stack(children: <Widget>[
            user != null
                ? getProgressiveImage(
                    user.thumbnailAvatar,
                    user.avatar,
                    width: 100.h,
                    height: 100.h,
                  )
                : getProgressiveNoUserAvatar(width: 100.h, height: 100.h),
            Container(
              color: Get.theme.primaryColorDark.withOpacity(0.7),
            ),
            Positioned(
                bottom: 12.0,
                left: 16.0,
                child: Text(user.name, style: Get.theme.textTheme.headline1)),
          ]))
      : Container();
}

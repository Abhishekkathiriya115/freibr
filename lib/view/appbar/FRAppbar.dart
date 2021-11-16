import 'package:flutter/material.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/view/profile/profile.dart';

class FRUserAppBar extends PreferredSize {
  final String title;
  FRUserAppBar(
      {Key key,
      this.title,
      this.child,
      this.height = 70,
      this.showBtnBack = false,
      this.fontSize});
  final Widget child;
  final double height;
  final bool showBtnBack;
  double fontSize = 18.sp;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return child ??
        Container(
          height: preferredSize.height,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Get.theme.primaryColorLight.withOpacity(0.0),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  showBtnBack
                      ? IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Get.back(),
                        )
                      : Container(),
                  Text(
                    title,
                    style: Get.theme.textTheme.subtitle1
                        .copyWith(fontSize: fontSize),
                  ),
                ],
              ),
              Container(
                  child: InkWell(
                onTap: () {
                  Get.to(() => Profile(
                        isSettingClickable: true,
                      ));
                },
                child: ClipOval(
                  child: Provider.of<AuthenticationController>(context)
                              .authUser
                              ?.thumbnailAvatar !=
                          null
                      ? getProgressiveImage(
                          Provider.of<AuthenticationController>(context)
                              .authUser
                              ?.thumbnailAvatar,
                          Provider.of<AuthenticationController>(context)
                              .authUser
                              ?.avatar,
                          width: 50,
                          height: 50,
                        )
                      : getProgressiveNoUserAvatar(height: 50, width: 50),
                ),
              ))
            ],
          ),
        );
  }
}

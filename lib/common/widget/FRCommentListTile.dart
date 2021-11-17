import 'package:flutter/material.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:sizer/sizer.dart';

class FRUserListCommentTile extends StatelessWidget {
  const FRUserListCommentTile({
    Key key,
    this.user,
    this.onTrailingTap,
    this.onTap,
    this.subtitle,
    this.title,
    this.avatarSize = 50,
    this.onLongPress,
    this.senderID,
    this.receiverID,
  }) : super(key: key);
  final Function onLongPress;
  final UserModel user;
  final VoidCallback onTrailingTap;
  final VoidCallback onTap;
  final String subtitle;
  final Widget title;
  final double avatarSize;
  final int senderID, receiverID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 1.2.w),
          child: ClipOval(
            child: user?.thumbnailAvatar != null
                ? getProgressiveImage(
                    user.thumbnailAvatar,
                    user.avatar,
                    width: 30,
                    height: 30,
                  )
                : getProgressiveNoUserAvatar(width: 50, height: 50),
          ),
        ),
        Expanded(child: title)
      ]),
    );
  }
}

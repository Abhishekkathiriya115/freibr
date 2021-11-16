import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/util/extension.dart';
import 'package:sizer/sizer.dart';

class FRUserListTile extends StatelessWidget {
  const FRUserListTile({
    Key key,
    this.user,
    this.onTrailingTap,
    this.onTap,
    this.isMe = true,
    this.subtitle,
    this.title,
    this.avatarSize = 50,
    this.onLongPress,
    this.senderID,
    this.receiverID,
  }) : super(key: key);
  final Function onLongPress;
  final UserModel user;
  final bool isMe;
  final VoidCallback onTrailingTap;
  final VoidCallback onTap;
  final String subtitle;
  final Widget title;
  final double avatarSize;
  final int senderID, receiverID;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        onLongPress: () {
          if (onLongPress != null) {
            onLongPress(senderID, receiverID);
          }
        },
        leading: ClipOval(
          child: user?.thumbnailAvatar != null
              ? getProgressiveImage(
                  user.thumbnailAvatar,
                  user.avatar,
                  width: avatarSize,
                  height: avatarSize,
                )
              : getProgressiveNoUserAvatar(
                  width: avatarSize, height: avatarSize),
        ),
        title: title.isNullOrEmpty() ? Text(user?.name ?? "") : title,
        subtitle: Text(this.subtitle ?? user.profileName ?? ""),
        trailing:isMe ? onTrailingTap != null
            ? IconButton(
                icon: Icon(FontAwesome.ellipsis_v),
                onPressed: onTrailingTap,
              )
            : null : SizedBox());
  }
}

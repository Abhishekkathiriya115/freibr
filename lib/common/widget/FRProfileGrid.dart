import 'package:flutter/material.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/common/widget/FRGridBox.dart';

class FRProfileGrid extends StatelessWidget {
  FRProfileGrid(
      {Key key,
      this.user,
      this.childAspectRatio = 1.0,
      this.onAboutTap,
      this.onPostTap,
      this.onRoomTap,
      this.onFeedbackTap})
      : super(key: key);
  final UserModel user;
  final double childAspectRatio;
  final VoidCallback onAboutTap;
  final VoidCallback onPostTap;
  final VoidCallback onRoomTap;
  final VoidCallback onFeedbackTap;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 2,
      padding: EdgeInsets.all(15),
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: [
        FRGridBox(
            bgImageUrl: user?.thumbnailAvatar == null
                ? 'noprofile.png'
                : user.thumbnailAvatar,
            title: 'About',
            onTap: onAboutTap),
        FRGridBox(bgImageUrl: 'box/box2.png', title: 'Posts', onTap: onPostTap),
        FRGridBox(
            bgImageUrl: 'assets/images/chat.png',
            isLocal: true,
            title: 'Chat Rooms',
            onTap: onRoomTap),
        FRGridBox(
            bgImageUrl: 'assets/images/service.png',
            isLocal: true,
            title: 'Services',
            onTap: onFeedbackTap),
      ],
    );
  }
}

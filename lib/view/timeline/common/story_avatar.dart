import 'package:flutter/material.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TimelineStoryAvatar extends StatelessWidget {
  const TimelineStoryAvatar({Key key, this.user}) : super(key: key);
  final UserModel user;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(1),
            width: 76,
            height: 76,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Get.theme.primaryColor.withOpacity(0.8), width: 3)),
            child: ClipOval(
              child: getProgressiveImage('noprofile.png','noprofile.png'),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Temp',
            style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 8.sp),
          )
        ],
      ),
    );
  }
}

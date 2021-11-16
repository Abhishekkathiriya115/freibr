import 'package:flutter/material.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyStoryAvatar extends StatelessWidget {
  const MyStoryAvatar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Get.theme;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: ClipOval(
                    child:
                        getProgressiveImage('noprofile.png', 'noprofile.png')),
              ),
              Positioned(
                bottom: 0,
                right: -9,
                child: Container(
                  decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(width: 2)),
                  child: Icon(Icons.add),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'My Story',
            style: theme.textTheme.bodyText1.copyWith(fontSize: 8.sp),
          )
        ],
      ),
    );
  }
}

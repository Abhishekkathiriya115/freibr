import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SectionBuilder extends StatelessWidget {
  final String title;
  final List<Widget> list;

  const SectionBuilder({Key key, this.title, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: title == '' ? EdgeInsets.only(top: 0) : EdgeInsets.only(top: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.textTheme.subtitle1,
          ),
          ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: list)
        ],
      ),
    );
  }
}

class SectionListTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final Widget trailing;

  const SectionListTile(
      {Key key, this.title, this.icon, this.onTap, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: icon,
        title: Text(
          title,
          style: Get.textTheme.bodyText1,
        ),
        onTap: onTap,
        trailing: trailing);
  }
}

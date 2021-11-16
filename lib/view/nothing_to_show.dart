import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NothingToShow extends StatelessWidget {
  final String title;
  const NothingToShow({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: Get.theme.textTheme.subtitle1.copyWith(fontSize: 14.sp),
          ),
        ),
        body: Center(
            child: FREmptyScreen(
          imageSrc: noMessage,
          title: 'Nothing to show',
          onTap: () {},
        )),
      ),
    );
  }
}

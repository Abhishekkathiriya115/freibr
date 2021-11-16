import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/nothing_to_show.dart';
import 'package:freibr/view/settings/section_build.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class About extends StatelessWidget {
  TextStyle listTileTextStyle = Get.textTheme.bodyText1;

  About({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'About',
              style: Get.theme.textTheme.subtitle1.copyWith(fontSize: 14.sp),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                children: [aboutList()],
              ),
            ),
          ),
        ));
  }

  Widget aboutList() {
    return SectionBuilder(
      title: '',
      list: [
        SectionListTile(
          title: 'App updates',
          onTap: () {
            Get.to(NothingToShow(
              title: 'App updates',
            ));
          },
        ),
        SectionListTile(
          title: 'Updates availability',
          onTap: () {
            Get.to(NothingToShow(title: 'Updates availability'));
          },
        ),
        SectionListTile(
          title: 'Updates installed',
          onTap: () {
            Get.to(NothingToShow(title: 'App updates'));
          },
        ),
        SectionListTile(
          title: 'Data policy',
          onTap: () {
            // Get.to(NothingToShow(title: 'Data policy'));
            launchInBrowser('https://admin.freibr.com/pages/data_policy.html');
          },
        ),
        SectionListTile(
          title: 'Terms of use',
          onTap: () {
            launchInBrowser('https://admin.freibr.com/pages/terms_use.html');
            //
            // Get.to(NothingToShow(title: 'Terms of use'));
          },
        ),
      ],
    );
  }
}

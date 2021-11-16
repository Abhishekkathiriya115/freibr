import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/settings/reports.dart';
import 'package:freibr/view/settings/section_build.dart';
import 'package:freibr/view/settings/violations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SupportRequest extends StatelessWidget {
  TextStyle listTileTextStyle = Get.textTheme.bodyText1;

  SupportRequest({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Support Request',
              style: Get.textTheme.headline6,
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                children: [accountList()],
              ),
            ),
          ),
        ));
  }

  Widget accountList() {
    return SectionBuilder(
      title: '',
      list: [
        SectionListTile(
          icon: Icon(Icons.report),
          title: 'Reports',
          onTap: () {
            launchInBrowser(
                'https://admin.freibr.com/pages/report_voilence.html');
            // Get.to(Reports());
          },
        ),
        SectionListTile(
          icon: Icon(Icons.format_paint),
          title: 'Violations',
          onTap: () {
            // Get.to(Violations());
            launchInBrowser(
                'https://admin.freibr.com/pages/report_spam_abuse.html');
          },
        )
      ],
    );
  }
}

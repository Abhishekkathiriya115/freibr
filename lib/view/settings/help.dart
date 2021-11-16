import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/view/settings/report_problem.dart';
import 'package:freibr/view/settings/section_build.dart';
import 'package:freibr/view/settings/send_feedback.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Help extends StatelessWidget {
  TextStyle listTileTextStyle = Get.textTheme.bodyText1;

  Help({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Help',
              style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 15.sp),
            ),
          ),
          body: SingleChildScrollView(
            child: SectionBuilder(
              title: 'Report a problem',
              list: [helpList()],
            ),
          ),
        ));
  }

  Widget helpList() {
    return SectionBuilder(
      title: '',
      list: [
        SectionListTile(
          icon: Icon(Icons.info_outline),
          title: 'Report spam or abuse',
        ),
        SectionListTile(
          icon: Icon(Icons.feedback_outlined),
          title: 'Send feedback',
          onTap: () {
            Get.to(SendFeedBack());
          },
        ),
        SectionListTile(
          icon: Icon(Icons.sync_problem),
          title: 'Report a problem',
          onTap: () {
            Get.to(ReportProblem());
          },
        ),
      ],
    );
  }
}

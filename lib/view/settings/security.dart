import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/view/settings/password.dart';
import 'package:freibr/view/settings/section_build.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Security extends StatelessWidget {
  const Security({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Security',
              style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 15.sp),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                children: [loginSecurity()],
              ),
            ),
          ),
        ));
  }

  Widget loginSecurity() {
    return SectionBuilder(
      title: 'Login Security',
      list: [
        SectionListTile(
          icon: Icon(Icons.vpn_key_sharp),
          title: 'Password',
          onTap: () {
            Get.to(Password());
          },
        ),
        // SectionListTile(
        //   icon: Icon(Icons.vpn_key_sharp),
        //   title: 'Saved Login Info',
        // )
      ],
    );
  }
}

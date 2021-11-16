import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/profile.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/settings/about.dart';
import 'package:freibr/view/settings/help.dart';
import 'package:freibr/view/settings/privacy.dart';
import 'package:freibr/view/settings/security.dart';
import 'package:freibr/view/settings/support_request.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Provider.of(context);

    return StatefulWrapper(
        onInit: () {},
        child: Scaffold(
          appBar: AppBar(
            title: Text('Settings',
                style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 15.sp)),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Privacy'),
                onTap: () {
                  Get.to(Privacy());
                },
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Security'),
                onTap: () {
                  Get.to(Security());
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                onTap: () {
                  Get.to(Help());
                },
              ),
              ListTile(
                leading: Icon(Icons.support),
                title: Text('Support request'),
                onTap: () {
                  Get.to(SupportRequest());
                },
              ),
              ListTile(
                leading: Icon(Icons.policy),
                title: Text('Privacy policy'),
                onTap: () {
                  launchInBrowser(
                      'https://admin.freibr.com/pages/privacy_policy.html');
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () {
                  Get.to(About());
                },
              ),
              ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () async => await controller.authController.logout()),
            ],
          ),
        ));
  }
}

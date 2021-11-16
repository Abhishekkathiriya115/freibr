import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/controller/notification.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        Provider.of<NotificationController>(context, listen: false)
            .registerNotification();
        Provider.of<AuthenticationController>(context, listen: false)
            .getFcmToken();
        Provider.of<AuthenticationController>(context, listen: false)
            .checkIsLoggedIn();
      },
      child: Scaffold(
          body: Center(
              child: Image.asset(
        'assets/images/freibr.png',
        width: Get.size.width / 2.5,
      ))),
    );
  }
}

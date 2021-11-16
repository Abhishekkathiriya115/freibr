import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/bank_details.dart';
import 'package:freibr/core/controller/navigation.dart';
import 'package:freibr/view/bottom.dart';
import 'package:freibr/view/chat/chat.dart';
import 'package:freibr/view/notification/notification.dart';
import 'package:freibr/view/timeline/timeline.dart';
import 'package:freibr/view/search/user.dart';

import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final List<Widget> bodyWidgets = [
    Timeline(),
    UserSearch(),
    Container(),
    NotificationView(),
    Chat()
    // NotificationsView(),
    // ChatView(),
  ];

  BankDetailsContoller _contoller;

  @override
  Widget build(BuildContext context) {
    _contoller = Provider.of(context);

    return StatefulWrapper(
      onInit: () {
        _contoller.getBankDetails();
      },
      child: Scaffold(
        body: bodyWidgets[
            Provider.of<NavigationController>(context).selectedIndex],
        bottomNavigationBar: FRBottomNavigation(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/view/settings/section_build.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Account extends StatelessWidget {
  TextStyle listTileTextStyle = Get.textTheme.bodyText1;

  Account({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Account',
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
      title: 'Accounts',
      list: [
        SectionListTile(
          icon: Icon(Icons.perm_identity),
          title: 'Personal information',
        ),
        SectionListTile(
          icon: Icon(Icons.group_outlined),
          title: 'Close friends',
        ),
        SectionListTile(
          icon: Icon(Icons.language),
          title: 'Language',
        ),
        SectionListTile(
          icon: Icon(Icons.contact_phone),
          title: 'Contact syce',
        ),
        SectionListTile(
          icon: Icon(Icons.share),
          title: 'Share to other apps',
        ),
        SectionListTile(
          icon: Icon(Icons.switch_account),
          title: 'Switch account',
        ),
        SectionListTile(
          icon: Icon(Icons.account_box),
          title: 'Add new account',
        ),
      ],
    );
  }
}

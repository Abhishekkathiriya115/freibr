import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/profile.dart';
import 'package:freibr/view/settings/accounts_you_follow.dart';
import 'package:freibr/view/settings/mute_account.dart';
import 'package:freibr/view/settings/restricted_account.dart';
import 'package:freibr/view/settings/section_build.dart';
import 'package:freibr/view/user/following.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Privacy extends StatelessWidget {
  TextStyle listTileTextStyle = Get.textTheme.bodyText1;
  ProfileController profileController;

  Privacy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    profileController = Provider.of(context);

    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Privacy',
              style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 15.sp),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                children: [accountPrivacy(), connections()],
              ),
            ),
          ),
        ));
  }

  Widget accountPrivacy() {
    return SectionBuilder(
      title: 'Account privacy',
      list: [
        ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text(
            'Private Account',
            style: listTileTextStyle,
          ),
          trailing: Switch(
            activeColor: Get.theme.accentColor,
            value: profileController.user.profileType == "public",
            onChanged: (bool value) {
              profileController.user.profileType = value ? 'public' : 'private';
              profileController.updateProfile(isGoBack: false);
            },
          ),
        )
      ],
    );
  }

  Widget connections() {
    return SectionBuilder(
      title: 'Connections',
      list: [
        SectionListTile(
          icon: Icon(Icons.block),
          title: 'Restricted Accounts',
          onTap: () {
            Get.to(RestrictedAccount());
          },
        ),
        // SectionListTile(
        //   icon: Icon(FontAwesome.bell_slash_o),
        //   title: 'Mute Accounts',
        //   onTap: () {
        //     Get.to(MuteAccount());
        //   },
        // ),
        SectionListTile(
          icon: Icon(Icons.group),
          title: 'Accounts You Follow',
          onTap: () {
            Get.to(Following(user: profileController.user));
          },
        ),
      ],
    );
  }
}

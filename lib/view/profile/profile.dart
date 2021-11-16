import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freibr/common/widget/FRDrawer.dart';
import 'package:freibr/common/widget/icons.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/bank_details.dart';
import 'package:freibr/core/controller/profile.dart';
import 'package:freibr/common/widget/FRProfileGrid.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/bank_details/bank_details.dart';
import 'package:freibr/view/bottom.dart';
import 'package:freibr/view/chat/chat.dart';
import 'package:freibr/view/chat/join.dart';
import 'package:freibr/view/gig/list.dart';
import 'package:freibr/view/gig/media.dart';
import 'package:freibr/view/home.dart';
import 'package:freibr/view/notification/notification.dart';
import 'package:freibr/view/post/saved_post.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:freibr/util/extension.dart';
import 'package:freibr/view/profile/edit.dart';
import 'package:freibr/view/post/timeline.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/common/widget/profile/FRProfileIntroduction.dart';
import 'package:freibr/config/url.dart';

class Profile extends StatelessWidget {
  final bool isFirstTime;
  final bool isSettingClickable;

  const Profile(
      {Key key, this.isFirstTime = false, this.isSettingClickable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BankDetailsContoller _bankDetailsController = Provider.of(context);
    ProfileController controller = Provider.of(context);
    double paddingDivider =
        controller.user?.bio.toString().isNullOrEmpty() ? 3.0 : 3.7;
    final double itemHeight =
        (Get.size.height - kToolbarHeight - 24) / paddingDivider;
    final double itemWidth = Get.size.width / 1.5;

    return StatefulWrapper(
        onInit: () {
          Future.delayed(Duration.zero, () {
            controller.setProfileUser(controller.authController.authUser,
                isMe: true);
            controller.getUserProfile();
          });
        },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (isFirstTime) {
                      Get.off(Home());
                    } else {
                      Get.back();
                    }
                  }),
              title: Text('Profile',
                  style:
                      Get.theme.textTheme.bodyText1.copyWith(fontSize: 15.sp)),
              actions: [
                Stack(
                  children: [
                    Builder(
                        builder: (context) => IconButton(
                              icon: Icon(FontAwesome.bars),
                              onPressed: () =>
                                  Scaffold.of(context).openEndDrawer(),
                            )),
                    alertBubble(!_bankDetailsController.isAddedBankDetails,
                        left: 7, top: 9)
                  ],
                )
              ],
            ),
            endDrawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  createDrawerHeader(controller.user),
                  createDrawerBodyItem(
                      icon: Icons.home,
                      text: 'My Services',
                      onTap: () {
                        Get.to(() => GigsList());
                        //  Get.to(() => GigMedia());
                      }),
                  createDrawerBodyItem(
                      icon: Icons.account_circle,
                      text: 'Saved',
                      onTap: () {
                        Get.to(() => SavedPost());
                      }),
                  createDrawerBodyItem(
                      icon: Icons.notifications_active,
                      text: 'Notifications',
                      onTap: () {
                        Get.to(() => NotificationView());
                      }),
                  createDrawerBodyItem(
                      icon: FlutterIcons.bank_faw,
                      text: 'Bank details',
                      isShowBubble: !_bankDetailsController.isAddedBankDetails,
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => BankDetails());
                      }),

                  // ListTile(
                  //   title: Text('App version 1.0.0'),
                  //   onTap: () {},
                  // ),
                  Divider(),
                  createDrawerBodyItem(
                      icon: Icons.exit_to_app,
                      text: 'Logout',
                      onTap: () async =>
                          await controller.authController.logout()),
                ],
              ),
            ),
            body: controller.user != null //&& !controller.isLoadingProfile
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            child: FRProfileIntroduction(
                          isSettingClickable: isSettingClickable,
                          user: controller.user,
                          onTapChat: () {
                            Get.to(() => Chat());
                          },
                        )),
                        Container(
                          // height: 51.h,
                          child: FRProfileGrid(
                            childAspectRatio: (itemWidth / itemHeight),
                            user: controller.user,
                            onAboutTap: () {
                              Get.to(() => EditProfile());
                            },
                            onFeedbackTap: () {
                              print("feedback clicked");
                              if (isSettingClickable) Get.to(() => GigsList());
                            },
                            onPostTap: () {
                              Get.to(() => PostTimeline(
                                    user: controller.user,
                                    isMe: true,
                                  ));
                            },
                            onRoomTap: () {
                              // GroupChatModel param  = new GroupChatModel(
                              //   roomId: controller.user.id,
                              //   host: controller.user
                              // );
                              // Get.to(() => GroupChat(room: param));

                              String conferenceUrl = UrlDto.conferenceUrl +
                                  "/?room=${controller.user.id}&name=${controller.user.name}&user=${controller.user.id}&avatar=${controller.user.avatar}&iniator=true";
                              Get.back();
                              // Get.to(() => Conference(
                              //       conferenceUrl: conferenceUrl,
                              //     ));

                              Get.to(() => JoinConference(
                                    conferenceUrl: conferenceUrl,
                                    host: controller.user,
                                    showCamera: true,
                                  ));
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : Center(child: frCircularLoader()),
            bottomNavigationBar: FRBottomNavigation(
              isPageRoute: true,
            )));
  }
}

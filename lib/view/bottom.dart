import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freibr/common/widget/FRDrawer.dart';
import 'package:freibr/common/widget/FRTransparentButton.dart';
import 'package:freibr/config/url.dart';
import 'package:freibr/core/controller/notification.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/util/styles.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/core/controller/navigation.dart';
import 'package:freibr/common/widget/FRIconIndicator.dart';
import 'package:freibr/view/post/post_picker.dart';
import 'package:freibr/view/chat/join.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FRBottomNavigation extends StatelessWidget {
  final isPageRoute;
  IO.Socket socket;

  FRBottomNavigation({Key key, this.isPageRoute = false}) : super(key: key);

  void connectToServer() {
    socket = IO.io('${UrlDto.socketUrl}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((data) {
      print('connected');
    });
    socket.onDisconnect((_) => print("disconnected"));
  }

  @override
  Widget build(BuildContext context) {
    NavigationController navController =
        Provider.of<NavigationController>(context);
    connectToServer();

    _openPopup() {
      return AlertDialog(
        content: Container(
          height: 18.h,
          child: Column(
            children: <Widget>[
              FRTransparentButton(
                onPressed: () async {
                  Get.back();
                  Get.to(() => PostPicker());
                },
                label: "Create Post",
                // icon: FontAwesome.facebook_square,
              ),
              SizedBox(height: 2.h),
              FRTransparentButton(
                onPressed: () async {
                  var controller =
                      Provider.of<TimelineController>(context, listen: false)
                          .authController;

                  String conferenceUrl = UrlDto.conferenceUrl +
                      "/?room=${controller.authUser.id}&name=${controller.authUser.name}&user=${controller.authUser.id}&avatar=${controller.authUser.avatar}&iniator=true";
                  print("host conference url is ");
                  print(conferenceUrl);
                  Get.back();

                  Get.to(() => JoinConference(
                        conferenceUrl: conferenceUrl,
                        host: controller.authUser,
                        showCamera: true,
                      ));
                  // Get.to(() => Conference(
                  //       conferenceUrl: conferenceUrl,
                  //     ));
                },
                label: "Chatroom",
                // icon: FontAwesome.facebook_square,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
        height: 60.0,
        alignment: Alignment.center,
        child: new BottomAppBar(
          color: Get.theme.scaffoldBackgroundColor,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FRIconIndicator(
                icon: Icons.home_outlined,
                onPressed: () {
                  navController.setSelectedPageIndex(0);
                  Get.back();
                  if (isPageRoute) {
                    // Get.offAll(Home());
                  }
                },
              ),
              FRIconIndicator(
                icon: Icons.search,
                onPressed: () {
                  navController.setSelectedPageIndex(1);
                  Get.back();
                  if (isPageRoute) {
                    // Get.offAll(Home());
                  }
                },
              ),
              InkWell(
                onTap: () {
                  // navController.setSelectedPageIndex(0);
                  // if (isPageRoute) {
                  //   Get.offAll(Home());
                  // }
                  Get.dialog(_openPopup());
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  width: 60,
                  height: 60,
                  child: Icon(
                    Icons.add,
                    size: 25.sp,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: fabButtonLinearGradient),
                ),
              ),
              FRIconIndicator(
                showIndicator: Provider.of<NotificationController>(context)
                    .hasNotification,
                icon: FontAwesome.bell_o,
                onPressed: () {
                  navController.setSelectedPageIndex(3);
                  Provider.of<NotificationController>(context, listen: false)
                      .setNotificationStatus(false);
                  Get.back();
                  if (isPageRoute) {
                    // Get.offAll(Home());
                  }
                },
              ),
              // Stack(
              //   children: [
              FRIconIndicator(
                icon: Icons.chat_bubble_outline_outlined,
                onPressed: () {
                  navController.setSelectedPageIndex(4);
                  Get.back();
                  if (isPageRoute) {
                    // Get.offAll(Home());
                  }
                },
              ),
              //     alertBubble(true, right: 0, top: 1, color: theme.accentColor)
              //   ],
              // ),
            ],
          ),
        ));
  }
}

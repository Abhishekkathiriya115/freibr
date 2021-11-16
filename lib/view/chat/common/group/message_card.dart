import 'package:flutter/material.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/model/chat/chat.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({Key key, this.model}) : super(key: key);
  final GroupChatModel model;

  @override
  Widget build(BuildContext context) {
    AuthenticationController controller = Provider.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Get.size.width - 45,
          minWidth: Get.size.width / 2.8,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Get.theme.accentColor,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 30, 20),
                child: Text(
                  model.message,
                  style:
                      Get.theme.textTheme.bodyText1.copyWith(fontSize: 10.sp),
                ),
              ),
              SizedBox(height: 2),
              Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(convertToAgo(model.createdAt),
                        ClipOval(
                          child: controller.authUser.thumbnailAvatar != null
                              ? getProgressiveImage(
                                  controller.authUser?.thumbnailAvatar,
                                  controller.authUser?.avatar,
                                  width: 15,
                                  height: 15,
                                )
                              : getProgressiveNoUserAvatar(
                                  width: 10, height: 10),
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Me',
                          style: Get.theme.textTheme.bodyText1
                              .copyWith(fontSize: 8.sp),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.done_all,
                          size: 8.sp,
                        ),
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}

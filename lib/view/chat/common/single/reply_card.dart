import 'package:flutter/material.dart';
import 'package:freibr/core/model/chat/personal.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({Key key, this.model}) : super(key: key);
  final PersonalChatModel model;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Get.size.width - 45,
          minWidth: Get.size.width / 2.8,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Get.theme.accentColor.withOpacity(0.5),
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
                child: Text(
                  convertToAgo(model.createdAt),
                  style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 8.sp),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

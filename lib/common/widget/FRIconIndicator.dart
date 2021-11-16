import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FRIconIndicator extends StatelessWidget {
  const FRIconIndicator({Key key, this.onPressed, this.icon, this.showIndicator = false}) : super(key: key);
  final VoidCallback onPressed;
  final IconData icon;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -1,
          right: -1,
          child: Icon(
            Icons.brightness_1,
            size: 10,
            color: showIndicator ? Get.theme.primaryColor : Get.theme.scaffoldBackgroundColor,
          ),
        ),
        IconButton(
            icon: Icon(
              icon,
              size: 25.sp,
            ),
            onPressed: onPressed),
      ],
    );
  }
}

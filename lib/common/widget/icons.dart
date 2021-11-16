import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatIcon extends StatelessWidget {
  final double height, width;
  final VoidCallback onTap;
  const ChatIcon({Key key, this.height, this.width, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: SizedBox(
        height: height ?? 7.5.h,
        width: width ?? 16.w,
        child: Image.asset('assets/images/chat.png'),
      ),
    );
  }
}

class ServiceIcon extends StatelessWidget {
  final double height, width;
  final VoidCallback onTap;
  const ServiceIcon({Key key, this.height, this.width, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Icon();
    return Tab(
      icon: new Image.asset("assets/images/service.png"),
      // onTap: this.onTap,
      // //  : SizedBox(
      // //   height: height ?? 17.h,
      // //   width: width ?? 17.w,
      // //   child: Image.asset('assets/images/service.png'),
      // ),
    );
  }
}

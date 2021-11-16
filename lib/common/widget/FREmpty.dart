import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FREmptyScreen extends StatelessWidget {
  final String title;
  final String imageSrc;
  final VoidCallback onTap;

  const FREmptyScreen(
      {Key key, @required this.title, @required this.imageSrc, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              height: 40.h,
              width: 40.w,
              image: AssetImage(
                imageSrc,
              )),
          Text(
            title,
            style: Get.theme.textTheme.bodyText1
                .copyWith(fontSize: 20.0, color: Colors.grey),
          ),
          SizedBox(height: onTap != null ? 20 : 0),
          onTap != null
              ? IconButton(
                  iconSize: 45,
                  onPressed: onTap,
                  icon: Icon(Icons.refresh),
                )
              : Container()
        ],
      ),
    );
  }
}

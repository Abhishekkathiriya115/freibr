import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FRTransparentButton extends StatelessWidget {
  FRTransparentButton(
      {@required this.onPressed,
      @required this.label,
      this.icon,
      this.fontSize = 12.0});
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    // color: Colors.white,
                  )
                : Container(),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                label,
                style: Get.theme.textTheme.bodyText1
                    .copyWith(fontSize: fontSize.sp, color: Colors.white),
              ),
            )
          ],
        ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(width: 1.8)))),
        onPressed: onPressed,
      ),
    );
  }
}

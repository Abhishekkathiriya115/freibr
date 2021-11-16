import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/util/styles.dart';

class FRButton extends StatelessWidget {
  FRButton(
      {@required this.onPressed,
      @required this.label,
      this.fontSize = 12.0,
      this.btnHeight,
      this.borderRadius,
      this.btnColor,
      this.labelColor,
      this.fontWeight,
      this.gradientButton = true});
  final VoidCallback onPressed;
  final String label;
  final double fontSize;
  final double btnHeight;
  final double borderRadius;
  final Color btnColor;
  final Color labelColor;
  final FontWeight fontWeight;
  final bool gradientButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: btnHeight ?? 7.h,
      // padding: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.all<Color>(
                btnColor ?? Get.theme.primaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
            ))),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
            gradient: gradientButton ? buttonLinearGradient : null,
          ),
          // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.bodyText1.copyWith(
                fontWeight: fontWeight,
                color: labelColor ?? Get.theme.textTheme.bodyText1.color,
                fontSize: fontSize.sp),
          ),
        ),
      ),
    );
  }
}

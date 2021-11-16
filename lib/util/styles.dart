import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

var theme = Get.theme;
var buttonLinearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [theme.primaryColor, theme.accentColor.withOpacity(0.8)]);

var fabButtonLinearGradient = LinearGradient(
  colors: [theme.primaryColor, theme.accentColor],
  begin: Alignment.bottomRight,
  end: Alignment.topRight,
);

InputDecoration textFieldDecoration({String hintText, Widget suffixIcon, Widget prefixIcon,
Color fillColor,  
double borderRadius = 10}) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: Get.theme.textTheme.bodyText1.copyWith(fontSize: 11.sp),
      // fillColor: Colors.white,
      suffixIcon: suffixIcon != null ? suffixIcon : null,
      prefixIcon: prefixIcon != null ? prefixIcon : null,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide(width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide(width: 1)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        borderSide: BorderSide(width: 1),
      ),
      filled: true);
}

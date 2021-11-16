import 'package:flutter/material.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FRGridBox extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String bgImageUrl;
  final bool isLocal;
  FRGridBox(
      {Key key, this.title, this.onTap, this.bgImageUrl, this.isLocal = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.primaryColorLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                alignment: Alignment.center,
                child: this.isLocal
                    ? Image.asset(bgImageUrl)
                    : getProgressiveImage(bgImageUrl, bgImageUrl,
                        height: Get.size.height, width: Get.size.height),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  alignment: Alignment.center,
                  height: 3.5.h,
                  width: 100.w,
                  decoration: BoxDecoration(

                      // color: greenLight,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Get.theme.primaryColor,
                        Get.theme.accentColor,
                      ])),
                  child: Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style:
                        Get.theme.textTheme.bodyText1.copyWith(fontSize: 11.sp),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

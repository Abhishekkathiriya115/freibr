import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:sizer/sizer.dart';

class FRLogo extends StatelessWidget {
  const FRLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 20.0),
      width: 18.h,
      height: 18.h,
      decoration: BoxDecoration(
        image: DecorationImage(fit: BoxFit.contain, image: AssetImage(logo)),
        borderRadius: BorderRadius.all(Radius.circular(140)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            blurRadius: 160,
            offset: Offset(4, 8), // Shadow position
          ),
        ],
      ),
    );
  }
}

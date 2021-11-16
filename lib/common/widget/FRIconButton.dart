import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FRIconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const FRIconButton(
      {Key key, @required this.text, @required this.icon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          // iconSize: 30.0,
          onPressed: onPressed,
        ),
        Text(
          text,
          style: Get.theme.textTheme.bodyText1.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
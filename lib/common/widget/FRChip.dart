import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FRChip extends StatelessWidget {
  final VoidCallback onDeleted;
  final String title;

  const FRChip({Key key, @required this.onDeleted, @required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        title,
        style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 10.0),
      ),
      // avatar: CircleAvatar(
      //   child: Text(
      //     title[0].toUpperCase(),
      //     style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 14.0),
      //   ),
      // ),
      labelPadding: EdgeInsets.all(2.0),
      elevation: 16,
      deleteIcon: Icon(
        Icons.cancel,
      ),
      onDeleted: onDeleted,
      deleteIconColor: Colors.redAccent,
      deleteButtonTooltipMessage: 'Remove this chip',
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
  }
}

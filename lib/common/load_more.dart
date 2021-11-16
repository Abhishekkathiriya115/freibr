import 'package:flutter/material.dart';

class LoadMoreWidget extends StatelessWidget {
  final ListView list;
  final ScrollController controller;

  const LoadMoreWidget({Key key, this.list, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [list],
      ),
    );
  }
}

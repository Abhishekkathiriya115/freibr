import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';

class Reports extends StatelessWidget {
  const Reports({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Reports'),
          ),
          body: ListView(
            children: Iterable.generate(30, (index) {
              return ListTile(
                title: Text('Reports ${index}'),
              );
            }).toList(),
          ),
        ));
  }
}

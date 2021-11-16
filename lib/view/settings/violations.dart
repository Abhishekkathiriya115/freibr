import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';

class Violations extends StatelessWidget {
  const Violations({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: null,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Violations'),
          ),
          body: ListView(
            children: Iterable.generate(30, (index) {
              return ListTile(
                title: Text('Violation ${index}'),
              );
            }).toList(),
          ),
        ));
  }
}

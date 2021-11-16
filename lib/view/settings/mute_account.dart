import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRListTileButton.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/model/user/user.dart';

class MuteAccount extends StatelessWidget {
  const MuteAccount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mute Accounts'),
        ),
        body: ListView(
          children: Iterable.generate(50, (index) {
            return FRListTileButton(
                onAvatarTap: () {},
                onButtonTap: () async {},
                user: UserModel(name: 'rahul', follow: 'MUTE'));
          }).toList(),
        ),
      ),
    );
    // return Container(
    //   child: Text('Data'),
    // );
  }
}

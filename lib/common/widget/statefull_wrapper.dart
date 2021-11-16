import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:provider/provider.dart';
import 'package:freibr/common/widget/FREmpty.dart';

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Function dispose;
  final Widget child;
  const StatefulWrapper(
      {@required this.onInit, @required this.child, this.dispose});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.dispose != null) {
      widget.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Provider.of<ConnectivityResult>(context) == ConnectivityResult.none ?  FREmptyScreen(
        imageSrc: noInternet, title: 'No Internet Connection',) : GestureDetector(
         behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: widget.child),
    );
  }
}

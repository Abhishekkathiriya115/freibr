import 'package:flutter/cupertino.dart';

import 'authentication.dart';

class NavigationController extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  final AuthenticationController authController;
  NavigationController({this.authController}) {
    if (this.authController != null) {}
  }

  void setSelectedPageIndex(int pageIndex) {
    this._selectedIndex = pageIndex;
    notifyListeners();
  }
}

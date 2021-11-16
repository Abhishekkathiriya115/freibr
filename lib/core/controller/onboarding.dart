import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/model/onboarding_info.dart';
import 'package:freibr/view/authentication/login.dart';
import 'package:get/get.dart';

class OnboardingController with ChangeNotifier {
  int _selectedPageIndex = 0;
  get selectedPageIndex => _selectedPageIndex;

  bool get isLastPage => _selectedPageIndex == onboardingPages.length - 1;
  var pageController = PageController();

  Future<void> initController() async {
    bool isFirstTime = await AppSharedPreferences.isFirstTimeUser();
    if (isFirstTime == null) {
    } else {
      Get.off(Login());
    }
  }

  Future<void> setFirstTimeUser() async {
    await AppSharedPreferences.setisFirstTimeUser(true);
    Get.off(Login());
  }

  void setPageIndex(int index) {
    this._selectedPageIndex = index;
    notifyListeners();
  }

  forwardAction() {
    if (isLastPage) {
      //go to home page
    } else {
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
    notifyListeners();
  }

  List<OnboardingInfo> onboardingPages = [
    OnboardingInfo(walk1, 'Lorem Ipsum Dolor',
        'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.'),
    OnboardingInfo(walk2, 'Lorem Ipsum Dolor',
        'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.'),
    OnboardingInfo(walk3, 'Lorem Ipsum Dolor',
        'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.')
  ];
}

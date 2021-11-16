import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/logo_widget.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/onboarding.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';



class Walkthrough extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<OnboardingController>(context, listen: true);

    return StatefulWrapper(
      onInit: () {
        // _authController.registerNotification();
        // _authController.getFcmToken();
        // _authController.checkIsLoggedIn();
      },
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.setPageIndex(index);
                },
                itemCount: controller.onboardingPages.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FRLogo(),
                        Image.asset(
                          controller.onboardingPages[index].imageAsset,
                          height: 25.h,
                          width: 25.h,
                        ),
                        SizedBox(height: 16),
                        Text(
                          controller.onboardingPages[index].title,
                          style: Get.theme.textTheme.headline1.copyWith(fontSize: 14.sp),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            controller.onboardingPages[index].description,
                            textAlign: TextAlign.center,
                            style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 11.sp),
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.onboardingPages.length,
                            (index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                height: 8.0,
                                width: controller.selectedPageIndex == index
                                    ? 16.0
                                    : 8.0,
                                decoration: BoxDecoration(
                                  color: controller.selectedPageIndex == index
                                      ? Colors.white
                                      : Get.theme.accentColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  // shape: BoxShape.circle,
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }),
            Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: FRButton(
                    label: "Get Started",
                    onPressed: () async {
                      await controller.setFirstTimeUser();
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

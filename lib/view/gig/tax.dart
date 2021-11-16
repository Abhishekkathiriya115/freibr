import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/service/gig.dart';
import 'package:freibr/view/gig/list.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class GigTaxInformation extends StatelessWidget {
  const GigTaxInformation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Tax Information"),
              SizedBox(
                height: 1.2.h,
              ),
              Container(
                  width: 70.w,
                  height: 7.h,
                  child: FRButton(
                      onPressed: () {
                        // Navigator.pushAndRemoveUntil(context, newRoute, (route) => )
                        // Navigator.restorablePush(context, (context, arguments) => null)
                        // Navigator.
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(builder: (_) => GigsList()),
                        //     (route) => true);
                        // Get.offUntil(GetPageRoute(page: () => GigsList()),
                        //     (route) => false);
                        // Get.to(GigsList());
                        Get.back();
                        Get.back();
                        Get.back();
                        Get.back();
                        Get.back();
                        Get.back();
                        Get.to(GigsList());
                      },
                      label: 'Back To Service List')),
            ],
          ),
        ),
      ),
    );
  }
}

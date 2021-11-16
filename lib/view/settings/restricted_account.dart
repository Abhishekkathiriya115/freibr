import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRUserListTile.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/settings/restricted_accounts.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/view/appbar/FRAppbar.dart';

class RestrictedAccount extends StatelessWidget {
  RestrictedAccountController controller;
  RestrictedAccount({Key key, this.user}) : super(key: key);
  final UserModel user;
  ScrollController _controller;

  void getAccounts({bool isRefresh = false}) {
    controller.getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<RestrictedAccountController>(context);

    return StatefulWrapper(
      onInit: () {
        this.getAccounts();
        _controller = ScrollController();
        _controller.addListener(fetchMore);
        Future.microtask(() => controller.setLoader(true));
        Future.microtask(() => controller.setFetchMore(true));
      },
      dispose: dispose,
      child: Scaffold(
        appBar: FRUserAppBar(
          title: 'Restricted Accounts',
          fontSize: 14.sp,
          showBtnBack: true,
        ),
        body: controller.isLoading
            ? Center(child: frCircularLoader())
            : controller.usersList.length == 0
                ? Center(
                    child: Container(
                      height: 60.h,
                      width: 60.w,
                      child: Image.asset('assets/images/no_notification.png'),
                    ),
                  )
                : ListView.builder(
                    controller: _controller,
                    itemCount: controller.usersList.length +
                        (controller.isMoreEnabled ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (controller.isMoreEnabled &&
                          index == controller.usersList.length) {
                        return Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: frCircularLoader(
                              height: 20,
                              width: 20,
                            ));
                      }
                      return FRUserListTile(
                          onTap: () {},
                          //subtitle: item.message,
                          user: controller.usersList[index],
                          onTrailingTap: () {
                            _showPopupMenu(
                                context, controller.usersList[index].id);
                          });
                    }),
      ),
    );
  }

  void _showPopupMenu(context, int userId) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                "Are you sure?",
                style: Get.textTheme.subtitle1,
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Cancle',
                    style: Get.textTheme.bodyText1,
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    bool flag = await controller.unBlockUser(userId);
                    if (flag) {
                      this.getAccounts();
                    }
                  },
                  color: Get.theme.primaryColor,
                  child: Text(
                    'Unblock',
                    style: Get.textTheme.bodyText1,
                  ),
                )
              ],
            ));
  }

  void dispose() {
    _controller.dispose();
  }

  void fetchMore() {
    if (_controller.position.maxScrollExtent - _controller.offset < 50) {
      controller.fetchMore();
    }
  }
}

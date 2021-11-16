import 'package:flutter/foundation.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/service/settings.dart';
import 'package:freibr/core/service/timeline.dart';
import 'package:freibr/util/util.dart';
import 'package:get/route_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RestrictedAccountController extends ChangeNotifier {
  bool isLoading = true, isfetchMore = false, isMoreEnabled = true;
  List<UserModel> usersList = [];
  int currentPage, lastPage;
  RefreshController refreshController;

  Future<void> hitAPI({int pageNumber, bool isFetchMore}) async {
    Map result = await BlockUserService.getBlockedUsers(pageNumber: pageNumber);
    if (result != null) {
      usersList = !isFetchMore ? result['list'] : usersList + result['list'];
      currentPage = result['current_page'];
      lastPage = result['last_page'];
      isLoading = false;
      isMoreEnabled = currentPage != lastPage;
      notifyListeners();
    } else {
      showToast(message: 'Something went wrong');
    }
  }

  void getAccounts() async {
    await this.hitAPI(pageNumber: null, isFetchMore: false);
  }

  void blockUser(int userId) async {
    Get.back();
    showLoadingDialog();
    Map result = await BlockUserService.blockUser(userId);
    if (result != null) {
      if (result['status']) {
        showToast(message: result['message']);
      } else {
        showToast(message: result['message']);
      }
    } else {
      showToast(message: 'Something went wrong');
    }
  }

  void setFollow(String userId, {bool isUNFollow = false}) async {
    try {
      var result = await TimelineService.setFollowUser(userId);
      if (result != null) {
        showToast(message: isUNFollow ? 'Unfollowed' : 'Followed');
        notifyListeners();
      }
    } catch (e) {
      showToast(message: 'Something went wrong');
    }
  }

  Future<bool> unBlockUser(int userId) async {
    Get.back();
    showLoadingDialog();
    Map result = await BlockUserService.unBlockUser(userId);
    if (result != null) {
      if (result['status']) {
        showToast(message: result['message']);
        setLoader(true);
        return true;
      } else {
        showToast(message: result['message']);
        return false;
      }
    } else {
      showToast(message: 'Something went wrong');
      return false;
    }
  }

  void setLoader(loader) {
    isfetchMore = true;
    isMoreEnabled = true;
    this.isLoading = loader;
    currentPage = null;
    lastPage = null;
    notifyListeners();
  }

  void setFetchMore(flag) {
    this.isfetchMore = flag;
  }

  void fetchMore() async {
    if (isfetchMore) {
      isfetchMore = true;
      await this.hitAPI(pageNumber: this.currentPage + 1, isFetchMore: true);
      isfetchMore = false;
      notifyListeners();
    }
  }
}

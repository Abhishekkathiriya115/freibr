import 'package:flutter/cupertino.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/model/user/user_follow.dart';
import 'package:freibr/core/controller/paging/paging.dart';
import 'package:freibr/core/service/profile.dart';
import 'package:freibr/core/service/timeline.dart';
import 'package:freibr/util/util.dart';

class TimelineController extends ChangeNotifier {
  final AuthenticationController authController;
  TimelineController({this.authController}) {
    if (this.authController != null) {
      this._hasFollowing =
          // ignore: null_aware_before_operator
          this.authController?.authUser?.totalFollowing > 0 ?? false;
    }
  }

  bool _postsLoading = false;
  bool get isLoading => _postsLoading;

  bool _hasFollowing = false;
  bool get hasFollowing => _hasFollowing;

  PagingController<UserModel> postsPagingController =
      new PagingController(initialRefreshParam: false);
  PagingController<UserFollowModel> storiesPagingController =
      new PagingController(initialRefreshParam: false);
  PagingController<UserModel> userSearchController =
      new PagingController(initialRefreshParam: true);
  PagingController<UserModel> storiesSearchPagingController =
      new PagingController(initialRefreshParam: true);
  PagingController<UserFollowModel> followPagingController =
      new PagingController(initialRefreshParam: true);
  PagingController<UserFollowModel> followingPagingController =
      new PagingController(initialRefreshParam: true);

  Future<void> getTimelineUsers(var page, var pageSize,
      {bool isRefresh = false}) async {
    try {
      this.setLoader(true);
      var result = await TimelineService.getTimelineUser(
          page.toString(), pageSize.toString());
      if (result != null) {
        postsPagingController.addItems(result.data);

        // this.postsPagingController.setCurrentPage((result.currentPage + 1));
        postsPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } finally {
      this.setLoader(false);
    }
    notifyListeners();
  }

  Future<void> getTimelineLiveUsers(var page, var pageSize,
      {bool isRefresh = false}) async {
    try {
      var result = await TimelineService.getTimelineLiveUsers(
          page.toString(), pageSize.toString());

      if (result != null) {
        storiesPagingController.addItems(result.data);
        storiesPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
        // this.postsPagingController.setCurrentPage((result.currentPage + 1));
      }
    } finally {}
    notifyListeners();
  }

  Future<void> getUserSearch(var page, var pageSize, String queryParam,
      {bool isRefresh = false}) async {
    try {
      // setLoader(true);

      var result = await TimelineService.getUserSearch(
          page.toString(), pageSize.toString(), queryParam);
      if (result != null) {
        userSearchController.addItems(result.data);
        userSearchController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
        // this.postsPagingController.setCurrentPage((result.currentPage + 1));
      }
    } finally {
      // setLoader(false);
    }
    notifyListeners();
  }

  Future<void> getUserSearchLiveSessions(
      var page, var pageSize, String queryParam,
      {bool isRefresh = false}) async {
    try {
      var result = await TimelineService.getUserSearchLiveSessions(
          page.toString(), pageSize.toString(), queryParam);
      if (result != null) {
        storiesSearchPagingController.addItems(result.data);
        storiesSearchPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
        // this.postsPagingController.setCurrentPage((result.currentPage + 1));
      }
    } finally {}
    notifyListeners();
  }

  Future<void> setLoader(bool status) async {
    this._postsLoading = status;
    // notifyListeners();
  }

  Future<UserModel> setFollower(
    UserModel user,
    int index,
  ) async {
    try {
      var result = await TimelineService.setFollowUser(user.id.toString());
      if (result != null) {
        user.follow = result.follow;
        // userSearchController.items[index] = user;
        this.getUserProfile();
        return user;
        // user.follow = result[]
      }
    } finally {}
    return null;
  }

  Future<void> setFollowerWithoutIndex(UserModel user,
      {Function(UserModel) callback}) async {
    try {
      showLoadingDialog();
      var result = await TimelineService.setFollowUser(user.id.toString());
      if (result != null) {
        // final index = postsPagingController.items
        //     .indexWhere((element) => element.id == user.id);
        if (callback != null) {
          callback(result);
        }
        postsPagingController.items
            .removeWhere((element) => element.id == user.id);
        this.getUserProfile();
        notifyListeners();
        // user.follow = result[]
      }
      dismissDialogToast();
    } finally {}
  }

  Future<UserModel> setFollowerStatus(UserModel user, int index) async {
    try {
      var result = await TimelineService.setFollowUser(user.id.toString());
      if (result != null) {
        user.follow = result.follow;
        userSearchController.items[index] = user;
        notifyListeners();
      }
    } finally {}
    return null;
  }

  Future<void> getPagedFollowings(var page, var pageSize, String userID,
      {bool isRefresh = false}) async {
    // isDataProcessing = true;
    var result = await TimelineService.getPagedFollowings(
        userID, page.toString(), pageSize.toString());
    if (result != null) {
      followingPagingController.addItems(result.data);
      followingPagingController.finishRefreshLoad(
          isRefresh: isRefresh, noMore: result.isLastPage);
      // this.postsPagingController.setCurrentPage((result.currentPage + 1));
    }
    notifyListeners();
  }

  Future<void> getPagedFollowers(var page, var pageSize, String userID,
      {bool isRefresh = false}) async {
    try {
      // isDataProcessing = true;
      var result = await TimelineService.getPagedFollowers(
          userID, page.toString(), pageSize.toString());
      if (result != null) {
        followPagingController.addItems(result.data);
        followPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
        // this.postsPagingController.setCurrentPage((result.currentPage + 1));
      }
    } finally {
      // isDataProcessing = false;
    }
    notifyListeners();
  }

  Future<UserFollowModel> followApproveReject(
      UserFollowModel followModel, String status) async {
    try {
      var result = await TimelineService.followApproveReject(
          followModel.id.toString(), status);
      if (result != null) {
        if (result['status']) {
          followModel.status = status;
          return followModel;
          // user.follow = result[]
        }
      }
    } finally {}
    return null;
  }

  Future<void> getPagedFollowRequests(var page, var pageSize) async {
    try {
      // isDataProcessing = true;
      var localCategories = await TimelineService.getPagedFollowRequests(
          page.toString(), pageSize.toString());
      if (localCategories != null) {
        // this.totalFollowRequests =
        //     localCategories[0].totalFollowRequests.toString();
      }
    } finally {
      // isDataProcessing = false;
    }
    notifyListeners();
  }

  Future<bool> checkIsLive(UserModel user) async {
    try {
      showLoadingDialog();
      var result = await TimelineService.checkIsLive(user.id.toString());
      return result;
    } finally {
      dismissDialogToast();
    }
  }

  Future<bool> closeLiveConference(UserModel user) async {
    try {
      showLoadingDialog();
      var result =
          await TimelineService.closeLiveConference(user.id.toString());
      return result;
    } finally {
      dismissDialogToast();
    }
  }

  Future<void> getUserProfile() async {
    var result = await ProfileService.getProfile();
    if (result != null) {
      this._hasFollowing = result.totalFollowing > 0;
      this.storeUserLocal(result);
    }
    notifyListeners();
  }

  Future<void> storeUserLocal(UserModel param) async {
    await AppSharedPreferences.setUserProfile(param);
    // this.authController.setAuthUser(param);
    notifyListeners();
  }
}

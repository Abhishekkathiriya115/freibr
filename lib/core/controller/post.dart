import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/controller/paging/paging.dart';
import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/model/post/post_model.dart';
import 'package:freibr/core/service/post.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/post/timeline.dart';
import 'package:get/get.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:provider/provider.dart';

class PostController extends ChangeNotifier {
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  List<CategoryModel> _choosenCategories = [];
  List<CategoryModel> get choosenCategories => _choosenCategories;

  PostModel _post = new PostModel();
  PostModel get post => _post;

  PagingController<PostModel> postPagingController =
      new PagingController(initialRefreshParam: false);

  final AuthenticationController authController;

  PostController({this.authController}) {
    if (this.authController != null) {}
  }

  postEdit() {
    postPagingController.items[0].description = 'ddd';
    notifyListeners();
  }

  Future<void> uploadPost(PostModel param, Set<MediaFile> mediaFiles) async {
    try {
      var result =
          await PostService.uploadPost(param, mediaFiles, (callbackData) {
        showProgressDialog(
            value: (callbackData / 100), message: 'uploading...');
      });

      showToast(message: result['message']);
      if (result != null && result['status']) {
        // navController.setSelectedPageIndex(0);
        Get.back();
        Get.off(PostTimeline(
          user: this.authController.authUser,
          isMe: true,
        ));
      }
    } finally {
      dismissDialogToast();
    }
    notifyListeners();
  }

  Future<void> uploadPostUpdate(PostModel postModel) async {
    try {
      var result = await PostService.uploadPostUpdate(postModel, (callbackData) {
        showProgressDialog(
            value: (callbackData / 100), message: 'Edit...');
      });

      showToast(message: result['message']);
      if (result != null && result['status']) {
        // navController.setSelectedPageIndex(0);
        Get.back();
        Get.off(PostTimeline(
          user: this.authController.authUser,
          isMe: true,
        ));
      }
    } finally {
      dismissDialogToast();
    }
    notifyListeners();
  }

  Future<void> getPosts(dynamic page, dynamic pageSize, dynamic userID,
      {bool isRefresh = false}) async {
    try {
      var result = await PostService.getPostsWithUser(page, pageSize, userID);
      if (result != null) {
        postPagingController.addItems(result.data);
        postPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } catch (e) {
    } finally {}
    notifyListeners();
  }

  void setExpanded(bool param) {
    this._isExpanded = param;
    notifyListeners();
  }

  Future<void> addChoosenCategoriesBulk(List<CategoryModel> param) async {
    _choosenCategories = [];
    _choosenCategories.addAll(param);
    notifyListeners();
  }

  Future<void> resetCategories(List<CategoryModel> param) async {
    _choosenCategories.clear();
    _choosenCategories.addAll(param);
    notifyListeners();
  }

  Future<void> removeChoosenCategory(CategoryModel param) async {
    var isExist = choosenCategories.indexWhere((p) => p.id == param.id);
    _choosenCategories.removeAt(isExist);
    notifyListeners();
  }

  Future<void> setLike(int index) async {
    var post = postPagingController.items[index];

    var result = await PostService.setLike(post.id);
    if (result != null && result['status']) {
      postPagingController.items[index].isLiked = true;
      postPagingController.items[index].totalLikes += 1;
      showToast(message: 'Post liked');
      notifyListeners();
    } else {
      showToast(message: 'Something went wrong');
    }
  }

  Future<void> setDislike(int index) async {
    var post = postPagingController.items[index];
    var result = await PostService.setDislike(post.id);
    if (result != null && result['status']) {
      postPagingController.items[index].isLiked = false;
      postPagingController.items[index].totalLikes -= 1;
      showToast(message: 'Post like removed');
      notifyListeners();
    } else {
      showToast(message: 'Something went wrong');
    }
  }

  void updatetotalComments(int index) {
    postPagingController.items[index].totalComments += 1;
    notifyListeners();
  }

  Future<void> bookmarkAdd(int postID, int otherUserID, int index) async {
    Map<String, int> data = {'post_id': postID, 'other_user_id': otherUserID};

    var result = await PostService.bookmarkAdd(data);
    if (result != null) {
      print(result);
      if (result['status']) {
        postPagingController.items[index].isSaved = true;
        showToast(message: result['data']['message']);
        notifyListeners();
        return;
      } else {
        showToast(message: result['data']['message']);
        return;
      }
    }
    showToast(message: 'Something went wrong');
  }

  Future<void> bookmarkRemove(int postID, int index) async {
    Map<String, int> data = {'post_id': postID};

    var result = await PostService.bookmarkRemove(data);
    if (result != null) {
      print(result);
      if (result['status']) {
        postPagingController.items[index].isSaved = false;
        showToast(message: result['message']);
        notifyListeners();
        return;
      } else {
        showToast(message: result['message']);
        return;
      }
    }
    showToast(message: 'Something went wrong');
  }

  Future<void> postDelete(int index) async {
    try {
      showLoadingDialog();
      Map response =
          await PostService.postDelete(postPagingController.items[index].id);
      if (response != null) {
        if (response['status']) {
          showToast(message: response['message']);
          postPagingController.items.removeAt(index);
          Get.back();
          notifyListeners();
        }
      } else {
        showToast(message: 'Something went wrong');
      }
    } catch (e) {
      showToast(message: 'Something went wrong');
    }
  }
}

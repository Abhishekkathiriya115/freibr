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

class SavedPostController extends ChangeNotifier {
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  List<CategoryModel> _choosenCategories = [];
  List<CategoryModel> get choosenCategories => _choosenCategories;

  PostModel _post = new PostModel();
  PostModel get post => _post;

  PagingController<PostModel> postPagingController =
      new PagingController(initialRefreshParam: false);

  Future<void> getPosts(dynamic page, dynamic pageSize,
      {bool isRefresh = false}) async {
    try {
      var result = await PostService.getPostsList(page, pageSize);
      if (result != null) {
        postPagingController.addItems(result.data);
        postPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } catch (e) {} finally {}
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

  Future<void> savePost(int postID, int otherUserID) async {
    Map<String, int> data = {'post_id': postID, 'other_user_id': otherUserID};

    var result = await PostService.bookmarkAdd(data);
    if (result != null) {
      if (result['status']) {
        showToast(message: result['data']['message']);
        return;
      } else {
        showToast(message: result['data']['message']);
        return;
      }
    }
    showToast(message: 'Something went wrong');
  }
}

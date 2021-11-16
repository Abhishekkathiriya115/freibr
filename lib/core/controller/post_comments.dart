import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freibr/core/model/paging/paging.dart';
import 'package:freibr/core/model/post/post_comment.dart';
import 'package:freibr/core/service/post.dart';
import 'package:freibr/util/util.dart';

class PostCommentsController extends ChangeNotifier {
  bool isLoading = true, isMoreEnabled = true, isFatchingMore = false;
  PageModel<PostComment> postComments = PageModel<PostComment>();

  Future<void> getPostComments(int postID, {bool isLoadMore = false}) async {
    if (isLoadMore) {
      isFatchingMore = true;
      notifyListeners();
      PageModel<PostComment> newComments = await PostService.getPostComments(
          postID,
          page: postComments.currentPage + 1);
      newComments.data = postComments.data + newComments.data;
      postComments = newComments;
      isFatchingMore = false;
    } else {
      postComments = await PostService.getPostComments(postID);
    }
    isLoading = false;
    isMoreEnabled = postComments.currentPage != postComments.lastPage;
    notifyListeners();
  }

  void resetLoader() {
    if (!isLoading) {
      isLoading = true;
      isMoreEnabled = true;
      isFatchingMore = false;
      notifyListeners();
    }
  }

  void fetchMore(int postID) {
    getPostComments(postID, isLoadMore: true);
  }

  Future<bool> postComment(int postId, String comment) async {
    Map<String, dynamic> data = {'post_id': postId, 'comment': comment};
    var result = await PostService.setPostComment(data);
    if (result != null) {
      postComments.data.insert(0, result);
      notifyListeners();
      return true;
    }
    showToast(message: 'Something went wrong');
    return false;
  }
}

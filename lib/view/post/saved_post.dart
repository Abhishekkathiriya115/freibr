import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freibr/common/widget/FRIconButton.dart';
import 'package:freibr/common/widget/FRUserListTile.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/post.dart';
import 'package:freibr/core/controller/saved_post.dart';
import 'package:freibr/core/model/post/post_comment.dart';
import 'package:freibr/core/model/post/post_model.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/post/post_comment.dart';
import 'package:freibr/view/post/post_picker.dart';
import 'package:freibr/view/timeline/profile/profile.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class SavedPost extends StatelessWidget {
  SavedPost({Key key, this.user, this.isMe = false}) : super(key: key);
  int pageSize = 3;
  final UserModel user;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    SavedPostController controller = Provider.of(context);
    void getPosts({bool isRefresh = false}) {
      controller.getPosts(controller.postPagingController.page, pageSize,
          isRefresh: isRefresh);
    }

    Widget buildPostItem(PostModel postItem, int index) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: <Widget>[
              FRUserListTile(
                user: postItem.user,
                onTrailingTap: null,
                onTap: () => Get.to(() => Profile(
                      user: postItem.user,
                    )),
              ),
              InkWell(
                onDoubleTap: () => print('Like post'),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => ViewPostScreen(
                  //       post: posts[index],
                  //     ),
                  //   ),
                  // );
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: 400.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: getProgressiveImage(
                      postItem.postMedia.first.mediaUrl,
                      postItem.postMedia.first.mediaUrl,
                      width: 100.h,
                      height: 100.h,
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 100.w,
                child: Text(
                  postItem.description.toString(),
                  maxLines: 3,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FRIconButton(
                          icon: postItem.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          text: postItem.totalLikes.toString(),
                          onPressed: () {
                            !postItem.isLiked
                                ? controller.setLike(index)
                                : controller.setDislike(index);
                          },
                        ),
                        SizedBox(width: 10.0),
                        FRIconButton(
                          icon: Icons.chat,
                          text: postItem.totalComments.toString(),
                          onPressed: () {
                            PostController controller = Provider.of(context, listen: false);
                            Get.to(PostCommentView(
                                post: postItem,
                                index: index,
                                postController: controller));
                          },
                        ),
                        // SizedBox(width: 10.0),
                        // FRIconButton(
                        //   icon: Icons.share_outlined,
                        //   text: '0',
                        // ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(postItem.isSaved
                          ? Icons.bookmark
                          : Icons.bookmark_border),
                      // iconSize: 30.0,
                      onPressed: () {
                        postItem.isSaved
                            ? controller.bookmarkRemove(postItem.id, index)
                            : controller.bookmarkAdd(
                                postItem.id, postItem.user.id, index);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return StatefulWrapper(
      onInit: () => Future.delayed(Duration.zero, () {
        controller.postPagingController.clearItems(clearItems: true);
        getPosts(isRefresh: true);
      }),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Saved posts',
                style: Get.theme.textTheme.subtitle1.copyWith(fontSize: 14.sp)),
            actions: [
              isMe
                  ? IconButton(
                      onPressed: () {
                        Get.to(() => PostPicker());
                      },
                      icon: Icon(FontAwesome.plus_square_o),
                      iconSize: 24.sp,
                    )
                  : Container()
            ],
          ),
          body: Container(
            child: SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              controller: controller.postPagingController.refreshController,
              onLoading: () {
                getPosts();
              },
              child: ListView.separated(
                padding: EdgeInsets.all(0.0),
                itemBuilder: (c, index) {
                  return buildPostItem(
                      controller.postPagingController.items[index], index);
                },
                // itemExtent: 100.0,
                itemCount: controller.postPagingController.items.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
              ),
            ),
          )),
    );
  }
}

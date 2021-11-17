import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FRCommentListTile.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/post.dart';
import 'package:freibr/core/controller/post_comments.dart';
import 'package:freibr/core/model/post/post_comment.dart';
import 'package:freibr/core/model/post/post_model.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PostCommentView extends StatelessWidget {
  final PostModel post;
  final PostComment comment;
  final int index;
  ScrollController _scrollController;
  PostCommentsController _controller;
  PostController postController;
  TextEditingController _textEditingController;

  PostCommentView({Key key, this.post, this.index, this.postController,this.comment})
      : super(key: key);

  void fetchMore() {
    if (_scrollController.position.maxScrollExtent - _scrollController.offset <
        50) {
      if (_controller.isMoreEnabled && !_controller.isFatchingMore) {
        _controller.fetchMore(post.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<PostCommentsController>(context);
    return StatefulWrapper(
        onInit: () {
          _scrollController = ScrollController();
          _textEditingController = TextEditingController();
          _controller.getPostComments(this.post.id);
          _scrollController.addListener(fetchMore);
          Future.microtask(() => _controller.resetLoader());
        },
        dispose: dispose,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                '${post.user.name} comments',
                overflow: TextOverflow.ellipsis,
                style: Get.theme.textTheme.subtitle1.copyWith(fontSize: 14.sp),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                    visible: _controller.isLoading,
                    child: Center(child: frCircularLoader())),
                Visibility(
                    visible: !_controller.isLoading &&
                        _controller.postComments.data.length <= 0,
                    child: Expanded(
                      child: FREmptyScreen(
                        imageSrc: noMessage,
                        title: 'Nothing to show',
                        onTap: () {
                          _controller.getPostComments(this.post.id);
                        },
                      ),
                    )),
                Expanded(
                  child: Visibility(
                    visible: !_controller.isLoading &&
                        _controller.postComments.data.length > 0,
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _controller.postComments.data != null
                            ? _controller.isMoreEnabled
                                ? _controller.postComments.data.length + 1
                                : _controller.postComments.data.length
                            : 0,
                        itemBuilder: (context, index) {
                          if (_controller.isMoreEnabled &&
                              _controller.postComments.data.length == index) {
                            return Center(
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: frCircularLoader(
                                        height: 30, width: 30)));
                          }
                          return        Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {
                               _controller.commentDelete(post.id,_controller.postComments.data[index].id);
                              }),
                              children: const [
                                SlidableAction(
                                  onPressed: null,
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            endActionPane: const ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: null,
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: (){
                              },
                              child: FRUserListCommentTile(
                                user: _controller.postComments.data[index].user,
                                title: RichText(
                                  text: TextSpan(
                                    text:
                                    '${_controller.postComments.data[index].user.name} ',
                                    style: Get.textTheme.button,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: _controller
                                            .postComments.data[index].comment,
                                        style: Get.textTheme.bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.8),
                      child: FRTextField(
                        maxLines: 1,
                        textEditingController: _textEditingController,
                        prefixIcon: IconButton(
                          onPressed: () async {
                            if (_textEditingController.value.text != '') {
                              bool flag = await _controller.postComment(
                                  post.id, _textEditingController.value.text);
                              if (flag) {
                                _scrollController.animateTo(0,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastOutSlowIn);
                                postController.updatetotalComments(index);
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                _textEditingController.clear();
                              }
                            }
                          },
                          icon: Icon(Icons.send),
                        ),
                        height: 40,
                        hintText: 'Add comment',
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            )));
  }

  void dispose() {
    _scrollController.dispose();
  }
}

 void doNothing(BuildContext context) {

}
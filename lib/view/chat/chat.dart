import 'package:flutter/material.dart';
import 'package:freibr/common/images.dart';
import 'package:freibr/common/widget/FREmpty.dart';
import 'package:freibr/common/widget/FRUserListTile.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/chat/common/single.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:freibr/core/controller/chat.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:freibr/view/chat/common/group.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  int pageSize = 15;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Provider.of(context);

    void getGroupChat({bool isRefresh = false}) {
      chatController.getPagedGroupChats(
          chatController.groupPagingController.page, pageSize,
          isRefresh: isRefresh);
    }

    void getPagedPersonalChatUser({bool isRefresh = false}) {
      chatController.getPagedPersonalChatUser(
          chatController.personalPagingController.page, pageSize,
          isRefresh: isRefresh);
    }

    void showDeleteDialog(senderID, receiverID) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text("Delete chat"),
              content: new Text("Are you sure?"),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel"),
                ),
                MaterialButton(
                  onPressed: () async {
                    await chatController.deleteChatUser(senderID, receiverID);
                  },
                  color: Get.theme.accentColor,
                  child: Text("Yes"),
                )
              ],
            );
          });
    }

    return StatefulWrapper(
      onInit: () {
        Future.delayed(Duration.zero, () {
          chatController.groupPagingController.clearItems();
          getGroupChat();

          chatController.personalPagingController.clearItems();
          getPagedPersonalChatUser();
        });
      },
      dispose: () {},
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: TabBar(
              onTap: (index) {
                setState(() {
                  _index = index;
                });
              },
              tabs: [
                Tab(
                  text: "General",
                ),
                Tab(
                  text: "Chatroom",
                ),
              ],
            ),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
            child: _index == 0
                ? SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    controller: chatController
                        .personalPagingController.refreshController,
                    onLoading: () {
                      getPagedPersonalChatUser();
                    },
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Text("pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = frCircularLoader(height: 20, width: 20);
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("release to load more");
                        } else {
                          body = Container();
                        }
                        return Container(
                          height: mode == LoadStatus.noMore ? 0 : 55,
                          child: Center(child: body),
                        );
                      },
                    ),
                    child: !chatController.personalPagingController.hasData &&
                            !chatController
                                .personalPagingController.isFirstLoad.value
                        ? FREmptyScreen(
                            imageSrc: noMessage,
                            title: 'Nothing to show',
                            onTap: () {
                              getGroupChat(isRefresh: true);
                            },
                          )
                        : chatController.personalPagingController.isFirstLoad
                                    .value &&
                                !chatController.personalPagingController.hasData
                            ? Center(child: frCircularLoader())
                            : ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(height: 0),
                                itemBuilder: (c, index) {
                                  if (chatController.personalPagingController
                                          .items.length >
                                      0) {
                                    var item = chatController
                                        .personalPagingController.items[index];

                                    if (item.senderID !=
                                        chatController
                                            .authController.authUser.id) {}

                                    return FRUserListTile(
                                        subtitle: item.messageType == 'offer'
                                            ? 'Offer'
                                            : item.message,
                                        onLongPress: showDeleteDialog,
                                        onTap: () {
                                          Get.to(() => SingleChat(
                                                user: item.senderID !=
                                                        chatController
                                                            .authController
                                                            .authUser
                                                            .id
                                                    ? item.sender
                                                    : item.receiver,
                                              ));
                                        },
                                        user: item.senderID !=
                                                chatController
                                                    .authController.authUser.id
                                            ? item.sender
                                            : item.receiver,
                                        senderID: item.senderID,
                                        receiverID: item.receiverID);
                                  }
                                  return Container();
                                },
                                itemCount: chatController
                                    .personalPagingController.items.length,
                              ),
                  )
                : SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    controller:
                        chatController.groupPagingController.refreshController,
                    onLoading: () {
                      getGroupChat();
                    },
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Text("pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = frCircularLoader(height: 20, width: 20);
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("release to load more");
                        } else {
                          body = Container();
                        }
                        return Container(
                          height: mode == LoadStatus.noMore ? 0 : 55,
                          child: Center(child: body),
                        );
                      },
                    ),
                    child: !chatController.groupPagingController.hasData &&
                            !chatController
                                .groupPagingController.isFirstLoad.value
                        ? FREmptyScreen(
                            imageSrc: noMessage,
                            title: 'Nothing to show',
                            onTap: () {
                              getGroupChat(isRefresh: true);
                            },
                          )
                        : chatController
                                    .groupPagingController.isFirstLoad.value &&
                                !chatController.groupPagingController.hasData
                            ? Center(child: frCircularLoader())
                            : ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(height: 25),
                                itemBuilder: (c, index) {
                                  if (chatController
                                          .groupPagingController.items.length >
                                      0) {
                                    var item = chatController
                                        .groupPagingController.items[index];

                                    return FRUserListTile(
                                        onTap: () {
                                          Get.to(() => GroupChat(room: item));
                                        },
                                        user: item.host);
                                  }
                                  return Container();
                                },
                                itemCount: chatController
                                    .groupPagingController.items.length,
                              ),
                  ),
          ),
          // bottomNavigationBar: FRBottomNavigation()
        ),
      ),
    );
  }
}

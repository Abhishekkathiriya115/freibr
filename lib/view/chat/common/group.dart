import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/model/chat/chat.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/core/controller/chat.dart';
import 'package:freibr/view/chat/common/group/message_card.dart';
import 'package:freibr/view/chat/common/group/reply_card.dart';
import 'package:freibr/util/extension.dart';

// ignore: must_be_immutable
class GroupChat extends StatelessWidget {
  GroupChat({Key key, this.room}) : super(key: key);
  final GroupChatModel room;
  int pageSize = 15;

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Provider.of(context);
    ThemeData theme = Get.theme;
    ScrollController _scrollController = ScrollController();

    void getGroupChat({bool isRefresh = false}) {
      chatController.getGroupMessages(room.roomId.toString(),
          chatController.groupMessagePagingController.page, pageSize,
          isRefresh: isRefresh);
    }

    return StatefulWrapper(
        onInit: () {
          Future.delayed(Duration.zero, () {
            chatController.groupMessagePagingController.clearItems();
            getGroupChat();
          });
        },
        child: Scaffold(
          // appBar: AppBar(
          //     title: Text('${room.host.name.capitalize} chatroom'.capitalize,
          //         style:
          //             Get.theme.textTheme.subtitle1.copyWith(fontSize: 10.sp)),
          //     leading: IconButton(
          //       icon: Icon(Icons.close),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //     )),

          appBar: AppBar(
              backgroundColor: theme.accentColor,
              leadingWidth: 70,
              title: Container(
                margin: EdgeInsets.all(5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.host.name,
                        style: theme.textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 11.sp),
                      ),
                      // Text('Last seen today at 12:05',
                      //     style:
                      //         theme.textTheme.bodyText1.copyWith(fontSize: 9.sp)),
                      !room.host.profileName.isNullOrEmpty()
                          ? Text(room.host.profileName,
                              style: theme.textTheme.bodyText1
                                  .copyWith(fontSize: 9.sp))
                          : Container()
                    ]),
              ),
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, size: 24),
                    ClipOval(
                        child:
                            getProgressiveNoUserAvatar(height: 36, width: 36))
                  ],
                ),
              )),
          body: Container(
            height: Get.size.height,
            width: Get.size.width,
            // color: Colors.blueGrey,
            child: Stack(children: [
              Container(
                height: Get.size.height - 145,
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount:
                      chatController.groupMessagePagingController.items.length +
                          1,
                  itemBuilder: (context, index) {
                    if (index ==
                        chatController
                            .groupMessagePagingController.items.length) {
                      return Container(
                        height: 70,
                      );
                    }
                    if (chatController.groupMessagePagingController.items[index]
                            .otherUserId ==
                        chatController.authController.authUser.id) {
                      return MessageCard(
                        model: chatController
                            .groupMessagePagingController.items[index],
                      );
                    } else {
                      return ReplyCard(
                        model: chatController
                            .groupMessagePagingController.items[index],
                      );
                    }
                  },
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: chatController.authController.authUser.id == room.id
                      ? Row(
                          children: [
                            Container(
                              width: Get.width - 60,
                              child: Card(
                                  margin: EdgeInsets.only(
                                      left: 4, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Theme(
                                    data: Get.theme.copyWith(
                                      // override textfield's icon color when selected
                                      accentColor: Get.theme.iconTheme.color,
                                    ),
                                    child: TextFormField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 5,
                                      minLines: 1,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(10),
                                          prefixIcon: IconButton(
                                            icon: Icon(Icons.emoji_emotions),
                                            onPressed: () {},
                                          ),
                                          suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // IconButton(
                                                //   icon: Icon(Icons.attach_file),
                                                //   onPressed: () {},
                                                // ),
                                                // IconButton(
                                                //   icon: Icon(Icons.camera_alt),
                                                //   onPressed: () {},
                                                // )
                                              ]),
                                          hintText: 'Type a message'),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: 8, left: 5, right: 2),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: theme.accentColor,
                                child: IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {},
                                  iconSize: 22,
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.all(10),
                          width: Get.size.width,
                          color: theme.primaryColorDark,
                          child: Text(
                            'Only presenter can send message',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyText1
                                .copyWith(fontSize: 9.sp),
                          )))
            ]),
          ),
        ));
  }
}

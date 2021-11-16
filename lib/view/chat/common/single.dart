import 'package:flutter/material.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/config/url.dart';
import 'package:freibr/core/controller/chat.dart';
import 'package:freibr/core/controller/custom_order.dart';
import 'package:freibr/core/model/chat/offer.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/chat/common/single/offer_card.dart';
import 'package:freibr/view/custom_offer/custom_offer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/view/chat/common/single/message_card.dart';
import 'package:freibr/view/chat/common/single/reply_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:freibr/core/model/chat/personal.dart';
import 'package:freibr/util/extension.dart';

// ignore: must_be_immutable
class SingleChat extends StatelessWidget {
  SingleChat({Key key, this.user}) : super(key: key);
  final UserModel user;
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  FocusNode focusNode = FocusNode();
  IO.Socket socket;
  bool sendBtn = false;
  int pageSize = 15;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Get.theme;
    ChatController chatController = Provider.of(context);
    CustomOrderController _customOrderController = Provider.of(context);

    void getChat({bool isRefresh = false}) {
      chatController.getPagedPersonalChat(
          chatController.personalChatMessageController.page, pageSize, user.id,
          isRefresh: isRefresh);
    }

    dynamic getModel(String message, int sourceID, int targetID) {
      PersonalChatModel personalMessage = PersonalChatModel();
      personalMessage.message = message;
      personalMessage.receiverID = targetID;
      personalMessage.senderID = sourceID;
      personalMessage.messageType = 'text';
      personalMessage.createdAt = DateTime.now();
      personalMessage.updatedAt = DateTime.now();
      personalMessage.offerStatus =
          OfferModel(offerStatus: OfferStatus.PENDING);
      return personalMessage.toJson();
    }

    void setMessage(dynamic param) {
      print(param);
      chatController.addPersonalMessage(PersonalChatModel.fromJson(param));
    }

    void connectToServer() {
      socket = IO.io('${UrlDto.socketUrl}', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();
      socket.emit('join-chat', chatController.authController.authUser.id);
      socket.onConnect((data) {
        print('connected');
      });
      socket.on("personal-message", (res) {
        print("received message");
        print(res);
        Map result = res['result'];
        result['id'] = res['insertId'];
        setMessage(result);
        // _scrollController.animateTo(
        //     _scrollController.position.maxScrollExtent,
        //     duration: Duration(milliseconds: 300),
        //     curve: Curves.easeOut);
      });
      socket.onDisconnect((_) => print("disconnected"));
    }

    void sendMessage(String message, int sourceID, int targetID) {
      var model = getModel(message, sourceID, targetID);
      setMessage(model);
      socket.emit('message', {"message": message, "param": model});
    }

    return StatefulWrapper(
      onInit: () {
        connectToServer();

        Future.delayed(Duration.zero, () {
          chatController.personalChatMessageController.clearItems();
          getChat();
        });
      },
      dispose: () {
        socket.clearListeners();
        socket.disconnect();
      },
      child: Scaffold(
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
                      user.name,
                      style: theme.textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 11.sp),
                    ),
                    // Text('Last seen today at 12:05',
                    //     style:
                    //         theme.textTheme.bodyText1.copyWith(fontSize: 9.sp)),
                    !user.profileName.isNullOrEmpty()
                        ? Text(user.profileName,
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
                      child: user != null
                          ? getProgressiveImage(
                              user?.thumbnailAvatar, user?.avatar,
                              height: 36, width: 36)
                          : getProgressiveNoUserAvatar(height: 36, width: 36))
                ],
              ),
            )),
        body: Column(children: [
          Flexible(
            // height: Get.size.height,
            child: ListView.builder(
              reverse: true,
              // shrinkWrap: true,
              controller: _scrollController,
              itemCount:
                  chatController.personalChatMessageController.items.length + 1,
              itemBuilder: (context, index) {
                if (index ==
                    chatController.personalChatMessageController.items.length) {
                  return Container(
                    height: 70,
                  );
                }

                if (chatController
                        .personalChatMessageController.items[index].senderID ==
                    chatController.authController.authUser.id) {
                  // Check if meesage if an offer
                  if (chatController.personalChatMessageController.items[index]
                          .messageType ==
                      'offer') {
                    return OfferCard(
                        chatController: chatController,
                        index: index,
                        model: chatController
                            .personalChatMessageController.items[index],
                        user: user);
                  }

                  return MessageCard(
                    model: chatController
                        .personalChatMessageController.items[index],
                  );
                } else {
                  // Check if reply if an offer
                  if (chatController.personalChatMessageController.items[index]
                          .messageType ==
                      'offer') {
                    return OfferCard(
                        chatController: chatController,
                        index: index,
                        model: chatController
                            .personalChatMessageController.items[index],
                        isReply: true,
                        user: user);
                  }

                  return ReplyCard(
                    model: chatController
                        .personalChatMessageController.items[index],
                  );
                }
              },
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  width: Get.width - 60,
                  child: Card(
                      margin: EdgeInsets.only(left: 4, right: 2, bottom: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Theme(
                        data: Get.theme.copyWith(
                          // override textfield's icon color when selected
                          accentColor: Get.theme.iconTheme.color,
                        ),
                        child: TextFormField(
                          controller: _controller,
                          focusNode: focusNode,
                          textAlignVertical: TextAlignVertical.center,
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
                  padding: EdgeInsets.only(bottom: 8, left: 5, right: 2),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: theme.accentColor,
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_controller.text != '') {
                          sendMessage(
                              _controller.text,
                              chatController.authController.authUser.id,
                              user.id);
                          _controller.clear();
                        }
                      },
                      iconSize: 22,
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.8),
                child: Text(
                  "Create an offer",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                _customOrderController.modifyModel();
                Get.to(() => CustomOffer(
                    user: user,
                    socket: socket,
                    authUserId: chatController.authController.authUser.id,
                    userId: user.id));
              },
            ),
          ),
        ]),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/model/chat/chat.dart';
import 'package:freibr/core/model/chat/offer.dart';
import 'package:freibr/core/model/chat/personal.dart';
import 'package:freibr/core/service/chat.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/chat/common/single/offer_card.dart';
import 'package:get/get.dart';
import 'paging/paging.dart';

class ChatController extends ChangeNotifier {
  final AuthenticationController authController;

  PagingController<GroupChatModel> groupPagingController =
      new PagingController(initialRefreshParam: false);

  PagingController<GroupChatModel> groupMessagePagingController =
      new PagingController(initialRefreshParam: false);

  PagingController<PersonalChatModel> personalPagingController =
      new PagingController(initialRefreshParam: false);

  PagingController<PersonalChatModel> personalChatMessageController =
      new PagingController(initialRefreshParam: false);

  // List<PersonalChatModel> _personalMessages = [];
  // List<PersonalChatModel> get personalMessages => _personalMessages;

  ChatController({this.authController}) {
    if (this.authController != null) {}
  }

  Future<void> getPagedGroupChats(dynamic page, dynamic pageSize,
      {bool isRefresh = false}) async {
    try {
      var result = await ChatService.getPagedGroupChats(
          page.toString(), pageSize.toString());
      if (result != null) {
        groupPagingController.addItems(result.data);
        groupPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } finally {}
    notifyListeners();
  }

  Future<void> getGroupMessages(String roomID, dynamic page, dynamic pageSize,
      {bool isRefresh = false}) async {
    try {
      var result = await ChatService.getGroupMessages(
          roomID, page.toString(), pageSize.toString());
      if (result != null) {
        groupMessagePagingController.addItems(result.data);
        groupMessagePagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } catch (e) {
      print(e);
    } finally {}
    notifyListeners();
  }

  Future<void> getPagedPersonalChatUser(dynamic page, dynamic pageSize,
      {bool isRefresh = false}) async {
    try {
      var result = await ChatService.getPagedPersonalChatUser(
          page.toString(), pageSize.toString());
      if (result != null) {
        personalPagingController.addItems(result.data);
        personalPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } finally {}
    notifyListeners();
  }

  Future<void> getPagedPersonalChat(
      dynamic page, dynamic pageSize, dynamic otherUserID,
      {bool isRefresh = false}) async {
    try {
      var result = await ChatService.getPagedPersonalChat(
          page.toString(), pageSize.toString(), otherUserID.toString());
      if (result != null) {
        personalChatMessageController.addItems(result.data);
        personalChatMessageController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } finally {}
    notifyListeners();
  }

  void addPersonalMessage(PersonalChatModel param) {
    personalChatMessageController.items.insert(0, param);
    notifyListeners();
  }

  void updateOfferStatus(int index, status) {
    personalChatMessageController.items[index].offerStatus.offerStatus = status;
    notifyListeners();
  }

  Future<void> deleteChatUser(senderID, receiverID, {onRefreshChat}) async {
    Get.back();
    try {
      showLoadingDialog();
      var result = await ChatService.deleteChatUser(senderID, receiverID);
      if (result['status']) {
        personalPagingController.clearItems();
        await getPagedPersonalChatUser(1, 15);
        showToast(message: result['message']);
      } else {
        showToast(message: result['message']);
      }
    } catch (e) {
      print(e);
      dismissDialogToast();
    }
    notifyListeners();
  }
}

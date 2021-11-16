import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freibr/core/controller/paging/paging.dart';
import 'package:freibr/core/model/notification_model.dart';
import 'package:freibr/core/service/timeline.dart';

class NotificationController extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;
  bool _hasNotification = false;
  bool get hasNotification => _hasNotification;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

 PagingController<NotificationModel> notificationsPagingController =
      new PagingController(initialRefreshParam: false);

  void registerNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');

      this.addNotification(message);
      if (message.notification != null) {
        print('Message also contained a notification');
        // print(json.encode(message.notification));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message on message open app');
      // print('Message data: ${message.data}');

      this.addNotification(message);
      if (message.notification != null) {
        // print('Message also contained a notification');
        // print(message.notification.title);
        // print(message.notification.body);
      }
    });
  }

  Future<void> addNotification(RemoteMessage param) async {
    var temp = json.decode(param.data['body']);
    _notifications.add(NotificationModel.fromJson(temp));
    setNotificationStatus(true);
    notifyListeners();
  }

  Future<void> removeNotification(int index) async {
    notificationsPagingController.items.removeAt(index);
    notifyListeners();
  }

  Future<void> updateNotification(int index, String status) async {
    notificationsPagingController.items[index].follower.status = status;
    notifyListeners();
  }

  Future<void> getPagedNotifications(var page, var pageSize,
      {bool isRefresh = false}) async {
    try {
      var result = await TimelineService.getPagedNotifications(
          page.toString(), pageSize.toString());
      if (result != null) {
        notificationsPagingController.addItems(result.data);
        notificationsPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } finally {}
    notifyListeners();
  }

  Future<void> setNotificationStatus(bool param) async {
    this._hasNotification = param;
  }
}

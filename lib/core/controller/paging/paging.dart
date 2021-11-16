import 'package:flutter/cupertino.dart';
import 'package:freibr/core/model/post/post_model.dart';
import 'package:freibr/core/service/post.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PagingController<T> with ChangeNotifier {
  bool initialRefresh = false;
  RefreshController refreshController;
  ValueNotifier<int> _page = ValueNotifier(1);
  int get page => _page.value;
  int get pageSize => 8;
  // List<T> items =  [];
  ValueNotifier<List<T>> _items = ValueNotifier([]);

  PagingController({bool initialRefreshParam = false}) {
    this.initialRefresh = initialRefreshParam;
    refreshController =
        new RefreshController(initialRefresh: this.initialRefresh);
  }

  List<T> get items => _items.value;
  bool get hasData => _items.value.length > 0;
  ValueNotifier<bool> isFirstLoad = ValueNotifier(false);
  // bool get isFirstLoad => _isFirstLoad.value;

  clearItems({bool clearItems = true}) {
    this._page.value = 1;
    isFirstLoad.value = true;
    if (clearItems) {
      this._items = ValueNotifier([]);
    }
    isFirstLoad.notifyListeners();
  }

  void addItems(List<T> items) {
    this._items.value.addAll(items);
  }

  void addItem(T items) {
    this._items.value.add(items);
  }

  void finishRefreshLoad({bool noMore = false, bool isRefresh = false}) {
    //  refreshController = new RefreshController(initialRefresh:  false);
    if (isRefresh) {
      this.refreshController.refreshCompleted();
    }
    if (noMore) {
      this.refreshController.loadNoData();
    } else {
      this.refreshController.loadComplete();
    }
    isFirstLoad.value = false;
    this._page.value++;
    isFirstLoad.notifyListeners();
  }

  void resetList() {
    _items.value = [];
  }
}

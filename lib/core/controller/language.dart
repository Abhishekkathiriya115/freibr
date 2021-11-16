import 'package:flutter/cupertino.dart';
import 'package:freibr/core/controller/paging/paging.dart';
import 'package:freibr/core/model/language.dart';
import 'package:freibr/core/service/language.dart';

class LanguageController extends ChangeNotifier {
  List<LanguageModel> _choosenLanguages = [];
  List<LanguageModel> get choosenLanguages => _choosenLanguages;
  PagingController<LanguageModel> languagePagingController =
      new PagingController(initialRefreshParam: false);
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getPagedLanguages(var page, var pageSize, String queryParam,
      {bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        setLoader(true);
      }
      var result = await LanguageService.getPagedLanguages(
          page.toString(), pageSize.toString(), queryParam);
      if (result != null) {
        languagePagingController.addItems(result.data);
        languagePagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } finally {
      setLoader(false);
    }
    notifyListeners();
  }

  Future<void> addChoosenItem(LanguageModel param) async {
    _choosenLanguages.add(param);
    notifyListeners();
  }

  Future<void> addChoosenItemBulk(List<LanguageModel> param) async {
    _choosenLanguages.addAll(param);
    notifyListeners();
  }

  Future<void> removeChoosenItem(LanguageModel param) async {
    var isExist = _choosenLanguages.indexWhere((p) => p.id == param.id);
    _choosenLanguages.removeAt(isExist);
    notifyListeners();
  }

  bool isExistChoosenItem(LanguageModel param) {
    var isExist = _choosenLanguages.indexWhere((p) => p.id == param.id);
    if (isExist != -1) {
      return true;
    }
    return false;
  }

  Future<void> setLoader(bool status) async {
    this._isLoading = status;
    // notifyListeners();
  }
}

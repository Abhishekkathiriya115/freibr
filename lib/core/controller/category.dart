import 'package:flutter/cupertino.dart';
import 'package:freibr/core/controller/paging/paging.dart';
import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/service/category.dart';

class CategoryController extends ChangeNotifier {
  List<CategoryModel> _choosenCategories = [];
  List<CategoryModel> get choosenCategories => _choosenCategories;
  PagingController<CategoryModel> categoryPagingController =
      new PagingController(initialRefreshParam: false);
  PagingController<CategoryModel> subCategoryPagingController =
      new PagingController(initialRefreshParam: false);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getCategories(var page, var pageSize, String queryParam,
      {bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        setLoader(true);
      }
      var result = await CategoryService.getCategories(
          page.toString(), pageSize.toString(), queryParam);
      if (result != null) {
        categoryPagingController.addItems(result.data);
        categoryPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } catch (expection) {}
    notifyListeners();
  }

  Future<void> getSubcategories(
      var page, var pageSize, CategoryModel category, String queryParam,
      {bool isRefresh = false}) async {
    try {
      
      var result = await CategoryService.getCategoriesWithParent(
          page.toString(), pageSize.toString(), category, queryParam);

      if (result != null) {
        subCategoryPagingController.addItems(result.data);
        subCategoryPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } finally {}
    notifyListeners();
  }

  bool isExistChoosenItem(CategoryModel param) {
    var isExist = _choosenCategories.indexWhere((p) => p.id == param.id);
    if (isExist != -1) {
      return true;
    }
    return false;
  }

  Future<void> addChoosenItemBulk(List<CategoryModel> param) async {
    _choosenCategories = [];
    _choosenCategories.addAll(param);
    notifyListeners();
  }

  Future<void> addChoosenItem(CategoryModel param) async {
    _choosenCategories.add(param);
    notifyListeners();
  }

  Future<void> removeChoosenItem(CategoryModel param) async {
    var isExist = choosenCategories.indexWhere((p) => p.id == param.id);
    _choosenCategories.removeAt(isExist);
    notifyListeners();
  }

  Future<void> setLoader(bool status) async {
    this._isLoading = status;
    // notifyListeners();
  }
}

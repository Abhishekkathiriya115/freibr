import 'package:flutter/cupertino.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/controller/paging/paging.dart';
import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/model/gig/faq.dart';
import 'package:freibr/core/model/gig/gig.dart';
import 'package:freibr/core/model/gig/gig_media.dart';
import 'package:freibr/core/service/gig.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/util/extension.dart';
import 'package:freibr/view/gig/faq.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../service/gig.dart';

class GigController extends ChangeNotifier {
  final AuthenticationController authController;

  List<CategoryModel> _choosenCategories = [];
  List<CategoryModel> get choosenCategories => _choosenCategories;

  List<String> _choosenTags = [];
  List<String> get choosenTags => _choosenTags;

  bool _isEdited = false;
  bool get isEdited => _isEdited;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GigModel _gigModel = new GigModel();
  GigModel get gig => _gigModel;

  bool _isEnabledMore = false;
  bool get isEnabledMore => _isEnabledMore;

  void resetState() {
    _isEnabledMore = false;
  }

  PagingController<GigModel> gigPagingController =
      new PagingController(initialRefreshParam: false);

  GigController({this.authController}) {
    if (this.authController != null) {}
  }

  Future<void> getGigs(dynamic page, dynamic pageSize,
      {bool isRefresh = false}) async {
    try {
      var result = await GigService.getPagedGigs(page, pageSize);
      if (result != null) {
        _isEnabledMore = result.currentPage != result.lastPage;
        gigPagingController.addItems(result.data);
        gigPagingController.finishRefreshLoad(
            isRefresh: isRefresh, noMore: result.isLastPage);
      }
    } catch (e) {} finally {}
    notifyListeners();
  }

  Future<void> saveGig() async {
    try {
      showLoadingDialog();
      var result = await GigService.saveGig(this._gigModel);
      if (result != null && result['status']) {
        this._gigModel = GigModel.fromJson(result['data']);
        notifyListeners();
        showToast(message: result["message"]);
        Get.to(() => GigFaq());
      }
    } finally {
      dismissDialogToast();
    }
  }

  Future<void> editGig() async {
    try {
      showLoadingDialog();
      var result = await GigService.editGig(this._gigModel);
      if (result != null && result['status']) {
        this._gigModel = GigModel.fromJson(result['data']);
        print(_gigModel.faqs);
        notifyListeners();
        showToast(message: result["message"]);
        Get.to(() => GigFaq());
      }
    } finally {
      dismissDialogToast();
    }
  }

  Future<void> addGigFaq(GigFaqModel param) async {
    try {
      showLoadingDialog();
      var result = await GigService.saveFaq(param);
      if (result != null && result['status']) {
        _gigModel.faqs = _gigModel.faqs ?? [];
        var tempParam = GigFaqModel.fromJson(result['data']);
        _gigModel.faqs.add(tempParam);
        Get.back();
        showToast(message: result["message"]);
      }
    } finally {
      dismissDialogToast();
    }
    notifyListeners();
  }

  Future<void> removeGigFaq(int index, GigFaqModel param) async {
    try {
      var result = await GigService.removeFAQ(param);
      if (result != null) {
        if (result['status']) {
          this._gigModel.faqs.removeAt(index);
          notifyListeners();
        }
      }
    } finally {}
  }

  Future<void> addGigQuestion(GigFaqModel param) async {
    try {
      showLoadingDialog();
      var result = await GigService.saveQuestion(param);
      if (result != null && result['status']) {
        _gigModel.gigAskedQuestions = _gigModel.gigAskedQuestions ?? [];
        var tempParam = GigFaqModel.fromJson(result['data']);
        _gigModel.gigAskedQuestions.add(tempParam);
        Get.back();
        showToast(message: result["message"]);
      }
    } finally {
      dismissDialogToast();
    }
    notifyListeners();
  }

  Future<void> removeQuestion(int index, GigFaqModel param) async {
    try {
      var result = await GigService.removeQuestion(param);
      if (result != null) {
        if (result['status']) {
          this._gigModel.gigAskedQuestions.removeAt(index);
          notifyListeners();
        }
      }
    } finally {}
  }

  void modifyGigModel(GigModel param) {
    this._gigModel = param;
    this._choosenCategories = param.gigCategories;
    this._choosenTags =
        !param.tags.isNullOrEmpty() ? param.tags.split(",") : [];
    notifyListeners();
  }

  Future<void> addNewTag(String param) async {
    _choosenTags.add(param);
    notifyListeners();
  }

  Future<void> removeTag(String param) async {
    var isExist = _choosenTags.indexWhere((p) => p == param);
    _choosenTags.removeAt(isExist);
    notifyListeners();
  }

  Future<void> saveGalleryFile(PickedFile param) async {
    try {
      // var result =
      //     await GigService.saveGalleryFile(param, this._gigModel.id.toString());
      var result = await GigService.saveGalleryFile(param, "15");
      if (result != null) {
        _gigModel.gigMedia = _gigModel.gigMedia ?? [];
        var tempParam = GigMediaModel.fromJson(result);
        _gigModel.gigMedia.add(tempParam);
      }
    } finally {}
    notifyListeners();
  }

  Future<void> removeGalleryFile(int index, GigMediaModel param) async {
    try {
      var result = await GigService.removeGalleryFile(param);
      if (result != null) {
        if (result['status']) {
          this._gigModel.gigMedia.removeAt(index);
          notifyListeners();
        }
      }
    } finally {}
  }

  Future<void> addChoosenCategoriesBulk(List<CategoryModel> param) async {
    _choosenCategories = [];
    _choosenCategories.addAll(param);
    notifyListeners();
  }

  Future<void> resetCategories(List<CategoryModel> param) async {
    _choosenCategories.clear();
    _choosenCategories.addAll(param);
    notifyListeners();
  }

  Future<void> removeChoosenCategory(CategoryModel param) async {
    var isExist = choosenCategories.indexWhere((p) => p.id == param.id);
    if (isExist > 0) {
      GigService.removeCategory(param);
      _choosenCategories.removeAt(isExist);
      notifyListeners();
    }
  }

  void setIsEdited(bool param) {
    this._isEdited = param;
    notifyListeners();
  }
}

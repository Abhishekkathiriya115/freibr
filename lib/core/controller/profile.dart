import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:freibr/core/app_preferences.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/model/language.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/model/user/user_expertise.dart';
import 'package:freibr/core/service/profile.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends ChangeNotifier {
  bool isUploadingImage = false;
  bool isEdited = false;
  bool isLoading = false;
  bool _isLoadingProfile = false;
  bool get isLoadingProfile => _isLoadingProfile;

  UserModel _user;
  UserModel get user => _user;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  List<CategoryModel> _choosenCategories = [];
  List<CategoryModel> get choosenCategories => _choosenCategories;

  final AuthenticationController authController;
  TextEditingController nameTextController = new TextEditingController();
  TextEditingController bioTextController = new TextEditingController();
  TextEditingController locationTextController = new TextEditingController();
  TextEditingController profileTextController = new TextEditingController();
  UserExpertise expertise = new UserExpertise();

  ProfileController({this.authController}) {
    if (this.authController != null) {
      setProfileUser(this.authController.authUser, isMe: true);
    }
  }

  Future<void> getUserProfile() async {
    setLoader(true);
    var result = await ProfileService.getProfile();
    if (result != null) {
      // this._user = result;
      this.setProfileUser(result, isMe: true);
      setLoader(false);
    }
    notifyListeners();
  }

  Future<void> getOtherUserProfile(String userID) async {
    setLoader(true);

    var result = await ProfileService.getOtherUserProfile(userID);
    if (result != null) {
      // this._user = result;
      this.setProfileUser(result, isMe: true);
      setLoader(false);
      print("notifying users");
      notifyListeners();
    }
  }

  Future<void> uploadProfileImage(PlatformFile param) async {
    try {
      isUploadingImage = true;
      var result = await ProfileService.changeProfilePic(param);
      if (result != null) {
        this.user.avatar = result["avatar"];
        this.user.thumbnailAvatar = result["thumbnail_avatar"];
        this.storeUserLocal(this.user);
      }
    } finally {
      isUploadingImage = false;
    }
    notifyListeners();
  }

  Future<void> uploadProfileImage1(PickedFile param) async {
    try {
      isUploadingImage = true;
      var result = await ProfileService.changeProfilePic1(param);
      if (result != null) {
        this.user.avatar = result["avatar"];
        this.user.thumbnailAvatar = result["thumbnail"];
        this.storeUserLocal(this.user);
      }
    } finally {
      isUploadingImage = false;
    }
    notifyListeners();
  }

  Future<String> uploadRoomPic(PickedFile param) async {
    try {
      var result = await ProfileService.changeRoomPic(param, (callbackData) {
        showProgressDialog(
            value: (callbackData / 100), message: 'uploading...');
      });
      if (result != null) {
        this.user.roomAvatar = result["avatar"];
        this.storeUserLocal(this.user);
        dismissDialogToast();
        notifyListeners();
        return result["avatar"];
      }
    } finally {}

    return null;
  }

  Future<void> updateProfile({bool isGoBack = true}) async {
    try {
      showLoadingDialog();
      var result = await ProfileService.updateUserProfile(user);

      if (result != null) {
        print(result);
        if (result['status']) {
          var tempUser = UserModel.fromJson(result['data']);
          this._user = tempUser;
          this.storeUserLocal(this.user);
          if (isGoBack) {
            showToast(message: result["message"]);
            Get.back();
          }
        }
      } else {
        showToast(message: result["message"]);
      }
    } finally {
      dismissDialogToast();
    }
  }

  void addExpertiseItem(UserExpertise param) {
    this.setIsEdited(true);
    this._user.userExpertises.add(param);
    notifyListeners();
  }

  void addLanguages(List<LanguageModel> param) {
    this._languages = [];
    this._languages.addAll(param);
    this.isEdited = true;
    notifyListeners();
  }

  void removeLanguage(LanguageModel param) {
    var isExist =
        this.languages.indexWhere((element) => element.id == param.id);
    this._languages.removeAt(isExist);
    this.isEdited = true;
    notifyListeners();
  }

  Future<void> removeUserExpertise(int index) async {
    var tempExpertise = this._user.userExpertises[index];
    if (tempExpertise.id != null) {
      try {
        var result = await ProfileService.removeExpertise(tempExpertise);
        if (result != null) {
          if (result['status']) {
            this.user.userExpertises.removeAt(index);
            notifyListeners();
          }
        }
      } finally {
        dismissDialogToast();
      }
    } else {
      this._user.userExpertises.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> createExpertise() async {
    try {
      showLoadingDialog();
      var result = await ProfileService.createExpertise(this.expertise);
      if (result != null) {
        this.addExpertiseItem(result);
        showToast(message: 'skill is added.');
        Get.back();
        notifyListeners();
      }
    } finally {
      dismissDialogToast();
    }
  }

  Future<void> updateExpertise() async {
    try {
      showLoadingDialog();
      var result = await ProfileService.updateExpertise(this.expertise);
      if (result != null) {
        var index =
            this._user.userExpertises.indexWhere((p) => p.id == result.id);
        this._user.userExpertises[index] = result;
        showToast(message: 'skill is updated.');
        Get.back();
        notifyListeners();
      }
    } finally {
      dismissDialogToast();
    }
  }

  Future<void> storeUserLocal(UserModel param) async {
    await AppSharedPreferences.setUserProfile(param);
    this.authController.setAuthUser(param);
    notifyListeners();
  }

  void setIsEdited(bool param) {
    this.isEdited = param;
    notifyListeners();
  }

  void setProfileUser(UserModel user, {bool isMe = false}) {
    if (isMe) {
      // this._user = authController.authUser;
      this._user = user;
    }

    if (this.user != null) {
      this._languages = [];
      if (this.user?.language != null) {
        this._languages.addAll(this.user.languages);
      }
      if (this.user.userSearchPrefrences != null) {
        this._choosenCategories = [];
        this.user.userSearchPrefrences.forEach((element) {
          this._choosenCategories.add(element.category);
        });
      }
      nameTextController.text = this.user.name ?? "";
      bioTextController.text = this.user.bio ?? "";
      locationTextController.text = this.user.location ?? "";
      profileTextController.text = this.user.profileName ?? "";
    }
    notifyListeners();
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
    _choosenCategories.removeAt(isExist);
    notifyListeners();
  }

  void setLoader(bool param) {
    this._isLoadingProfile = param;
    notifyListeners();
  }
}

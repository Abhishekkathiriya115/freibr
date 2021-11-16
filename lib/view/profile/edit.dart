import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:freibr/common/widget/FRMultilieTextField.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/FRSimpleChip.dart';
import 'package:freibr/common/widget/language/language.dart';
import 'package:freibr/common/widget/category/category.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/profile.dart';
import 'package:freibr/core/model/category.dart';
import 'package:freibr/core/model/language.dart';
import 'package:freibr/core/model/user/user_expertise.dart';
import 'package:freibr/core/model/user/user_search_preference.dart';
import 'package:freibr/util/styles.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/util/extension.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Get.theme;

    ProfileController profileController = Provider.of(context);

    Widget profileImageSection() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(5),
        child: profileController.isUploadingImage
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: theme.primaryColor,
                ),
              )
            : Stack(
                children: [
                  CircleAvatar(
                      radius: 52,
                      backgroundColor: theme.primaryColor,
                      child: CircleAvatar(
                        radius: 49,
                        child: ClipOval(
                          child: profileController.user != null
                              ? getProgressiveImage(
                                  profileController.user?.thumbnailAvatar,
                                  profileController.user?.avatar,
                                  height: 15.h,
                                  width: 30.w,
                                )
                              : getProgressiveNoUserAvatar(
                                  height: 15.h, width: 30.w),
                        ),
                      )),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: ClipOval(
                        child: Container(
                          padding: EdgeInsets.all(6),
                          color: theme.primaryColor,
                          child: InkWell(
                            child: Icon(
                              Icons.photo_camera,
                            ),
                            onTap: () async {
                              // PlatformFile item = await getSingleImage();
                              // await profileController.uploadProfileImage(item);
                              Get.bottomSheet(
                                  Wrap(
                                    children: <Widget>[
                                      ListTile(
                                          leading: Icon(Icons.camera),
                                          title: Text(
                                            'CAMERA',
                                            style: Get.theme.textTheme.bodyText1
                                                .copyWith(fontSize: 14.0),
                                          ),
                                          onTap: () async {
                                            PickedFile _file =
                                                await getImageFromPicker(
                                                    ImageSource.camera);
                                            Get.back();
                                            await profileController
                                                .uploadProfileImage1(_file);
                                          }),
                                      ListTile(
                                        leading: Icon(Icons.image),
                                        title: Text('GALLERY',
                                            style: Get.theme.textTheme.bodyText1
                                                .copyWith(fontSize: 14.0)),
                                        onTap: () async {
                                          PickedFile _file =
                                              await getImageFromPicker(
                                                  ImageSource.gallery);
                                          Get.back();
                                          if (_file != null) {
                                            await profileController
                                                .uploadProfileImage1(_file);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  backgroundColor:
                                      theme.scaffoldBackgroundColor);
                            },
                          ),
                        ),
                      ))
                ],
              ),
      );
    }

    Widget generalSection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("General",
              style: Get.theme.textTheme.headline1.copyWith(fontSize: 16.0)),
          SizedBox(
            height: 15.0,
          ),
          Text("Name", style: Get.theme.textTheme.bodyText1),
          SizedBox(
            height: 7.0,
          ),
          FRTextField(
            hintText: 'enter your name',
            textEditingController: profileController.nameTextController,
            onChanged: (res) {
              profileController.user.name = res;
              profileController.setIsEdited(true);
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          Text("Profile Title", style: Get.theme.textTheme.bodyText1),
          SizedBox(
            height: 7.0,
          ),
          FRTextField(
            hintText: 'enter profile title',
            textEditingController: profileController.profileTextController,
            onChanged: (res) {
              profileController.user.profileName = null;
              profileController.setIsEdited(true);
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          Text("Category", style: Get.theme.textTheme.bodyText1),
          SizedBox(
            height: 7.0,
          ),
          Wrap(
            spacing: 8.0,
            children: profileController.choosenCategories
                .map((e) => FRSimpleChip(
                      onDeleted: () {
                        profileController.removeChoosenCategory(e);
                      },
                      title: e?.name ?? "",
                    ))
                .toList(),
          ),
          MaterialButton(
            padding: EdgeInsets.all(0),
            child: Text(
              "select categories".capitalize,
              style: Get.theme.textTheme.bodyText1
                  .copyWith(color: theme.primaryColor),
            ),
            onPressed: () {
              Get.to(() => FRCategoryPicker(
                    selectedCategories: profileController.choosenCategories,
                    onDone: (List<CategoryModel> categories) {
                      if (categories.length > 0) {
                        profileController.addChoosenCategoriesBulk(categories);
                      }
                    },
                  ));
            },
          ),
          // SizedBox(
          //   height: 15.0,
          // ),
          // CheckboxListTile(
          //   contentPadding: EdgeInsets.all(0),
          //   title: Text('Profile Privacy',
          //       style: Get.theme.textTheme.bodyText1
          //           .copyWith(fontWeight: FontWeight.w600)),
          //   subtitle: Text('Anyone can follow you without approval ?',
          //       style: Get.theme.textTheme.bodyText1),
          //   autofocus: false,
          //   activeColor: theme.primaryColor,
          //   selected: profileController.user.profileType == "public",
          //   value: profileController.user.profileType == "public",
          //   onChanged: (bool value) {
          //     profileController.user.profileType = value ? 'public' : 'private';
          //     profileController.setIsEdited(true);
          //   },
          // ),
          SizedBox(
            height: 15.0,
          ),
          Text("Description", style: Get.theme.textTheme.bodyText1),
          SizedBox(
            height: 7.0,
          ),
          FRMultilineTextField(
            hintText: "",
            textEditingController: profileController.bioTextController,
            keyboardType: TextInputType.multiline,
            onChanged: (res) {
              profileController.user.bio = res;
              profileController.setIsEdited(true);
            },
          )
        ],
      );
    }

    Widget aboutSection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About",
              style: Get.theme.textTheme.headline1.copyWith(fontSize: 16.0)),
          SizedBox(
            height: 15.0,
          ),
          Text("Location", style: Get.theme.textTheme.bodyText1),
          SizedBox(
            height: 7.0,
          ),
          FRTextField(
            hintText: '',
            textEditingController: profileController.locationTextController,
            onChanged: (res) {
              profileController.user.location = res;
              profileController.setIsEdited(true);
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          Text("Language", style: Get.theme.textTheme.bodyText1),
          SizedBox(
            height: 7.0,
          ),
          Wrap(
            spacing: 8.0,
            children: profileController.languages
                .map((e) => FRSimpleChip(
                    onDeleted: () {
                      profileController.removeLanguage(e);
                    },
                    title: e.name))
                .toList(),
          ),
          MaterialButton(
            padding: EdgeInsets.all(0),
            child: Text(
              "select languages".capitalize,
              style: Get.theme.textTheme.bodyText1
                  .copyWith(color: theme.primaryColor),
            ),
            onPressed: () {
              Get.to(() => FRLanguagePicker(
                    selectedLanguages: profileController.languages,
                    onDone: (List<LanguageModel> langauges) {
                      if (langauges.length > 0) {
                        profileController.addLanguages(langauges);
                      }
                    },
                  ));
            },
          ),
        ],
      );
    }

    void showExpertiseDialog(UserExpertise param) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(17),
              // contentPadding: EdgeInsets.zero,
              scrollable: true,
              content: Container(
                width: Get.size.width,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Skill", style: Get.theme.textTheme.bodyText1),
                      SizedBox(
                        height: 10.0,
                      ),
                      FRTextField(
                        initialValue: param.title ?? "",
                        onChanged: (res) {
                          profileController.expertise.title = res;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text("Level", style: Get.theme.textTheme.bodyText1),
                      SizedBox(
                        height: 7.0,
                      ),
                      RatingBar.builder(
                        initialRating: param.rating.isNullOrEmpty()
                            ? 3
                            : double.parse(param.rating),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          profileController.expertise.rating =
                              rating.toString();
                          // profileController.user.userExpertises[index].rating =
                          //     rating.toString();
                          // profileController.setIsEdited(true);
                        },
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancle', style: theme.textTheme.bodyText1),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  child: Text(
                    'Save',
                    style: theme.textTheme.bodyText1
                        .copyWith(color: theme.primaryColor),
                  ),
                  onPressed: () {
                    profileController.createExpertise();
                  },
                )
              ],
            );
          });
    }

    Widget expertiseBox(int index) {
      return Card(
        child: ListTile(
          title: Text(profileController.user?.userExpertises[index].title ?? "",
              style: Get.theme.textTheme.bodyText1.copyWith(fontSize: 15.sp)),
          trailing: Wrap(
            //  direction: Axis.horizontal,
            // alignment: WrapAlignment.center,
            // spacing:8.0,
            // runAlignment:WrapAlignment.center,
            // runSpacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            // textDirection: TextDirection.rtl,
            // verticalDirection: VerticalDirection.up,
            children: [
              RatingBar.builder(
                initialRating: profileController
                            .user.userExpertises[index].rating ==
                        null
                    ? 3
                    : double.parse(
                        profileController.user.userExpertises[index].rating),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20.0,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  profileController.user.userExpertises[index].rating =
                      rating.toString();
                  profileController.setIsEdited(true);
                },
              ),
              IconButton(
                onPressed: () {
                  profileController.removeUserExpertise(index);
                },
                icon: Icon(FontAwesome.trash),
              )
            ],
          ),
        ),
      );
    }

    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
          appBar: AppBar(
              title: Text('Edit Profile', style: Get.theme.textTheme.bodyText1),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    profileController.user.language =
                        profileController.languages.map((e) {
                      return e.id;
                    }).join(', ');
                    var arr = profileController.choosenCategories.map((elem) {
                      return new UserSearchPreference(categoryId: elem.id);
                    }).toList();
                    profileController.user.userSearchPrefrences = arr;
                    profileController.updateProfile();
                  },
                ),
              ]),
          body: SingleChildScrollView(
            child: Container(
              width: Get.size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  profileImageSection(),
                  Divider(
                    thickness: 1.5,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: generalSection(),
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: aboutSection(),
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Expertise",
                            style: Get.theme.textTheme.headline1
                                .copyWith(fontSize: 16.0)),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Add your skills",
                                style: Get.theme.textTheme.bodyText1),
                            InkWell(
                                onTap: () {
                                  showExpertiseDialog(new UserExpertise());
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.0),
                                    width: 30,
                                    height: 30,
                                    child: Icon(
                                      Icons.add,
                                      size: 30,
                                    ),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: fabButtonLinearGradient))),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        profileController.user?.userExpertises != null
                            ? Column(
                                children: profileController.user.userExpertises
                                    .asMap()
                                    .entries
                                    .map((item) {
                                return expertiseBox(item.key);
                              }).toList())
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

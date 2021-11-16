import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:freibr/common/widget/FRTextfield.dart';
import 'package:freibr/common/widget/FRSimpleChip.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/profile.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ViewProfile extends StatelessWidget {
  ViewProfile({Key key}) : super(key: key);

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
            hintText: 'name',
            textEditingController: profileController.nameTextController,
            enabled: false,
          ),
          SizedBox(
            height: 15.0,
          ),
          Text("Profile Title", style: Get.theme.textTheme.bodyText1),
          SizedBox(
            height: 7.0,
          ),
          FRTextField(
            enabled: false,
            hintText: 'profile title',
            textEditingController: profileController.profileTextController,
          ),
          SizedBox(
            height: 15.0,
          ),
          profileController.choosenCategories.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Category", style: Get.theme.textTheme.bodyText1),
                    SizedBox(
                      height: 7.0,
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: profileController.choosenCategories
                          .map((e) => FRSimpleChip(
                                title: e?.name ?? "",
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 15.0,
                    )
                  ],
                )
              : Container(),
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
          //   onChanged: (bool value) {},
          // ),
          SizedBox(
            height: 15.0,
          ),
          profileController.user.bio != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description", style: Get.theme.textTheme.bodyText1),
                    SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      profileController.user.bio,
                      style: Get.theme.textTheme.bodyText1,
                    )
                  ],
                )
              : Container()
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
            enabled: false,
            textEditingController: profileController.locationTextController,
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
                .map((e) => FRSimpleChip(title: e.name))
                .toList(),
          ),
        ],
      );
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
                ignoreGestures: true,
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
                onRatingUpdate: (rating) {},
              ),
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
          ),
          body: SingleChildScrollView(
            child: Container(
              width: Get.size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: profileImageSection()),
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
                  profileController.user?.userExpertises != null &&
                          profileController.user.userExpertises.length > 0
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Expertise",
                                  style: Get.theme.textTheme.headline1
                                      .copyWith(fontSize: 16.0)),
                              SizedBox(
                                height: 15.0,
                              ),
                              profileController.user?.userExpertises != null
                                  ? Column(
                                      children: profileController
                                          .user.userExpertises
                                          .asMap()
                                          .entries
                                          .map((item) {
                                      return expertiseBox(item.key);
                                    }).toList())
                                  : Container(),
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          )),
    );
  }
}

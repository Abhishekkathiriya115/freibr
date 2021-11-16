import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/post.dart';
import 'package:get/get.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:freibr/common/widget/mediapicker/picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:freibr/common/widget/mediapicker/fr_multiselector_model.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/view/post/upload.dart';

class PostPicker extends StatelessWidget {
  PostPicker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FRMultiSelectorModel _selector = Provider.of(context, listen: true);
    PostController postController = Provider.of<PostController>(context);

    return StatefulWrapper(
        onInit: () {},
        child: Scaffold(
          appBar: AppBar(
            title: Text('New Post',
                style: Get.theme.textTheme.subtitle1.copyWith(fontSize: 16.sp)),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  Get.to(() => UploadPost());
                },
              )
            ],
          ),
          body: Column(
            children: [
              if (_selector.selectedMediaFile != null)
                Container(
                  color: Get.theme.scaffoldBackgroundColor,
                  height: 40.h,
                  width: 100.h,
                  child: Stack(
                    children: [
                      Container(
                        width: 100.h,
                        child: Image.file(
                          File(_selector.selectedMediaFile.path),
                          fit: postController.isExpanded
                              ? BoxFit.cover
                              : BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 2,
                        child: IconButton(
                          icon: postController.isExpanded
                              ? Icon(Foundation.arrows_out)
                              : Icon(Foundation.arrows_in),
                          onPressed: () {
                            bool isExpanded = postController.isExpanded;
                            isExpanded = !isExpanded;
                            postController.setExpanded(isExpanded);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(),
              Expanded(
                child: FRPickerWidget(
                  withImages: true,
                  withVideos: false,
                  multiSelect: false,
                  onDone: (Set<MediaFile> selectedFiles) {
                    Get.to(() => UploadPost());
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

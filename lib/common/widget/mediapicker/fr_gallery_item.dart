import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freibr/util/util.dart';
import 'package:get/get.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:media_picker_builder/media_picker_builder.dart';
import 'package:provider/provider.dart';
import 'package:freibr/common/widget/mediapicker/fr_multiselector_model.dart';


class FRGalleryWidgetItem extends StatefulWidget {
  final MediaFile mediaFile;
  final bool multiSelect;

  FRGalleryWidgetItem({this.mediaFile, this.multiSelect});

  @override
  State<StatefulWidget> createState() => GalleryWidgetItemState();
}

class GalleryWidgetItemState extends State<FRGalleryWidgetItem> {
  Widget blueCheckCircle = Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 24,
          height: 24,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      Icon(Icons.check_circle, color: Get.theme.primaryColor)
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<FRMultiSelectorModel>(
      builder: (context, selector, child) {
        return GestureDetector(
          onTap: () {
            if (!widget.multiSelect) {
              selector.toggleSingleFile(widget.mediaFile);
            } else {
              selector.toggle(widget.mediaFile);
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: selector.isSelected(widget.mediaFile) ? 0.7 : 1.0,
                child: child,
              ),
              selector.isSelected(widget.mediaFile)
                  ? Positioned(
                      right: 10,
                      bottom: 10,
                      child: blueCheckCircle,
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          widget.mediaFile.thumbnailPath != null
              ? RotatedBox(
                  quarterTurns: Platform.isIOS
                      ? 0
                      : MediaPickerBuilder.orientationToQuarterTurns(
                          widget.mediaFile.orientation),
                  child: Image.file(
                    File(widget.mediaFile.thumbnailPath),
                    fit: BoxFit.cover,
                  ),
                )
              : FutureBuilder(
                  future: MediaPickerBuilder.getThumbnail(
                    fileId: widget.mediaFile.id,
                    type: widget.mediaFile.type,
                  ),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      var thumbnail = snapshot.data;
                      widget.mediaFile.thumbnailPath = thumbnail;
                      return RotatedBox(
                        quarterTurns: Platform.isIOS
                            ? 0 // iOS thumbnails have correct orientation
                            : MediaPickerBuilder.orientationToQuarterTurns(
                                widget.mediaFile.orientation),
                        child: Image.file(
                          File(thumbnail),
                          fit: BoxFit.cover,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Icon(Icons.error, color: Colors.red, size: 24);
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: frCircularLoader(),
                      );
                    }
                  }),
          widget.mediaFile.type == MediaType.VIDEO
              ? Icon(Icons.play_circle_filled, size: 24)
              : const SizedBox()
        ],
      ),
    );
  }
}

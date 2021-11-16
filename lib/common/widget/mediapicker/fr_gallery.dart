import 'package:flutter/material.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:freibr/common/widget/mediapicker/fr_gallery_item.dart';

class FRGalleryWidget extends StatefulWidget {
  final List<MediaFile> mediaFiles;
  final bool multiSelect;

  FRGalleryWidget({@required this.mediaFiles, this.multiSelect});

  @override
  State<StatefulWidget> createState() => GalleryWidgetState();
}

class GalleryWidgetState extends State<FRGalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.mediaFiles.isEmpty
          ? Center(child: Text("Empty Folder"))
          : GridView.builder(
              padding: EdgeInsets.all(0),
              itemCount: widget.mediaFiles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return FRGalleryWidgetItem(
                  mediaFile: widget.mediaFiles[index],
                  multiSelect: widget.multiSelect,
                );
              }),
    );
  }
}

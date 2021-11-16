import 'package:flutter/material.dart';
import 'package:freibr/common/widget/mediapicker/fr_multiselector_model.dart';
import 'package:freibr/common/widget/mediapicker/fr_gallery.dart';
import 'package:freibr/util/util.dart';

import 'package:media_picker_builder/data/album.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:media_picker_builder/media_picker_builder.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class FRPickerWidget extends StatefulWidget {
  final bool withImages;
  final bool withVideos;
  final bool multiSelect;
  final Function(Set<MediaFile> selectedFiles) onDone;
  final Function() onCancel;
  final bool showCancle;
  final bool showOnDone;

  FRPickerWidget(
      {@required this.withImages,
      @required this.withVideos,
      @required this.onDone,
      @required this.onCancel,
      this.multiSelect = true,
      this.showCancle = true,
      this.showOnDone = true});

  @override
  State<StatefulWidget> createState() => PickerWidgetState();
}

class PickerWidgetState extends State<FRPickerWidget> {
  List<Album> _albums;
  Album _selectedAlbum;
  bool _loading = true;
  FRMultiSelectorModel _selector;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      MediaPickerBuilder.getAlbums(
        withImages: widget.withImages,
        withVideos: widget.withVideos,
      ).then((albums) {
        setState(() {
          _loading = false;
          _albums = albums;
          if (albums.isNotEmpty) {
            albums.sort((a, b) => b.files.length.compareTo(a.files.length));
            _selectedAlbum = albums[0];
            _selector.toggle(albums[0].files.first);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _selector = Provider.of(context, listen: true);
    return _loading ? Center(child: frCircularLoader()) : _buildWidget();
  }

  _buildWidget() {
    if (_albums.isEmpty)
      return Center(child: Text("You have no folders to select from"));

    final dropDownAlbumsWidget = DropdownButton<Album>(
      itemHeight: 50.0,
      underline: Container(
        height: 1.0,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.transparent, width: 0.0))),
      ),
      value: _selectedAlbum,
      onChanged: (Album newValue) {
        setState(() {
          _selectedAlbum = newValue;
        });
      },
      items: _albums.map<DropdownMenuItem<Album>>((Album album) {
        return DropdownMenuItem<Album>(
          value: album,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 160),
            child: Text(
              "${album.name} (${album.files.length})".capitalize,
              overflow: TextOverflow.ellipsis,
              style: Get.theme.textTheme.bodyText1
                  .copyWith(fontSize: 12.0, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }).toList(),
    );

    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dropDownAlbumsWidget,
              Row(
                children: [
                  Consumer<FRMultiSelectorModel>(
                    builder: (context, selector, child) {
                      return widget.showOnDone
                          ? TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(0)),
                              ),
                              onPressed: () =>
                                  widget.onDone(_selector.selectedItems),
                              child: Text(
                                  "Done (${selector.selectedItems.length})"
                                      .toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: Get.theme.textTheme.bodyText1.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600)),
                            )
                          : Container();
                    },
                  ),
                  widget.showCancle
                      ? Container(
                          margin: EdgeInsets.only(left: 10),
                          child: TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(0)),
                            ),
                            onPressed: () => widget.onCancel(),
                            child: Text("Cancel".toUpperCase(),
                                style: Get.theme.textTheme.bodyText1.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                        )
                      : Container(),
                ],
              )
            ],
          ),
          FRGalleryWidget(
            mediaFiles: _selectedAlbum.files,
            multiSelect: widget.multiSelect,
          ),
        ],
      ),
    );
  }
}

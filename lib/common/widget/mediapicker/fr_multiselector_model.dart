import 'package:flutter/material.dart';
import 'package:media_picker_builder/data/media_file.dart';


class FRMultiSelectorModel extends ChangeNotifier {
  Set<MediaFile> _selectedItems = Set();
  MediaFile _selectedMediaFile;

  void toggle(MediaFile file) {
    if (_selectedItems.contains(file)) {
      _selectedItems.remove(file);
    } else {
      _selectedMediaFile = file;
      _selectedItems.add(file);
    }
    notifyListeners();
  }

  void toggleSingleFile(MediaFile file) {
    _selectedItems.clear();
    _selectedMediaFile = file;
    _selectedItems.add(file);
    notifyListeners();
  }

  void clearItems() {
    _selectedItems = Set();
    notifyListeners();
  }

  bool isSelected(MediaFile file) {
    return _selectedItems.contains(file);
  }

  Set<MediaFile> get selectedItems => _selectedItems;
  MediaFile get selectedMediaFile => _selectedMediaFile;
}

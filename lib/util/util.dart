import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freibr/config/url.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:url_launcher/url_launcher.dart';

Uri stringToUri(String param) {
  return Uri.parse(param);
}

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

TextStyle extend(TextStyle s1, TextStyle s2) {
  return s1.merge(s2);
}

void showToast(
    {String message,
    EasyLoadingToastPosition position = EasyLoadingToastPosition.bottom}) {
  if (message.isNotEmpty) {
    EasyLoading.showToast(message,
        // maskType: EasyLoadingMaskType.black,
        toastPosition: position);
  }
}

void showLoadingDialog() {
  EasyLoading.show(maskType: EasyLoadingMaskType.black, dismissOnTap: false);
}

void showProgressDialog({double value, String message}) {
  EasyLoading.showProgress(value,
      status: message, maskType: EasyLoadingMaskType.black);
}

void dismissDialogToast() {
  EasyLoading.dismiss();
}

Future<PickedFile> getImageFromPicker(ImageSource source) async {
  final picker = ImagePicker();
  return picker.getImage(source: source);
}

File getFileFromPath(String path) {
  return File(path);
}

Future<List<String>> getDeviceDetails() async {
  String deviceName;
  String deviceVersion;
  String identifier;
  String deviceType;
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.toString();
      identifier = build.androidId; //UUID for Android
      deviceType = 'android';
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
      deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor; //UUID for iOS
      deviceType = 'ios';
    }
  } on PlatformException {
    print('Failed to get platform version');
  }

  return [deviceName, deviceVersion, identifier, deviceType];
}

Future<Uint8List> convetToByteFromFile(File param) async {
  Uint8List bytes;
  await param.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
  }).catchError((onError) {
    print(
        'Exception Error while reading audio from path:' + onError.toString());
  });
  return bytes;
}

Future<Uint8List> convetToByteFromPath(String filePath) async {
  Uri myUri = Uri.parse(filePath);
  File audioFile = new File.fromUri(myUri);
  Uint8List bytes;
  await audioFile.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    print('reading of bytes is completed');
  }).catchError((onError) {
    print(
        'Exception Error while reading audio from path:' + onError.toString());
  });
  return bytes;
}

dynamic getFileSizeArray(dynamic size, [int round = 2]) {
  /** 
   * [size] can be passed as number or as string
   *
   * the optional parameter [round] specifies the number 
   * of digits after comma/point (default is 2)
   */
  int divider = 1024;
  int _size;
  try {
    _size = int.parse(size.toString());
  } catch (e) {
    throw ArgumentError("Can not parse the size parameter: $e");
  }

  if (_size < divider) {
    return {"size": "_size", "sizeType": "B"};
  }

  if (_size < divider * divider && _size % divider == 0) {
    return {
      "size": "${(_size / divider).toStringAsFixed(0)}",
      "sizeType": "KB"
    };
  }

  if (_size < divider * divider) {
    return {
      "size": "${(_size / divider).toStringAsFixed(round)}",
      "sizeType": "KB"
    };
  }

  if (_size < divider * divider * divider && _size % divider == 0) {
    return {
      "size": "${(_size / (divider * divider)).toStringAsFixed(0)}",
      "sizeType": "MB"
    };
  }

  if (_size < divider * divider * divider) {
    return {
      "size": "${(_size / divider / divider).toStringAsFixed(round)}",
      "sizeType": "MB"
    };
  }

  return null;
}

Duration parseDurationFromString(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

String getCurrentFormatDate(DateTime param) {
  return DateFormat.yMMMMEEEEd().format(param);
}

Widget getProgressiveImageCustom(String thumbnailUrl, String imageUrl,
    {double height = 76, double width = 76}) {
  return ProgressiveImage.custom(
    placeholderBuilder: (BuildContext context) => Container(
      width: width,
      height: height,
      color: Get.theme.primaryColorDark.withOpacity(0.5),
    ),
    thumbnail: NetworkImage(getMediaUrl(thumbnailUrl)), // 64x43
    image: NetworkImage(getMediaUrl(imageUrl)), // 3240x2160
    width: width,
    height: height,
    fit: BoxFit.cover,
  );
}

Widget getProgressiveImage(String thumbnailUrl, String imageUrl,
    {double height = 76, double width = 76}) {
  return ProgressiveImage(
    thumbnail: NetworkImage(getMediaUrl(thumbnailUrl)), // 64x43
    image: NetworkImage(getMediaUrl(imageUrl)), // 3240x2160
    width: width,
    height: height,
    fit: BoxFit.cover,
    placeholder:
        AssetImage('assets/images/box/${Random().nextInt(4).toString()}.jpg'),
  );
}

Widget getProgressiveNoUserAvatar({double height = 76, double width = 76}) {
  return ProgressiveImage(
    thumbnail: NetworkImage(getMediaUrl('noprofile.png')), // 64x43
    image: NetworkImage(getMediaUrl('noprofile.png')), // 3240x2160
    width: width,
    height: height,
    fit: BoxFit.cover,
    placeholder:
        AssetImage('assets/images/box/${Random().nextInt(4).toString()}.jpg'),
  );
}

Widget frCircularLoader(
    {double height: 80, double width: 80, double storkeWidth: 1.5}) {
  return SizedBox(
    height: height,
    width: width,
    child: CircularProgressIndicator(
      backgroundColor: Get.theme.primaryColorDark,
      strokeWidth: storkeWidth,
      valueColor:
          new AlwaysStoppedAnimation<Color>(Get.theme.primaryColorLight),
    ),
  );
}

String getMediaUrl(String path) {
  if (path != null) return UrlDto.awsMediaServerUrl + path;

  return null;
}

String convertToAgo(DateTime input) {
  Duration diff = DateTime.now().difference(input);

  if (diff.inDays >= 1) {
    return '${diff.inDays} day(s) ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} hour(s) ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} minute(s) ago';
  } else if (diff.inSeconds >= 1) {
    return '${diff.inSeconds} second(s) ago';
  } else {
    return 'just now';
  }
}

Future<void> launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/gig.dart';
import 'package:freibr/view/gig/tax.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:freibr/util/extension.dart';

class GigMedia extends StatefulWidget {
  const GigMedia({Key key}) : super(key: key);

  @override
  _GigMediaState createState() => _GigMediaState();
}

class _GigMediaState extends State<GigMedia> {
  bool uploading = false;
  double val = 0;

  List<File> _image = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Get.theme;
    GigController gigController = Provider.of(context);

    Future<void> retrieveLostData() async {
      final LostData response = await picker.getLostData();
      if (response.isEmpty) {
        return;
      }
      if (response.file != null) {
        setState(() {
          _image.add(File(response.file.path));
        });
      } else {
        print(response.file);
      }
    }

    chooseImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        _image.add(File(pickedFile?.path));
        gigController.saveGalleryFile(pickedFile);
      });
      if (pickedFile.path == null) retrieveLostData();
    }

    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text('Build Your Gig Gallery', style: theme.textTheme.bodyText1),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Column(
              children: [
                Card(
                  child: Container(
                    width: Get.size.width,
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text(
                        'Add memorable content to your gallery to set yourself apart from competitors.',
                        style: Get.theme.textTheme.bodyText1
                            .copyWith(fontSize: 12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Card(
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.only(bottom: 10.0),
                    title: Text(
                      "Terms & Conditions",
                      style: Get.theme.textTheme.bodyText1,
                    ),
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text(
                          "To comply with Freiber's terms of service, make sure to upload only content you either own or you have the permission or license to use.",
                          style: Get.theme.textTheme.bodyText1
                              .copyWith(fontSize: 12.0),
                        ),
                      )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 7.0,
                // ),
                // Divider(),
                Container(
                  height: Get.size.height,
                  width: Get.size.width,
                  // padding: EdgeInsets.all(4),
                  child: GridView.builder(
                      itemCount: _image.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Card(
                                child: Center(
                                  child: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () =>
                                          !uploading ? chooseImage() : null),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image[index - 1]),
                                        fit: BoxFit.cover)),
                              );
                      }),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: !gigController.gig.gigMedia.isNullOrEmpty()
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
                child: FRButton(
                  label: "Save & continue",
                  onPressed: () {
                    Get.to(() => GigTaxInformation());
                  },
                ),
              )
            : Text(''),
      ),
    );
  }
}

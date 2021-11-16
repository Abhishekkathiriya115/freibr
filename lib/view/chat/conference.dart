import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/util/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Conference extends StatefulWidget {
  final String conferenceUrl;
  final UserModel host;

  Conference({
    Key key,
    this.conferenceUrl,
    this.host,
  }) : super(key: key);

  @override
  _ConferenceState createState() => _ConferenceState();
}

class _ConferenceState extends State<Conference> {
  InAppWebViewController webViewController;

  bool hasClosed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  Widget build(BuildContext context) {
    var authUser = Provider.of<AuthenticationController>(context).authUser;

    Future<bool> showConfirmDialog(bool isAppbar) async {
      if (authUser.id != widget.host.id) {
        return true;
      }
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit an App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    bool isClosed = await Provider.of<TimelineController>(
                            context,
                            listen: false)
                        .closeLiveConference(widget.host);

                    if (isClosed) {
                      if (isAppbar) {
                        Navigator.of(context).pop(true);
                      }
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
      onWillPop: () async => showConfirmDialog(false),
      child: StatefulWrapper(
        onInit: () {
          showLoadingDialog();
        },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  if (authUser.id != widget.host.id) {
                    Navigator.of(context).pop();
                  } else {
                    showConfirmDialog(true);
                  }
                },
              ),
            ),
            body: Container(
                child: Column(children: <Widget>[
              Expanded(
                child: widget.conferenceUrl != null
                    ? Container(
                        child: InAppWebView(
                            shouldOverrideUrlLoading:
                                (controller, request) async {
                              var url = request.request.url.toString();

                              if (url.contains(
                                  "https://freibr.s3-ap-south-1.amazonaws.com/")) {
                                final taskId = await FlutterDownloader.enqueue(
                                  url: url,
                                  savedDir:
                                      (await getExternalStorageDirectory())
                                          .path,
                                  showNotification:
                                      true, // show download progress in status bar (for Android)
                                  openFileFromNotification:
                                      true, // click on notification to open downloaded file (for Android)
                                );
                                return NavigationActionPolicy.CANCEL;
                              }

                              return NavigationActionPolicy.ALLOW;
                            },
                            initialUrlRequest: URLRequest(
                                url: Uri.parse(widget.conferenceUrl)),
                            onTitleChanged: (controller, title) {
                              print("title is changed");
                              print(title);
                              if (title.toLowerCase().contains('thankyou')) {
                                Future.delayed(
                                    const Duration(milliseconds: 1000), () {
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            initialOptions: InAppWebViewGroupOptions(
                                crossPlatform: InAppWebViewOptions(
                                    useOnDownloadStart: true,
                                    useShouldOverrideUrlLoading: true,
                                    mediaPlaybackRequiresUserGesture: false,
                                    clearCache: true),
                                android: AndroidInAppWebViewOptions(
                                  useHybridComposition: true,
                                ),
                                ios: IOSInAppWebViewOptions(
                                  allowsInlineMediaPlayback: true,
                                )),
                            onWebViewCreated:
                                (InAppWebViewController controller) {
                              webViewController = controller
                                ..addJavaScriptHandler(
                                    handlerName: 'functionName',
                                    callback: (data) {});
                            },
                            onLoadStart: (controller, url) {},
                            onLoadStop: (controller, url) {
                              dismissDialogToast();
                            },
                            androidOnPermissionRequest:
                                (controller, origin, resources) async {
                              return PermissionRequestResponse(
                                  resources: resources,
                                  action:
                                      PermissionRequestResponseAction.GRANT);
                            }),
                      )
                    : Center(child: Text("no data")),
              ),
            ]))),
      ),
    );
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
}

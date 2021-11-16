import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freibr/common/widget/FRButton.dart';
import 'package:freibr/common/widget/statefull_wrapper.dart';
import 'package:freibr/config/url.dart';
import 'package:freibr/core/controller/profile.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/core/model/user/user.dart';
import 'package:freibr/core/service/share_app.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/chat/conference.dart';
import 'package:freibr/view/timeline/profile/profile.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class JoinConference extends StatefulWidget {
  const JoinConference(
      {Key key, this.conferenceUrl, this.host, this.showCamera = false})
      : super(key: key);
  final String conferenceUrl;
  final UserModel host;
  final bool showCamera;

  @override
  _JoinConferenceState createState() => _JoinConferenceState();
}

class _JoinConferenceState extends State<JoinConference> {
  String bannerUrl;
  bool isLoading = false;

  IO.Socket socket;
  String totalMembers = '0';

  @override
  void initState() {
    super.initState();
    this.setHostBanner(widget.host.roomAvatar);
    this.connectToServer();
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  void connectToServer() {
    socket = IO.io('${UrlDto.socketUrl}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.onConnect((_) {
      print("socket connected");
    });

    socket.on('total-members-' + widget.host.id.toString(), (data) {
      setState(() {
        this.totalMembers = (data['totalParticipants']).toString();
      });
    });
  }

  setHostBanner(String param) {
    setState(() {
      bannerUrl = param;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: null,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        )),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: 100.w,
                  color: Get.theme.primaryColorDark.withOpacity(0.7),
                  child: Stack(children: [
                    widget.host?.roomAvatar != null
                        ? getProgressiveImage(
                            bannerUrl,
                            bannerUrl,
                            width: 100.w,
                            height: 100.w,
                          )
                        : getProgressiveNoUserAvatar(
                            height: 100.w, width: 100.w),
                    Positioned(
                      top: 2,
                      left: 6,
                      child: getProgressiveImage(
                        'box/freibr.png',
                        'box/freibr.png',
                        width: 60,
                        height: 60,
                      ),
                    ),
                    widget.showCamera
                        ? Positioned(
                            bottom: 2,
                            right: 2,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt_outlined),
                              onPressed: () async {
                                PickedFile _file = await getImageFromPicker(
                                    ImageSource.gallery);

                                if (_file != null) {
                                  var tempUrl =
                                      await Provider.of<ProfileController>(
                                              context,
                                              listen: false)
                                          .uploadRoomPic(_file);
                                  if (tempUrl != null) {
                                    this.setHostBanner(tempUrl);
                                  }
                                }
                              },
                              iconSize: 22.sp,
                            ),
                          )
                        : Container()
                  ]),
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("${widget.host.name} Chatroom",
                        textAlign: TextAlign.center,
                        style: Get.theme.textTheme.bodyText1
                            .copyWith(fontSize: 16.sp)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            child: InkWell(
                          onTap: () {
                            Get.to(() => Profile());
                          },
                          child: ClipOval(
                            child: widget.host?.thumbnailAvatar != null
                                ? getProgressiveImage(
                                    widget.host?.thumbnailAvatar,
                                    widget.host?.avatar,
                                    width: 90,
                                    height: 90,
                                  )
                                : getProgressiveNoUserAvatar(
                                    height: 90, width: 90),
                          ),
                        )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 4),
                                  child: Icon(
                                    Icons.circle,
                                    color: Get.theme.accentColor,
                                    size: 13.sp,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                this.totalMembers,
                                style: Get.theme.textTheme.headline1
                                    .copyWith(fontSize: 22.sp),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.supervisor_account_rounded,
                                  size: 40.sp),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 4),
                                  child: Icon(
                                    Icons.circle,
                                    color: Get.theme.accentColor,
                                    size: 13.sp,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                this.totalMembers,
                                style: Get.theme.textTheme.headline1
                                    .copyWith(fontSize: 22.sp),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.notifications, size: 40.sp),
                            ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: FRButton(
                              gradientButton: true,
                              borderRadius: 60,
                              onPressed: () async {
                                if (widget.showCamera) {
                                  Get.to(() => Conference(
                                        host: widget.host,
                                        conferenceUrl: widget.conferenceUrl,
                                      ));
                                } else {
                                  bool isLive =
                                      await Provider.of<TimelineController>(
                                              context,
                                              listen: false)
                                          .checkIsLive(widget.host);
                                  if (isLive) {
                                    Get.to(() => Conference(
                                          host: widget.host,
                                          conferenceUrl: widget.conferenceUrl,
                                        ));
                                  } else {
                                    showToast(
                                        message:
                                            widget.host.name + " is not live.",
                                        position:
                                            EasyLoadingToastPosition.center);
                                  }
                                }
                              },
                              label: widget.showCamera ? 'GO LIVE' : 'Join'),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: FRButton(
                              borderRadius: 60,
                              onPressed: () async {
                                ShareAPP.shareProfile(
                                    ShareAPP.buildLiveConference(
                                        widget.host.id));
                              },
                              label: 'Share'),
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

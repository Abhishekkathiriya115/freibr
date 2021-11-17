import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freibr/config/url.dart';
import 'package:freibr/core/controller/authentication.dart';
import 'package:freibr/core/controller/bank_details.dart';
import 'package:freibr/core/controller/category.dart';
import 'package:freibr/core/controller/custom_order.dart';
import 'package:freibr/core/controller/gig.dart';
import 'package:freibr/core/controller/navigation.dart';
import 'package:freibr/core/controller/notification.dart';
import 'package:freibr/core/controller/onboarding.dart';
import 'package:freibr/core/controller/post_comments.dart';
import 'package:freibr/core/controller/profile.dart';
import 'package:freibr/core/controller/register.dart';
import 'package:freibr/core/controller/saved_post.dart';
import 'package:freibr/core/controller/timeline.dart';
import 'package:freibr/core/controller/post.dart';
import 'package:freibr/core/controller/chat.dart';
import 'package:freibr/util/util.dart';
import 'package:freibr/view/chat/join.dart';
import 'package:freibr/view/splash.dart';
import 'package:freibr/view/timeline/profile/profile.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:freibr/util/fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:freibr/common/widget/mediapicker/fr_multiselector_model.dart';

import 'core/controller/settings/restricted_accounts.dart';

import 'package:uni_links/uni_links.dart';

import 'core/model/user/user.dart';
import 'view/post/timeline.dart';

void getAppPermissions() async {
  await Permission.camera.request();
  await Permission.microphone.request();
  await Permission.storage.request();
  await Permission.photos.request();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
      );
  await Permission.storage.request();
  getAppPermissions();
  Provider.debugCheckInvalidValueType = null;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

bool _initialUriIsHandled = false;

class MyApp extends StatelessWidget {
  StreamSubscription _sub;
  String redirectType = '';
  String profileId, conferenceID;
  String postId;
  UserModel user;
  MyApp() {
    _handleIncomingLinks();
    _handleInitialUri();
  }
  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri uri) {
      print('===================>>> $uri');
    }, onError: (Object err) {
      print('=======================>>>>>$err');
    });
  }

  Future<void> _handleInitialUri() async {
    final uri = await getInitialUri();
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        final profileRegExp = RegExp('^https://freibr.com/profile/[0-9]');
        final postRegExp = RegExp('^https://freibr.com/post/[0-9]');
        final conferenceRegExp = RegExp('^https://freibr.com/room/[0-9]');
        if (profileRegExp.hasMatch(uri.toString())) {
          redirectType = 'PROFILE';
          profileId = uri.toString().split('/').last;
        } else if (postRegExp.hasMatch(uri.toString())) {
          redirectType = 'POST';
          postId = uri.toString().split('/').last;
        } else if (conferenceRegExp.hasMatch(uri.toString())) {
          redirectType = 'CONFERENCE';
          conferenceID = uri.toString().split('/').last;
        } else {
          redirectType = 'DEFAULT';
        }
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider(
            create: (context) => Connectivity().onConnectivityChanged,
            initialData: ConnectivityResult.mobile,
          ),
          ChangeNotifierProvider(create: (context) => OnboardingController()),
          ChangeNotifierProvider(
              create: (context) => AuthenticationController()),
          ChangeNotifierProxyProvider<AuthenticationController,
                  NavigationController>(
              create: (context) => NavigationController(),
              update: (context, authController, navController) =>
                  NavigationController(authController: authController)),
          ChangeNotifierProvider(create: (context) => NotificationController()),
          ChangeNotifierProvider(create: (context) => FRMultiSelectorModel()),
          ChangeNotifierProvider(create: (context) => CategoryController()),
          ChangeNotifierProxyProvider<AuthenticationController,
                  TimelineController>(
              create: (context) => TimelineController(),
              update: (context, authController, navController) =>
                  TimelineController(authController: authController)),
          ChangeNotifierProxyProvider<AuthenticationController,
              RegisterController>(
            create: (context) => RegisterController(),
            update: (context, authController, registerController) =>
                RegisterController(authController: authController),
          ),
          ChangeNotifierProxyProvider<AuthenticationController,
              ProfileController>(
            create: (context) => ProfileController(),
            update: (context, authController, profileController) =>
                ProfileController(authController: authController),
          ),
          ChangeNotifierProxyProvider<AuthenticationController, PostController>(
            create: (context) => PostController(),
            update: (context, authController, profileController) =>
                PostController(authController: authController),
          ),
          ChangeNotifierProxyProvider<AuthenticationController, ChatController>(
            create: (context) => ChatController(),
            update: (context, authController, profileController) =>
                ChatController(authController: authController),
          ),
          ChangeNotifierProxyProvider<AuthenticationController, GigController>(
            create: (context) => GigController(),
            update: (context, authController, profileController) =>
                GigController(authController: authController),
          ),
          // ChangeNotifierProvider(create: (context) => CustomOrderController()),
          ChangeNotifierProxyProvider<AuthenticationController,
              CustomOrderController>(
            create: (context) => CustomOrderController(),
            update: (context, authController, profileController) =>
                CustomOrderController(authController: authController),
          ),
          ChangeNotifierProxyProvider<AuthenticationController,
              BankDetailsContoller>(
            create: (context) => BankDetailsContoller(),
            update: (context, authController, profileController) =>
                BankDetailsContoller(authController: authController),
          ),
          ChangeNotifierProxyProvider<AuthenticationController,
              RestrictedAccountController>(
            create: (context) => RestrictedAccountController(),
            update: (context, authController, restrictedAccountController) =>
                RestrictedAccountController(),
          ),
          ChangeNotifierProvider(create: (_) => PostCommentsController()),
          ChangeNotifierProvider(create: (_) => SavedPostController())
        ],
        child: Sizer(builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            title: "Freibr",
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
            themeMode: ThemeMode.dark,
            theme: ThemeData(
              brightness: Brightness.dark,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              /* light theme settings */
            ),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: colorFromHex('#161617'),
                // visualDensity: VisualDensity.adaptivePlatformDensity,
                // accentColor: Colors.white,
                // accentColor: colorFromHex('#25600E'),
                // primaryColor: colorFromHex('#43B616'),
                // scaffoldBackgroundColor: colorFromHex('#2f373e'),
                accentColor: colorFromHex('#008e79'),
                primaryColor: colorFromHex('#008e79'),
                iconTheme: IconThemeData(color: Colors.white),
                appBarTheme: AppBarTheme(
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.white),
                  color: colorFromHex('#161617'),
                ),
                tabBarTheme: TabBarTheme(labelColor: Colors.white),
                buttonTheme:
                    ButtonThemeData(buttonColor: colorFromHex('#43B616')),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        colorFromHex('#43B616')),
                  ),
                ),
                textTheme: TextTheme(
                    bodyText1: bodyStyle.copyWith(fontSize: 11.sp),
                    subtitle1: bodyStyle.copyWith(fontSize: 13.sp),
                    headline1: titleStyle.copyWith(fontSize: 18.sp))
                /* dark theme settings */
                ),
            home: FutureBuilder(
              // Replace the 3 second delay with your initialization code:
              future: Future.delayed(Duration(seconds: 2)),
              builder: (context, AsyncSnapshot snapshot) {
                // Show splash screen while waiting for app resources to load:
                if (snapshot.connectionState != ConnectionState.waiting) {
                  if (redirectType == 'PROFILE') {
                    return Profile(
                      isRedirect: true,
                      userId: profileId,
                    );
                  } else if (redirectType == 'POST') {
                    // ProfileController controller = Provider.of(context);
                    return PostTimeline(
                      isRedirect: true,
                      user: user,
                      userId: profileId,
                      postId: postId,
                    );
                  } else if (redirectType == 'CONFERENCE') {
                    // String conferenceUrl = UrlDto.conferenceUrl +
                    //     "/?room=${conferenceID}&name=${_controller.authUser.name}&user=${_controller.authUser.id}&avatar=${_controller.authUser.avatar}";
                    AuthenticationController _controller = Provider.of(context);
                    String conferenceUrl = UrlDto.conferenceUrl +
                        "/?room=${conferenceID}&name=2323&user=138&avatar=121212";
                    return JoinConference(
                      conferenceUrl: conferenceUrl,
                      host: _controller.authUser,
                    );
                  }
                  return Splash();
                } else {
                  // Loading is done, return the app:
                  return Center(
                      child: Image.asset(
                    'assets/images/freibr.png',
                    width: Get.size.width / 2.5,
                  ));
                }
              },
            ),
          );
        }));
  }
}

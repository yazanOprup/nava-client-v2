import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:provider/provider.dart';
// import 'helpers/constants/MyColors.dart';
// import 'helpers/providers/UserProvider.dart';
// import 'helpers/providers/fcmProvider.dart';
// import 'helpers/providers/visitor_provider.dart';
// import 'layouts/Home/orders/OrderDetails.dart';
import 'helpers/providers/UserProvider.dart';
import 'helpers/providers/fcmProviders.dart';
import 'helpers/providers/visitor_provider.dart';
import 'layouts/Home/orders/OrderDetails.dart';
import 'layouts/auth/splash/Splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
    // transparent status bar
  ));

  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [Locale('ar', 'EG'), Locale('en', 'US')],
    path: 'assets/langs',
    fallbackLocale: Locale('ar', 'EG'),
    startLocale: Locale('ar', 'EG'),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) =>print(value));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fcm();
    });
  }

  Future fcm() async {
    final currentYear = DateTime.now().year;

    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('____User granted permission____');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('____User granted provisional permission____');
    } else {
      print('____User declined or has not accepted permission____');
    }
    //
    // const AndroidNotificationChannel channel = AndroidNotificationChannel(
    //   'high_importance_channel'// id
    //   'High Importance Notifications' // title
    //   description:
    //   'This channel is used for important notifications.', // description
    //   importance: Importance.max,
    // );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
        // ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print("Printing on Message Notification click");
      message.data.keys.forEach((element) {
        log("Printing on Message Notification click keys ${element}");
      });
      if (notification != null && android != null) {
        final id = message.notification.body
            .replaceAll(RegExp('[^0-9]'), '')
            .replaceFirst(RegExp("${currentYear.toString()}"), '');
        print(id.toString());
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            // android: AndroidNotificationDetails(
            //   channel.id, channel.name,
            //   channelDescription: channel.description,
            //   icon: "@mipmap/launcher_icon",
            //   // other properties...
            // ),
            iOS: IOSNotificationDetails(
              subtitle: "Text",
            ),
          ),
        );
        if (id != null || id != '') {
          navigatorKey.currentState.pushReplacement(MaterialPageRoute(
              builder: (_) => OrderDetails(
                id: int.parse(id),
              )));
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final id = message.notification.body
          .replaceAll(RegExp('[^0-9]'), '')
          .replaceFirst(RegExp(currentYear.toString()), '');
      print("id number :$id");
      if (id != null || id != '') {
        navigatorKey.currentState.pushReplacement(MaterialPageRoute(
            builder: (_) => OrderDetails(
              id: int.parse(id),
            )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => VisitorProvider()),
        ChangeNotifierProvider(create: (context) => FcmProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Nava',
        theme: ThemeData(
            // primaryColor: MyColors.primary,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
             centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: MyColors.primary,
              ),
              titleTextStyle:
                  const TextStyle(color: Color(0xff0C1014), fontSize: 18),
              
            ),
            fontFamily: 'Tajawal-Regular',
            canvasColor: Colors.grey.shade100,
            bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.transparent)),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: Splash(
          navigatorKey: navigatorKey,
        ),
        // SimpleRecorder(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

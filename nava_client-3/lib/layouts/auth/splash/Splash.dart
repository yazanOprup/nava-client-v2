import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nava/helpers/providers/visitor_provider.dart';
import 'package:nava/layouts/Home/Home.dart';
import 'package:nava/layouts/auth/select_lang/SelectLang.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';

class Splash extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const Splash({Key key, this.navigatorKey}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // GlobalNotification.instance.setupNotification(widget.navigatorKey);
    _splashTimer();
    getUuid();
    super.initState();
  }

  String uuid;
  void getUuid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      uuid = build.androidId;
      preferences.setString("uuid", uuid);
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      uuid = data.identifierForVendor;
      preferences.setString("uuid", uuid);
    }
  }

  Future<Timer> _splashTimer() async {
    return new Timer(Duration(seconds: 2), _goToApp);
  }

  _goToApp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("cityId", 1);
    if (preferences.getString("lang") == "en") {
      changeLanguage("en", context);
    } else {
      changeLanguage("ar", context);
    }

    VisitorProvider visitorProvider =
        Provider.of<VisitorProvider>(context, listen: false);
    if (preferences.getString("userId") != null) {
      visitorProvider.visitor = false;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => Home()), (route) => false);
    } else {
      visitorProvider.visitor = true;
      changeLanguage("ar", context);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => SelectLang()), (route) => false);
    }
  }

  static void changeLanguage(String lang, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lang == "en") {
      prefs.setString("lang", lang);
      context.locale = Locale('en', 'US');
    } else {
      context.locale = Locale('ar', 'EG');
      prefs.setString("lang", lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage(Res.splash), fit: BoxFit.cover)),
            child: AnimationConfiguration.staggeredList(
              position: 0,
              duration: Duration(milliseconds: 500),
              child: Visibility(
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ExactAssetImage(Res.logo), scale: 3)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

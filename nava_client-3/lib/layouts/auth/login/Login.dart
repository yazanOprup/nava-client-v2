import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/helpers/providers/visitor_provider.dart';
import 'package:nava/layouts/Home/Home.dart';
import 'package:nava/layouts/auth/active_account/ActiveAccount.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/constants/base.dart';
import '../../../res.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController _phone = new TextEditingController();
  bool pass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage(Res.backGround), fit: BoxFit.cover)),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
          children: [
            Image(
              image: AssetImage(Res.logo),
              fit: BoxFit.contain,
              height: 125,
            ),
            SizedBox(
              height: 18,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      tr("welcomeR"),
                      style: TextStyle(
                        //fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: MyColors.secondary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        tr("enterPhone"),
                        style: TextStyle(
                          //fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: MyColors.secondary,
                        ),
                      ),
                    ),
                    RichTextFiled(
                      controller: _phone,
                      label: tr("phone"),
                      type: TextInputType.phone,
                      margin: EdgeInsets.only(top: 20, bottom: 0),
                      fillColor: MyColors.secondary,
                      icon: Container(
                        width: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.phone_android_sharp),
                            SizedBox(
                              width: 10,
                            )
                            // Image(
                            //   image: ExactAssetImage(Res.saudiarabia),
                            //   width: 30,
                            // ),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 6),
                            //   child: Text(
                            //     "966+",
                            //     style: TextStyle(
                            //         fontSize: 15, fontWeight: FontWeight.bold),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                    loading
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: SpinKitDoubleBounce(
                                color: MyColors.accent, size: 30.0))
                        : CustomButton(
                            color: MyColors.secondary,
                            textColor: MyColors.primary,
                            title: tr("send"),
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 18),
                            onTap: () {
                              if (_phone.text != "") {
                                login();
                              } else {
                                Fluttertoast.showToast(
                                  msg: tr("plzFillData"),
                                );
                              }
                            },
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                      color: MyColors.secondary,
                      textColor: MyColors.primary,
                      // borderRadius: 5,
                      title: tr("visitor"),
                      onTap: setVisitor,
                    ),
                    // InkWell(
                    //   onTap: () => setVisitor(),
                    //   child: Center(
                    //     child: Text(
                    //       tr("visitor"),
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         textBaseline: TextBaseline.alphabetic,
                    //         decoration: TextDecoration.underline,
                    //         fontWeight: FontWeight.bold,
                    //         color: MyColors.secondary,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  bool loading = false;
  DioBase dioBase = DioBase();
  Future login() async {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (c) => ActiveAccount(
    //       phone: _phone.text,
    //     ),
    //   ),
    // );
    // return Future.delayed(
    //   Duration(seconds: 0),
    // );
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String deviceId = await _getId();
    preferences.setString("device_id", deviceId);
    print("Device Id : " + deviceId.toString());
    print("========> login00");
    setState(() => loading = true);
    final url = Uri.http(URL, "api/sign-in");
    print("========> login01");
    print(preferences.get("device_id"));

    try {
      print("========> login02");
      final response = await http.post(
        url,
        headers: {"Bearer": "484d8a6dc6df4f00f5b7d995491a9bcd"},
        body: {
          "phone": _phone.text,
          "lang": preferences.getString("lang"),
          // "device_id":preferences.getString("device_id")
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      print("========> login03");
      final responseData = json.decode(response.body);
      print("========> login04");
      if (response.statusCode == 200) {
        print("========> login05");
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) => ActiveAccount(
                phone: _phone.text,
              ),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      setState(() => loading = false);
      print("========> login09");
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  setVisitor() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("visitor", true);
    VisitorProvider visitorProvider =
        Provider.of<VisitorProvider>(context, listen: false);
    visitorProvider.visitor = true;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => Home(
                  index: 0,
                )),
        (route) => false);
  }
}

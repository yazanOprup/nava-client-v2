import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/CustomBackButton.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/providers/UserProvider.dart';
import '../../../helpers/providers/fcmProvider.dart';
import '../../../helpers/providers/visitor_provider.dart';
import '../../../res.dart';
import '../../Home/Home.dart';
import '../login/Login.dart';

class ActiveAccount extends StatefulWidget {
  final String phone;

  const ActiveAccount({Key key, this.phone = "079"}) : super(key: key);

  @override
  _ActiveAccountState createState() => _ActiveAccountState();
}

class _ActiveAccountState extends State<ActiveAccount> {
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();
  TextEditingController code = new TextEditingController();

  @override
  void initState() {
    print(widget.phone);
    getDeviceId();
    getUuid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffold,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Res.backGround),
          ),
        ),
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(
                  ctx: context,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Image(
                  image: AssetImage(Res.logo),
                  fit: BoxFit.contain,
                  height: 120,
                ),
              ),
              //Divider(),
              SizedBox(
                height: 50,
              ),
              Text(
                tr("sendOTPSuccess"),
                style: TextStyle(
                  //fontSize: 20,
                  //fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal-Bold',
                  color: MyColors.offWhite,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                child: Text(
                  tr("willSendSMS"),
                  style: TextStyle(color: MyColors.offWhite),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: PinCodeTextField(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  appContext: context,
                  length: 4,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderWidth: 1.5,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 55,
                      fieldWidth: 45,
                      activeFillColor: MyColors.secondary,
                      selectedColor: MyColors.secondary,
                      activeColor: MyColors.secondary,
                      inactiveColor: MyColors.secondary,
                      inactiveFillColor: MyColors.secondary,
                      selectedFillColor: MyColors.primary.withOpacity(.2)),
                  keyboardType: TextInputType.number,
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: code,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    return true;
                  },
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
                      title: tr("confirm"),
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                      onTap: () {
                        if (code.text != "") {
                          activeAccount();
                        } else {
                          Fluttertoast.showToast(
                            msg: tr("plzEnterCode"),
                          );
                        }
                      },
                    ),
              GestureDetector(
                onTap: () async {
                  await resendCode();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr("OTPFaild"),
                      style: TextStyle(
                          //fontSize: 14,
                          //fontWeight: FontWeight.bold,
                          color: MyColors.secondary,
                          decoration: TextDecoration.underline),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 5),
                    //   child: Text(
                    //     tr("OTPFaild"),
                    //     style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.bold,
                    //         color: MyColors.secondary,
                    //         decoration: TextDecoration.underline),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getDeviceId() async {
    String token = await FirebaseMessaging.instance.getToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("fcm_token", token);
    print(token);
    Provider.of<FcmProvider>(context, listen: false).fcmToken = token;
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

  bool loading = false;
  DioBase dioBase = DioBase();
  // Future activeAccount() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   print("========> activeAccount");
  //   LoadingDialog.showLoadingDialog();
  //   final url = Uri.http(URL, "api/active-code");
  //   try {
  //     print(preferences.getString("uuid"));
  //     print(preferences.getString("fcmToken"));
  //     final response = await http.post(
  //       url,
  //       body: {
  //         "phone": "${widget.phone}",
  //         "code": "${code.text}",
  //         "uuid": preferences.getString("uuid"),
  //         "device_id": preferences.getString("fcmToken"),
  //         "device_type": Platform.isIOS ? "ios" : "android",
  //         "lang": preferences.getString("lang"),
  //       },
  //     ).timeout(Duration(seconds: 10), onTimeout: () {
  //       throw 'no internet please connect to internet';
  //     });
  //     final responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       EasyLoading.dismiss();
  //       print(responseData);
  //       if (responseData["key"] == "success") {
  //         Fluttertoast.showToast(msg: tr("registerSuc"));
  //         Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (c) => Login()),
  //           (route) => false,
  //         );
  //       } else {
  //         Fluttertoast.showToast(msg: responseData["msg"]);
  //       }
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     print("fail 222222222   $e}");
  //   }
  // }
  Future activeAccount() async {
    setState(() => loading = true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString("device_id"));
    print(uuid);

    Uri url = Uri.http(URL, "api/active-code", {
      "lang": preferences.getString("lang"),
      "phone": "${widget.phone}",
      "code": "${code.text}",
      "device_id": preferences.getString("device_id"),
      "device_type": Platform.isIOS ? "ios" : "android",
      "uuid": "$uuid",
    });
    //print(url);
    try {
      if(code.text == "1234"){

      }
      final response =
          await http.post(url).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          VisitorProvider visitorProvider =
              Provider.of<VisitorProvider>(context, listen: false);
          visitorProvider.visitor = false;
          //print(responseData);
          UserProvider userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.user.id = responseData["data"]["user"]["id"];
          userProvider.user.name = responseData["data"]["user"]["name"];
          userProvider.user.phone = responseData["data"]["user"]["phone"];
          userProvider.user.email = responseData["data"]["user"]["email"];
          userProvider.user.avatar = responseData["data"]["user"]["avatar"];
          userProvider.user.token = responseData["data"]["token"];

          preferences.setString(
              "userId", responseData["data"]["user"]["id"].toString());
          preferences.setString("name", responseData["data"]["user"]["name"]);
          preferences.setString("phone", responseData["data"]["user"]["phone"]);
          preferences.setString("email", responseData["data"]["user"]["email"]);
          preferences.setString("token", responseData["data"]["token"]);
          preferences.setString(
              "image", responseData["data"]["user"]["avatar"]);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Home()),
            (route) => false,
          );
        } else {
          print("========> login08");
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      setState(() => loading = false);
      Fluttertoast.showToast(msg: e.toString());
      print("fail 222222222   $e}");
    }
  }

  Future resendCode() async {
    LoadingDialog.showLoadingDialog();
    print("========> resendCode");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(URL, "api/send-active-code", {
      "phone": "${widget.phone}",
    });
    try {
      final response = await http
          .get(
        url,
      )
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          Fluttertoast.showToast(msg: responseData["msg"]);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("fail 222222222   $e}");
    }
  }
}

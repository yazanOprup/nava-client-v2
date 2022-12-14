import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomBackButton.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/models/AboutModel.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../res.dart';
import '../contact_us/mainContactUs.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool isLoading = true;
  String desc;

  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    getAbout();
    super.initState();
  }
   final TextStyle _texStyle = TextStyle(
    color: MyColors.offPrimary,

    height: 1.7
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(tr("about"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(ctx: context),
      ),
      body: loading
          ? MyLoading()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyColors.containerColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  aboutModel.data.desc,
                  style: _texStyle,
                ),
              ),
            ),
    );
  }

  bool loading = true;
  AboutModel aboutModel = AboutModel();
  Future getAbout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(URL, "api/about");
    try {
      final response = await http.get(url,
          // body: {"lang":preferences.getString("lang")},
          headers: {
            "lang": preferences.getString("lang")
          }).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      //print(responseData);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          print("=============> yazan");
          aboutModel = AboutModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      print("fail 222222222   $e}");
    }
  }
}

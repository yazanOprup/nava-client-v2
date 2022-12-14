import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/models/TermsModel.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/constants/DioBase.dart';
import '../../../helpers/customs/CustomBackButton.dart';
import '../../../res.dart';
import '../contact_us/mainContactUs.dart';

class Terms extends StatefulWidget {
  final String from;

  const Terms({Key key, this.from}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TermsState();
  }
}

class _TermsState extends State<Terms> {
  String desc;
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getTerms();
    super.initState();
  }
  final TextStyle _texStyle = TextStyle(
    color: MyColors.offPrimary,

    height: 1.7
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(tr("terms"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(ctx: context),
      ),
      key: _scaffold,
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
                  termsModel.data.desc,
                  style: _texStyle,
                ),
              ),
            ),
    );
  }

  bool loading = true;
  TermsModel termsModel = TermsModel();
  Future getTerms() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("========> login");
    print(preferences.getString("fcm_token"));
    final url = Uri.http(URL, "api/policy");
    try {
      final response = await http.post(
        url,
        body: {"lang": preferences.getString("lang")},
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          termsModel = TermsModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      print("fail 222222222   $e}");
    }
  }

  DioBase dioBase = DioBase();
  // Future getTerms() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   Map<String, String> headers = {
  //     "Authorization": "Bearer ${preferences.getString("token")}"
  //   };
  //   dioBase
  //       .get("policy", headers: headers)
  //       .then((response) {
  //     if (response.data["key"] == "success") {
  //       setState(() {
  //         loading = false;
  //       });
  //       desc = response.data["data"]["termsConditions"];
  //     } else {
  //       print("------------------------else");
  //       Fluttertoast.showToast(msg: response.data["msg"]);
  //     }
  //   });
  // }
}

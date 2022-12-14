import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/helpers/providers/visitor_provider.dart';
import 'package:nava/layouts/Home/Home.dart';
import 'package:nava/layouts/auth/active_account/ActiveAccount.dart';
import 'package:nava/layouts/auth/login/Login.dart';
import 'package:nava/layouts/settings/terms/Terms.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController mail = new TextEditingController();
  TextEditingController bank = new TextEditingController();
  bool terms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        backgroundColor: MyColors.secondary.withOpacity(.5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: MyColors.offPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: MyColors.secondary.withOpacity(.5),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage(Res.splash), fit: BoxFit.cover)),
        child: Center(
          child: ListView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    child: Image(
                      image: AssetImage(Res.logo),
                      fit: BoxFit.contain,
                      height: 100,
                    ),
                  ),
                  Text(
                    tr("register"),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: MyColors.offPrimary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      tr("joinUs"),
                      style: TextStyle(
                        fontSize: 12,
                        color: MyColors.grey,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichTextFiled(
                            controller: name,
                            label: tr("name"),
                            type: TextInputType.name,
                            margin: EdgeInsets.only(
                              top: 15,
                            ),
                            action: TextInputAction.next,
                          ),
                          RichTextFiled(
                            controller: phone,
                            label: tr("phone"),
                            type: TextInputType.phone,
                            margin: EdgeInsets.only(
                              top: 15,
                            ),
                            icon: Container(
                              width: 90,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image(
                                    image: ExactAssetImage(Res.saudiarabia),
                                    width: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Text(
                                      "996+",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          RichTextFiled(
                            controller: mail,
                            label: "${tr("mail")} ( ${tr("optional")} )",
                            type: TextInputType.emailAddress,
                            margin: EdgeInsets.only(
                              top: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        terms = !terms;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Icon(
                                        terms
                                            ? Icons.check_box_rounded
                                            : Icons.check_box_outline_blank,
                                        color: MyColors.primary,
                                        size: 28,
                                      ),
                                    )),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (c) => Terms(
                                                    from: "register",
                                                  )));
                                    },
                                    child: Text(
                                      tr("acceptTerms"),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.offPrimary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          loading
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: SpinKitDoubleBounce(
                                      color: MyColors.accent, size: 30.0))
                              : CustomButton(
                                  title: tr("register"),
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  onTap: () {
                                    if (terms) {
                                      // register();
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: tr("plzAcceptTerms"),
                                      );
                                    }
                                  },
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .3,
                                height: 2,
                                color: MyColors.grey.withOpacity(.4),
                              ),
                              Text(
                                tr("haveAccount"),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.offPrimary,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .3,
                                height: 2,
                                color: MyColors.grey.withOpacity(.4),
                              ),
                            ],
                          ),
                          CustomButton(
                            title: tr("login"),
                            color: MyColors.secondary,
                            borderColor: MyColors.primary,
                            textColor: MyColors.primary,
                            margin: EdgeInsets.symmetric(vertical: 15),
                            height: MediaQuery.of(context).size.height * 0.065,
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (c) => Login()));
                              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c)=>Login()), (route) => false);
                            },
                          ),
                          InkWell(
                            // onTap: () =>
                            //     setVisitor(),
                            child: Center(
                              child: Text(
                                tr("skipLogin"),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: MyColors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool loading = false;
  Future register() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("========> login00");
    setState(() => loading = true);
    final url = Uri.https(URL, "api/user/sign-up", {
      "lang": preferences.getString("lang"),
    });
    print("========> login01");
    try {
      print("========> login02");
      final response = await http.post(
        url,
        body: {
          "name": "${name.text}",
          "phone": "${phone.text}",
          "email": "${mail.text}",
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
          Fluttertoast.showToast(msg: tr("loginSuccessPlzActive"));
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (c) => ActiveAccount(
                      phone: phone.text,
                    )),
          );
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("========> login09");
      print("error : $e ,,,, track : $t");
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

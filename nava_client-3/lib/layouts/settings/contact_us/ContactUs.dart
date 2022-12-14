import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mdi/mdi.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/LabelTextField.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/helpers/models/ContactModel.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../res.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController tsupport = new TextEditingController();
  TextEditingController mtech = new TextEditingController();
  var formKey = GlobalKey<FormState>();
  // TextEditingController _msg = new TextEditingController();

  @override
  void initState() {
    // getContact();
    super.initState();
  }

  bool isLoading = false;
  // Future contactUs() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   print("------------ contactUs ------------");
  //   setState(() => isLoading = true);
  //   final url = Uri.https(URL, "api/contact-us");
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
  //       body: {
  //         "lang": preferences.getString("lang"),
  //         "messageTechnical": tsupport.text,
  //         "messageTechnicalSupport": mtech.text,
  //         // "message": _msg.text,
  //       },
  //     ).timeout(Duration(seconds: 7), onTimeout: () {
  //       throw 'no internet please connect to internet';
  //     });
  //     final responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       setState(() => isLoading = false);
  //       print(responseData);
  //       if (responseData["key"] == "success") {
  //         tsupport.text = "";
  //         mtech.text = "";
  //         // _msg.text = "";
  //         print("------------ success ------------");
  //         Fluttertoast.showToast(msg: responseData["msg"]);
  //       } else {
  //         Fluttertoast.showToast(msg: responseData["msg"]);
  //       }
  //     }
  //   } catch (e) {
  //     print("fail 222222222   $e");
  //     setState(() => isLoading = false);
  //     Fluttertoast.showToast(msg: tr("netError"));
  //   }
  // }
  Future<void>MessageView() async {


    // Getting value from Controller

    String Message = mtech.text;


    // API URL
    var phpurl = 'http://10.0.2.2:8000/safe_road/login.php';

    var res = await http.post(Uri.parse(phpurl), body: {
      "Message": Message,

    });
    var data = json.decode(res.body);
    var test = data['success'];
    if (test == 1) {
// obtain shared preferences
// set value
//       globals.user_id = data['user_id'];
//       print(globals.user_id);
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SelectPage(),
//           ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("contactUs"),
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            AppBarFoot(),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage(Res.splash), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 110,
                height: 160,
                margin: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Res.logo), fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 55),
                child: Form(
                  key:formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${tr("messageTechnicalSupport")}",
                      ),
                      LabelTextField(
                        margin: EdgeInsets.only(top: 5),
                        label: tr("enterYourMsg"),
                        type: TextInputType.text,
                        lines: 7,
                        controller:mtech,
                      ),

                      /*Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          tr("yourMsg"),
                        ),
                      ),
                      LabelTextField(
                        margin: EdgeInsets.only(top: 5),
                        label: tr("enterYourMsg"),
                        type: TextInputType.emailAddress,
                        lines: 7,
                        controller: _msg,
                      ),*/
                      isLoading
                          ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: SpinKitDoubleBounce(
                              color: MyColors.accent, size: 30.0))
                          : CustomButton(
                        title: tr("send"),
                        onTap: () {
                          if(mtech.text.isEmpty)
                          {
                            Alert(context: context, title: tr("completeMessageTechnicalSupport")).show();



                          }
                          else{MessageView();
                          ContactUs();
                          // mtech.text="";
                          Alert(context: context, title: tr("hasBeenSent2")).show();}
                          // {
                          //    contactUs();
                          //
                          //  } if(tsupport=="") {
                          //    Fluttertoast.showToast(
                          //        msg: tr("plzFillFields"));
                          //  }
                        },
                        margin: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 30),
                      ),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              tr("viaSocial"),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.primary),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                tr("contactViaSocial"),
                                style: TextStyle(
                                    fontSize: 13, color: MyColors.offPrimary),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            loading
                                ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15),
                              child: SpinKitThreeBounce(
                                  color: MyColors.accent, size: 30.0),
                            )
                                : Container(
                              height: 70,
                              width:
                              MediaQuery.of(context).size.width * .5,
                              margin: EdgeInsets.only(
                                bottom: 30,
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      launchURL(
                                          url: contactModel
                                              .data.socialData[0].value);
                                    },
                                    child: Icon(Mdi.facebook,
                                        size: 50,
                                        color: Colors.indigoAccent),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launchURL(
                                          url: contactModel
                                              .data.socialData[1].value);
                                    },
                                    child: Icon(Mdi.twitter,
                                        size: 50, color: Colors.blue),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launchURL(
                                          url: contactModel
                                              .data.socialData[2].value);
                                    },
                                    child: Icon(Mdi.instagram,
                                        size: 50,
                                        color: Colors.redAccent),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launchURL(
                                          url: contactModel
                                              .data.socialData[3].value);
                                    },
                                    child: Icon(Mdi.linkedin,
                                        size: 46.3,
                                        color: Colors.lightBlueAccent),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void launchURL({String url}) async {
    if (!url.toString().startsWith("https")) {
      url = "https://" + url;
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: "checkLink",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  bool loading = true;
  ContactModel contactModel = ContactModel();
  // Future getContact() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final url = Uri.https(URL, "api/site-data");
  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {"lang": preferences.getString("lang")},
  //     ).timeout(Duration(seconds: 10), onTimeout: () {
  //       throw 'no internet please connect to internet';
  //     });
  //     final responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       setState(() => loading = false);
  //       print(responseData);
  //       if (responseData["key"] == "success") {
  //         contactModel = ContactModel.fromJson(responseData);
  //       } else {
  //         Fluttertoast.showToast(msg: responseData["msg"]);
  //       }
  //     }
  //   } catch (e) {
  //     print("error $e");
  //   }
  // }
}

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mdi/mdi.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/LabelTextField.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/helpers/models/ContactModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../res.dart';

import '../../../helpers/customs/CustomBackButton.dart';
import '../../../helpers/customs/Loading.dart';
import '../../Home/orders/ChatScreen.dart';
import 'ContactUs.dart';
import 'contactus_withTech.dart';

class MainContactUs extends StatefulWidget {
  @override
  _MainContactUsState createState() => _MainContactUsState();
}

class _MainContactUsState extends State<MainContactUs> {
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController tsupport = new TextEditingController();
  TextEditingController mtech = new TextEditingController();

  // TextEditingController _msg = new TextEditingController();

  @override
  void initState() {
    getContact();
    super.initState();
  }

  bool isLoading = false;
  Future contactUs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("------------ contactUs ------------");
    setState(() => isLoading = true);
    final url = Uri.https(URL, "api/contact-us");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "tsupport": tsupport.text,
          "mtech": mtech.text,
          // "message": _msg.text,
        },
      ).timeout(Duration(seconds: 7), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => isLoading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          tsupport.text = "";
          mtech.text = "";
          // _msg.text = "";
          print("------------ success ------------");
          Fluttertoast.showToast(msg: responseData["msg"]);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      print("fail 222222222   $e");
      setState(() => isLoading = false);
      Fluttertoast.showToast(msg: tr("netError"));
    }
  }

  final Map<String, String> _messageData = {
    "name": "",
    "mail": "",
    "message": ""
  };

  Future _sentMessage(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      try {
        // await Provider.of<ContactUsViewModel>(context, listen: false)
        //     .sentMessage(_messageData);
        Future.delayed(Duration(seconds: 2)).then((value) => setState(() {
          isLoading = false;
        }));
        
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(tr("contactUs"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(ctx: context),
      ),
      body: isLoading
          ? MyLoading()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.zero,
                        hintText: tr("name"),
                        hintStyle: TextStyle(
                          color: MyColors.textSettings,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color(0xffEEEEEE),
                            width: 1,
                          ),
                        ),
                      ),
                      onSaved: (value) {
                        _messageData['name'] = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your mail";
                        } else {
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (!emailValid) {
                            return "Please enter a valid email";
                          }
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.zero,
                        hintText: tr("mail"),
                        hintStyle: TextStyle(
                          color: MyColors.textSettings,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color(0xffEEEEEE),
                            width: 1,
                          ),
                        ),
                      ),
                      onSaved: (value) {
                        _messageData['mail'] = value.trim();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please add message";
                        }
                        return null;
                      },
                      minLines: 7,
                      maxLines: 9,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.zero,
                        hintText: tr("writeMsg"),
                        hintStyle: TextStyle(
                          color: MyColors.textSettings,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color(0xffEEEEEE),
                            width: 1,
                          ),
                        ),
                      ),
                      onSaved: (value) {
                        _messageData['message'] = value;
                      },
                    ),
                    SizedBox(
                      height: height * 0.15,
                    ),
                    SizedBox(
                      height: height * 0.19,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColors.primary,
                                    elevation: 0,
                                    padding: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () => _sentMessage(context),
                                  child: Text(
                                    tr("send"),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                tr("viaSocial"),
                                style: const TextStyle(
                                  color: Color(0xff2BC3F3),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SocialIcon(
                                    icon: FaIcon(FontAwesomeIcons.facebook,),
                                    url: "https://www.facebook.com",
                                  ),
                                  SocialIcon(
                                    icon: FaIcon(FontAwesomeIcons.instagram,),
                                    url: "https://www.instagram.com",
                                  ),
                                  SocialIcon(
                                    icon: FaIcon(FontAwesomeIcons.youtube,),
                                    url: "https://www.youtube.com",
                                  ),
                                  SocialIcon(
                                    icon: FaIcon(FontAwesomeIcons.linkedin,),
                                    url: "https://www.linkedin.com",
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   child: SvgPicture.asset("assets/images/social-group.svg"),
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
  Future getContact() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/site-data");
    try {
      final response = await http.get(
        url,
        headers: {"lang": preferences.getString("lang")},
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          contactModel = ContactModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      print("error $e");
    }
  }
}

class SocialIcon extends StatelessWidget {
    final FaIcon icon;
    final String url;
    SocialIcon({this.icon,this.url});
  
    @override
    Widget build(BuildContext context) {
      return IconButton(onPressed: (){}, icon: icon);
    }
  }

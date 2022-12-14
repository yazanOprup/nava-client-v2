import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';
import '../../settings/contact_us/mainContactUs.dart';
import '../Home.dart';

class RejectReason extends StatefulWidget {
  final int billNo;
  RejectReason(this.billNo);
  @override
  _RejectReasonState createState() => _RejectReasonState();
}

class _RejectReasonState extends State<RejectReason> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController _reason = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.greyWhite,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("rejectReason"),
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (c) => MainContactUs()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image(
                      image: ExactAssetImage(Res.contactus),
                      width: 26,
                    ),
                  ),
                )
              ],
            ),
            AppBarFoot(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RichTextFiled(
              height: MediaQuery.of(context).size.height * .6,
              max: 500,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              controller: _reason,
              label: tr("writeRejectReason"),
              labelColor: MyColors.grey,
              type: TextInputType.text,
            ),
            CustomButton(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              title: tr("send"),
              onTap: () {
                // sendRejectionReason(widget.billNo, _reason.text);
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (c) => Home()),
                //     (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Future sendRejectionReason(int billNo, String reason) async {
  //   LoadingDialog.showLoadingDialog();
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final url = Uri.https(
  //     URL,
  //     "api/refuse-invoice",
  //     {
  //       "lang": preferences.getString("lang"),
  //       "bill_id": billNo.toString(),
  //       "refuse_reason": reason
  //     },
  //   );
  //   try {
  //     final response = await http.get(url, headers: {
  //       "Authorization": "Bearer ${preferences.getString("token")}"
  //     }).timeout(
  //       Duration(seconds: 7),
  //       onTimeout: () => throw 'no internet please connect to internet',
  //     );
  //     final responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       EasyLoading.dismiss();
  //       print(responseData);
  //       if (responseData["key"] == "success") {
  //         Fluttertoast.showToast(msg: responseData["msg"]);
  //         return responseData["key"];
  //       } else {
  //         Fluttertoast.showToast(msg: responseData["msg"]);
  //         return responseData["key"];
  //       }
  //     }
  //   } catch (e, t) {
  //     print("error $e   track $t");
  //   }
  // }
}

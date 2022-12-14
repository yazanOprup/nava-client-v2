import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/Badge.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  GlobalKey<ScaffoldState> _scaffold=new GlobalKey();
  GlobalKey<FormState> _formKey=new GlobalKey();
  TextEditingController oldPass=new TextEditingController();
  TextEditingController newPass=new TextEditingController();
  TextEditingController newPass2=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      backgroundColor: MyColors.secondary,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("changePass"), style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) => ContactUs()));
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
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage(Res.splash),fit: BoxFit.cover)),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr("oldPass"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
                RichTextFiled(
                  controller: oldPass,
                  label: tr("oldPass"),
                  type: TextInputType.text,
                  margin: EdgeInsets.only(top: 8,bottom: 10),
                  action: TextInputAction.next,
                ),
                Text(tr("newPass"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
                RichTextFiled(
                  controller: newPass,
                  label: tr("newPass"),
                  type: TextInputType.text,
                  margin: EdgeInsets.only(top: 8,bottom: 10),
                  action: TextInputAction.next,
                ),
                Text(tr("confirmPass"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
                RichTextFiled(
                  controller: newPass2,
                  label: tr("confirmPass"),
                  type: TextInputType.text,
                  margin: EdgeInsets.only(top: 8,bottom: 10),
                  action: TextInputAction.done,
                ),

                Spacer(),
                CustomButton(
                  title: tr("confirm"),
                  margin: EdgeInsets.symmetric(vertical: 0),
                  onTap: (){
                    if(newPass.text != newPass2.text){
                      Fluttertoast.showToast(msg: tr("unMatchPass"));
                    }else{
                      // changePassword();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DioBase dioBase = DioBase();
  // Future changePassword() async {
  //   LoadingDialog.showLoadingDialog();
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   Map<String, String> headers = {"Authorization": "Bearer ${preferences.getString("token")}"};
  //   FormData bodyData = FormData.fromMap({
  //     "lang": preferences.getString("lang"),
  //     "old_password": oldPass.text,
  //     "new_password": newPass.text,
  //   });
  //   dioBase.post("change-password", body: bodyData, headers: headers).then((response) {
  //     if (response.statusCode == 200) {
  //       EasyLoading.dismiss();
  //       if (response.data["key"] == "success") {
  //         Fluttertoast.showToast(msg: response.data["msg"]);
  //         oldPass.text="";
  //         newPass.text="";
  //         newPass2.text="";
  //       } else {
  //         print("---------------------------------------else else");
  //         Fluttertoast.showToast(msg: response.data["msg"]);
  //       }
  //     } else {
  //       EasyLoading.dismiss();
  //       Fluttertoast.showToast(msg: response.data["msg"]);
  //     }
  //   });
  // }

}

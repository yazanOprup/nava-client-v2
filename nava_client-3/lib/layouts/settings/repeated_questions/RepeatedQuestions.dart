import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';


import '../../../helpers/constants/MyColors.dart';
import '../../../helpers/constants/base.dart';
import '../../../helpers/customs/CustomBackButton.dart';
import '../../../helpers/customs/Loading.dart';
import '../../../helpers/models/FQsModel.dart';

class FQs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FQsState();
  }
}

class _FQsState extends State<FQs> {
  @override
  void initState() {
    getFQs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text(tr("popQuestions"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(ctx: context),
      ),
      body: loading
          ? MyLoading()
          : Container(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: fQsModel.data.length,
                itemBuilder: (c, i) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        fQsModel.data[i].open = fQsModel.data[i].open;
                      });
                    },
                    child: questionItem(
                      question: fQsModel.data[i].question,
                      answer: fQsModel.data[i].answer,
                      open: fQsModel.data[i].open,
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget questionItem({String question, answer, bool open}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: MyColors.containerColor,
              borderRadius: BorderRadius.circular(5),
              // border: Border.all(
              //   width: 1.5,
              //   color: MyColors.grey.withOpacity(.4),
              // ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    question,
                    style: TextStyle(
                      //color: open ? MyColors.white : MyColors.primary,
                      fontSize: 15,
                      //fontWeight: FontWeight.bold,
                      color: MyColors.textSettings
                    ),
                  ),
                  Icon(
                    open ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                    color: MyColors.textSettings
                  ),
                ],
              ),
            ),
          ),
          if (open)
            const SizedBox(
              height: 10,
            ),
          open
              ? Container(
                  //margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(10),
                  // height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: MyColors.containerColor,
                    borderRadius: BorderRadius.circular(5),
                    
                  ),
                  child: Text(
                    answer,
                    style: TextStyle(
                      fontSize: 15,
                      color: MyColors.textSettings
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  bool loading = true;
  FQsModel fQsModel = FQsModel();
  Future getFQs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(URL, "api/questions");
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
          fQsModel = FQsModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      print("fail 222222222   $e}");
    }
  }
}

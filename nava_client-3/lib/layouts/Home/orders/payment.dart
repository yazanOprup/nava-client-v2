import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/layouts/Home/cart/MadaWebView.dart';
import 'package:nava/layouts/Home/cart/VisaWebView.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';
import '../../settings/contact_us/mainContactUs.dart';
import 'SuccessfulOrder.dart';

enum PayType { visa, mada, cash, wallet }

class Pay extends StatefulWidget {
  final int orderId;

  const Pay({Key key, this.orderId}) : super(key: key);

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  PayType type = PayType.visa;
  String payment = "visa";

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
              title: Text('الدفع',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        tr("selectPayType"),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MyColors.offPrimary),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          type = PayType.visa;
                          payment = "visa";
                        });
                        print(payment);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                              activeColor: MyColors.accent,
                              hoverColor: MyColors.white,
                              focusColor: MyColors.white,
                              value: PayType.visa,
                              groupValue: type,
                              onChanged: (PayType value) {
                                setState(() {
                                  print(value);
                                  type = value;
                                  payment = "visa";
                                });
                                print(payment);
                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image(
                              image: ExactAssetImage(Res.visa),
                              width: 40,
                            ),
                          ),
                          Text(
                            tr("visa"),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: payment == "visa"
                                    ? MyColors.primary
                                    : MyColors.grey),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          type = PayType.mada;
                          payment = "apple";
                        });
                        print(payment);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                              activeColor: MyColors.accent,
                              hoverColor: MyColors.white,
                              focusColor: MyColors.white,
                              value: PayType.mada,
                              groupValue: type,
                              onChanged: (PayType value) {
                                setState(() {
                                  print(value);
                                  type = value;
                                  payment = "mada";
                                });
                                print(payment);
                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image(
                              image: ExactAssetImage(Res.mada),
                              width: 40,
                            ),
                          ),
                          Text(
                            tr("mada"),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: payment == "mada"
                                    ? MyColors.primary
                                    : MyColors.grey),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          type = PayType.cash;
                          payment = "cash";
                        });
                        print(payment);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                              activeColor: MyColors.accent,
                              hoverColor: MyColors.white,
                              focusColor: MyColors.white,
                              value: PayType.cash,
                              groupValue: type,
                              onChanged: (PayType value) {
                                setState(() {
                                  print(value);
                                  type = value;
                                  payment = "cash";
                                });
                                print(payment);
                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image(
                              image: ExactAssetImage(Res.cashpayment),
                              width: 40,
                            ),
                          ),
                          Text(
                            tr("cash"),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: payment == "cash"
                                    ? MyColors.primary
                                    : MyColors.grey),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          type = PayType.wallet;
                          payment = "wallet";
                        });
                        print(payment);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                              activeColor: MyColors.accent,
                              value: PayType.wallet,
                              groupValue: type,
                              onChanged: (PayType value) {
                                setState(() {
                                  print(value);
                                  type = value;
                                  payment = "wallet";
                                });
                                print(payment);
                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image(
                              image: ExactAssetImage(Res.wallet),
                              width: 35,
                            ),
                          ),
                          Text(
                            tr("wallet"),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: payment == "wallet"
                                    ? MyColors.primary
                                    : MyColors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            CustomButton(
                margin: EdgeInsets.symmetric(vertical: 5),
                title: 'دفع الفاتورة',
                onTap: () {
                  if (type == PayType.cash || type == PayType.wallet) {
                    payWithWalletOrCash(widget.orderId).then(
                      (value) {
                        if (value == 'success') {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (c) => SuccessfulOrder()),
                              (route) => false);
                        }
                      },
                    );
                  } else if (type == PayType.visa) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (c) => VisaWebView(
                                  orderId: widget.orderId,
                                )),
                        (route) => false);
                  } else if (type == PayType.mada) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (c) => MadaWebView(
                                  orderId: widget.orderId,
                                )),
                        (route) => false);
                  }
                }),
          ],
        ),
      ),
    );
  }

  Future payWithWalletOrCash(int billNo) async {
    String endPoint;
    if (type == PayType.cash) {
      endPoint = "api/pay-cash";
    } else if (type == PayType.wallet) {
      endPoint = "api/wallet-pay";
    }
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(
      URL,
      endPoint,
      {
        "lang": preferences.getString("lang"),
        "order_id": billNo.toString(),
      },
    );
    print(url);
    try {
      final response = await http.get(url, headers: {
        "Authorization": "Bearer ${preferences.getString("token")}"
      }).timeout(
        Duration(seconds: 7),
        onTimeout: () => throw 'no internet please connect to internet',
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          Fluttertoast.showToast(msg: responseData["msg"]);
          return responseData["key"];
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
          return responseData["key"];
        }
      }
    } catch (e, t) {
      print("error $e   track $t");
    }
  }
}

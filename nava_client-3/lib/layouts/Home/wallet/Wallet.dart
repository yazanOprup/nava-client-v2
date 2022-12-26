import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/helpers/customs/Visitor.dart';
import 'package:nava/helpers/providers/visitor_provider.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';
import '../../settings/contact_us/mainContactUs.dart';
import 'charge_wallet_mada.dart';
import 'charge_wallet_visa.dart';

enum PayType { visa, mada, cash, wallet }

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  PayType type = PayType.visa;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    getWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VisitorProvider visitorProvider =
        Provider.of<VisitorProvider>(context, listen: false);
    return Scaffold(
      //backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(tr("wallet"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        //leading: CustomBackButton(ctx: context),
      ),
      body: visitorProvider.visitor
          ? Visitor()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MyColors.containerColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      title: Text(
                        tr("currentBalance"),
                        style: TextStyle(
                          color: MyColors.textSettings,
                        ),
                      ),
                      trailing: Text(
                        "$wallet ${tr("rs")}",
                        style:
                            TextStyle(fontFamily: 'Tajawal-Bold', fontSize: 20),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      RichTextFiled(
                        controller: controller,
                        label: "chargeValue".tr(),
                        type: TextInputType.number,
                        margin: EdgeInsets.only(top: 8, bottom: 10),
                        action: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr("selectPay"),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.offPrimary,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                type = PayType.visa;
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: MyColors.primary,
                                    value: PayType.visa,
                                    groupValue: type,
                                    onChanged: (PayType value) {
                                      setState(() {
                                        print(value);
                                        type = value;
                                      });
                                    }),
                                Image(
                                  image: ExactAssetImage(Res.visa),
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                type = PayType.mada;
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: MyColors.primary,
                                    hoverColor: MyColors.white,
                                    focusColor: MyColors.white,
                                    value: PayType.mada,
                                    groupValue: type,
                                    onChanged: (PayType value) {
                                      setState(() {
                                        print(value);
                                        type = value;
                                      });
                                    }),
                                Image(
                                  image: ExactAssetImage(Res.mada),
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      CustomButton(
                        title: tr("chargeBalance"),
                        //margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        onTap: () {
                          if (controller.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'من فضلك ادخل قيمة الشحن');
                            return;
                          }
                          if (type == PayType.visa) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChargeWalletVisa(
                                  amount: int.parse(controller.text),
                                  userId: userId,
                                ),
                              ),
                            );
                          } else if (type == PayType.mada) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChargeWalletMada(
                                  amount: int.parse(controller.text),
                                  userId: userId,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
      // body: visitorProvider.visitor
      //     ? Visitor()
      //     : ListView(
      //         padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      //         children: [
      //           Image(
      //             image: ExactAssetImage(Res.wallet3),
      //             height: 100,
      //             width: 50,
      //           ),
      //           Center(
      //               child: Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 15),
      //             child: Text(
      //               tr("currentBalance"),
      //               style: TextStyle(fontSize: 20),
      //             ),
      //           )),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 10),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.end,
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.symmetric(horizontal: 10),
      //                   child: Text(
      //                     wallet,
      //                     style: TextStyle(
      //                         fontSize: 60,
      //                         fontWeight: FontWeight.bold,
      //                         color: MyColors.primary),
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.only(bottom: 12),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         tr("r"),
      //                         style: TextStyle(fontSize: 18),
      //                       ),
      //                       Text(
      //                         tr("s"),
      //                         style: TextStyle(fontSize: 18),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      // RichTextFiled(
      //   controller: controller,
      //   label: "chargeValue".tr(),
      //   type: TextInputType.number,
      //   margin: EdgeInsets.only(top: 8, bottom: 10),
      //   action: TextInputAction.done,
      // ),
      // SizedBox(
      //   height: 10,
      // ),
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text(
      //       tr("selectPay"),
      //       style: TextStyle(
      //         fontSize: 16,
      //         fontWeight: FontWeight.bold,
      //         color: MyColors.offPrimary,
      //       ),
      //     ),
      //     InkWell(
      //       onTap: () {
      //         setState(() {
      //           type = PayType.visa;
      //         });
      //       },
      //       child: Row(
      //         children: <Widget>[
      //           Radio(
      //               activeColor: MyColors.primary,
      //               value: PayType.visa,
      //               groupValue: type,
      //               onChanged: (PayType value) {
      //                 setState(() {
      //                   print(value);
      //                   type = value;
      //                 });
      //               }),
      //           Image(
      //             image: ExactAssetImage(Res.visa),
      //             width: 50,
      //           ),
      //         ],
      //       ),
      //     ),
      //     InkWell(
      //       onTap: () {
      //         setState(() {
      //           type = PayType.mada;
      //         });
      //       },
      //       child: Row(
      //         children: <Widget>[
      //           Radio(
      //               activeColor: MyColors.primary,
      //               hoverColor: MyColors.white,
      //               focusColor: MyColors.white,
      //               value: PayType.mada,
      //               groupValue: type,
      //               onChanged: (PayType value) {
      //                 setState(() {
      //                   print(value);
      //                   type = value;
      //                 });
      //               }),
      //           Image(
      //             image: ExactAssetImage(Res.mada),
      //             width: 50,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      //           SizedBox(
      //             height: 20,
      //           ),
      // CustomButton(
      //   title: tr("chargeBalance"),
      //   //margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      //   onTap: () {
      //     if (controller.text.isEmpty) {
      //       Fluttertoast.showToast(msg: 'من فضلك ادخل قيمة الشحن');
      //       return;
      //     }
      //     if (type == PayType.visa) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => ChargeWalletVisa(
      //             amount: int.parse(controller.text),
      //             userId: userId,
      //           ),
      //         ),
      //       );
      //     } else if (type == PayType.mada) {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => ChargeWalletMada(
      //             amount: int.parse(controller.text),
      //             userId: userId,
      //           ),
      //         ),
      //       );
      //     }
      //   },
      // )
      //         ],
      //       ),
    );
  }

  String wallet = "-";
  int userId;
  bool loading = true;

  Future getWallet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(URL, "api/wallet");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          setState(() {
            wallet = responseData["data"]['wallet'].toString();
            userId = responseData["data"]['user_id'];
          });
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }
}

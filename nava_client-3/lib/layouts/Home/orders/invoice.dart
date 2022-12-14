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
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/models/invoice_model.dart';
import 'package:nava/layouts/Home/orders/RejectReason.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';
import '../../settings/contact_us/mainContactUs.dart';
import 'SuccessfulOrder.dart';

// enum PayType { visa, mada, cash, wallet }

class Invoice extends StatefulWidget {
  final int billNo;

  const Invoice({Key key, this.billNo}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController _coupon = new TextEditingController();

  // PayType type = PayType.visa;
  // String payment = "visa";

  @override
  void initState() {
    // getInvoiceDetails(widget.billNo);
    super.initState();
  }

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
              title: Text(tr("pay"),
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
      body: loading
          ? MyLoading()
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${tr("addedDetails")} :",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          invoiceModel.data.notes ?? 'لا يوجد ملاحظات',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Divider(
                        thickness: .5,
                        color: MyColors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr("vat"),
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  invoiceModel.data.tax.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                tr("rs"),
                                style: TextStyle(
                                    fontSize: 14, color: MyColors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tr("total"),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    invoiceModel.data.price.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  tr("rs"),
                                  style: TextStyle(
                                      fontSize: 14, color: MyColors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Divider(
                      //   thickness: .5,
                      //   color: MyColors.black,
                      // ),
                      // Text(
                      //   "${tr("coupon")}",
                      //   style: TextStyle(
                      //       fontSize: 17, fontWeight: FontWeight.bold),
                      // ),
                      // Form(
                      //   key: _formKey,
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width,
                      //     height: 55,
                      //     margin: EdgeInsets.only(top: 8),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         LabelTextField(
                      //           // margin: EdgeInsets.only(top: 5),
                      //           maxWidth:
                      //               MediaQuery.of(context).size.width * .65,
                      //           minWidth:
                      //               MediaQuery.of(context).size.width * .60,
                      //           label: tr("coupon"),
                      //           type: TextInputType.text,
                      //           controller: _coupon,
                      //         ),
                      //         CustomButton(
                      //           width: MediaQuery.of(context).size.width * .27,
                      //           height: 48,
                      //           color: MyColors.white,
                      //           borderColor: MyColors.primary,
                      //           textColor: MyColors.primary,
                      //           margin: EdgeInsets.only(top: 0),
                      //           borderRadius: BorderRadius.circular(10),
                      //           title: tr("active"),
                      //           onTap: () {
                      //             addCoupon();
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.all(10),
                      //       child: Text(
                      //         tr("selectPayType"),
                      //         style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //             color: MyColors.offPrimary),
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         setState(() {
                      //           type = PayType.visa;
                      //           payment = "visa";
                      //         });
                      //         print(payment);
                      //       },
                      //       child: Row(
                      //         children: <Widget>[
                      //           Radio(
                      //               activeColor: MyColors.accent,
                      //               hoverColor: MyColors.white,
                      //               focusColor: MyColors.white,
                      //               value: PayType.visa,
                      //               groupValue: type,
                      //               onChanged: (PayType value) {
                      //                 setState(() {
                      //                   print(value);
                      //                   type = value;
                      //                   payment = "visa";
                      //                 });
                      //                 print(payment);
                      //               }),
                      //           Padding(
                      //             padding:
                      //                 const EdgeInsets.symmetric(horizontal: 8),
                      //             child: Image(
                      //               image: ExactAssetImage(Res.visa),
                      //               width: 40,
                      //             ),
                      //           ),
                      //           Text(
                      //             tr("visa"),
                      //             style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: payment == "visa"
                      //                     ? MyColors.primary
                      //                     : MyColors.grey),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         setState(() {
                      //           type = PayType.mada;
                      //           payment = "apple";
                      //         });
                      //         print(payment);
                      //       },
                      //       child: Row(
                      //         children: <Widget>[
                      //           Radio(
                      //               activeColor: MyColors.accent,
                      //               hoverColor: MyColors.white,
                      //               focusColor: MyColors.white,
                      //               value: PayType.mada,
                      //               groupValue: type,
                      //               onChanged: (PayType value) {
                      //                 setState(() {
                      //                   print(value);
                      //                   type = value;
                      //                   payment = "mada";
                      //                 });
                      //                 print(payment);
                      //               }),
                      //           Padding(
                      //             padding:
                      //                 const EdgeInsets.symmetric(horizontal: 8),
                      //             child: Image(
                      //               image: ExactAssetImage(Res.mada),
                      //               width: 40,
                      //             ),
                      //           ),
                      //           Text(
                      //             tr("mada"),
                      //             style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: payment == "mada"
                      //                     ? MyColors.primary
                      //                     : MyColors.grey),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         setState(() {
                      //           type = PayType.cash;
                      //           payment = "cash";
                      //         });
                      //         print(payment);
                      //       },
                      //       child: Row(
                      //         children: <Widget>[
                      //           Radio(
                      //               activeColor: MyColors.accent,
                      //               hoverColor: MyColors.white,
                      //               focusColor: MyColors.white,
                      //               value: PayType.cash,
                      //               groupValue: type,
                      //               onChanged: (PayType value) {
                      //                 setState(() {
                      //                   print(value);
                      //                   type = value;
                      //                   payment = "cash";
                      //                 });
                      //                 print(payment);
                      //               }),
                      //           Padding(
                      //             padding:
                      //                 const EdgeInsets.symmetric(horizontal: 8),
                      //             child: Image(
                      //               image: ExactAssetImage(Res.cashpayment),
                      //               width: 40,
                      //             ),
                      //           ),
                      //           Text(
                      //             tr("cash"),
                      //             style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: payment == "cash"
                      //                     ? MyColors.primary
                      //                     : MyColors.grey),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         setState(() {
                      //           type = PayType.wallet;
                      //           payment = "wallet";
                      //         });
                      //         print(payment);
                      //       },
                      //       child: Row(
                      //         children: <Widget>[
                      //           Radio(
                      //               activeColor: MyColors.accent,
                      //               value: PayType.wallet,
                      //               groupValue: type,
                      //               onChanged: (PayType value) {
                      //                 setState(() {
                      //                   print(value);
                      //                   type = value;
                      //                   payment = "wallet";
                      //                 });
                      //                 print(payment);
                      //               }),
                      //           Padding(
                      //             padding:
                      //                 const EdgeInsets.symmetric(horizontal: 8),
                      //             child: Image(
                      //               image: ExactAssetImage(Res.wallet),
                      //               width: 35,
                      //             ),
                      //           ),
                      //           Text(
                      //             tr("wallet"),
                      //             style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: payment == "wallet"
                      //                     ? MyColors.primary
                      //                     : MyColors.grey),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomButton(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          title: 'قبول',
                          onTap: () {
                            // if (type == PayType.cash ||
                            //     type == PayType.wallet) {
                            // payInvoiceWithWalletOrCash(invoiceModel.data.id)
                            //     .then(
                            //   (value) {
                            //     if (value == 'success') {
                            //       Navigator.of(context).pushAndRemoveUntil(
                            //           MaterialPageRoute(
                            //               builder: (c) => SuccessfulOrder()),
                            //           (route) => false);
                            //     }
                            //   },
                            // );
                            // } else if (type == PayType.visa) {
                            //   Navigator.of(context).pushAndRemoveUntil(
                            //       MaterialPageRoute(
                            //           builder: (c) => VisaWebViewInvoice(
                            //                 billNo: invoiceModel.data.id,
                            //               )),
                            //       (route) => false);
                            // } else if (type == PayType.mada) {
                            //   Navigator.of(context).pushAndRemoveUntil(
                            //       MaterialPageRoute(
                            //           builder: (c) => MadaWebViewInvoice(
                            //                 billNo: invoiceModel.data.id,
                            //               )),
                            //       (route) => false);
                            // }
                          }),
                      CustomButton(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        title: 'رفض ',
                        color: MyColors.red,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) =>
                                  RejectReason(invoiceModel.data.id)));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  // Future addCoupon() async {
  //   LoadingDialog.showLoadingDialog();
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   print("${preferences.getString("token")}");
  //   print("${preferences.getString("uuid")}");
  //   final url = Uri.https(URL, "api/add-coupon");
  //   try {
  //     final response = await http.post(url, body: {
  //       "lang": preferences.getString("lang"),
  //       "order_id": widget.billNo.toString(),
  //       "coupon": _coupon.text,
  //     }, headers: {
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
  //       } else {
  //         Fluttertoast.showToast(msg: responseData["msg"]);
  //       }
  //     }
  //   } catch (e, t) {
  //     print("error $e   track $t");
  //   }
  // }

  // Future payInvoiceWithWalletOrCash(int billNo) async {
  //   const endPoint = 'api/accept-invoice';
  //   // if (type == PayType.cash) {
  //   //   endPoint = "api/cash-bill-pay";
  //   // } else if (type == PayType.wallet) {
  //   //   endPoint = "api/wallet-bill-pay";
  //   // }
  //   LoadingDialog.showLoadingDialog();
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final url = Uri.https(
  //     URL,
  //     endPoint,
  //     {
  //       "lang": preferences.getString("lang"),
  //       "bill_id": billNo.toString(),
  //     },
  //   );
  //   print(url);
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

  InvoiceModel invoiceModel = InvoiceModel();
  bool loading = true;

  // Future getInvoiceDetails(int billNo) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final url = Uri.https(
  //     URL,
  //     "api/invoice",
  //     {
  //       "lang": preferences.getString("lang"),
  //       "bill_id": billNo.toString(),
  //     },
  //   );
  //   print(url);
  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
  //     ).timeout(Duration(seconds: 10),
  //         onTimeout: () => throw 'no internet please connect to internet');
  //     final responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       setState(() => loading = false);
  //       print(responseData);
  //       if (responseData["key"] == "success") {
  //         invoiceModel = InvoiceModel.fromJson(responseData);
  //       } else {
  //         Navigator.of(context).pop();
  //         Fluttertoast.showToast(msg: responseData["msg"]);
  //       }
  //     }
  //   } catch (e, t) {
  //     print("error $e" + " ==>> track $t");
  //   }
  // }
}

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mdi/mdi.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/EmptyBox.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/models/ProcessingOrdersModel.dart';
import 'package:nava/layouts/Home/orders/ChatScreen.dart';
import 'package:nava/layouts/Home/orders/OrderDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProcessingOrders extends StatefulWidget {
  @override
  _ProcessingOrdersState createState() => _ProcessingOrdersState();
}

class _ProcessingOrdersState extends State<ProcessingOrders> {
  @override
  void initState() {
    getProcessingOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? MyLoading()
          : processingOrdersModel.data.length == 0
              ? EmptyBox(
                  title: tr("noOrders"),
                  widget: Container(),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  itemCount: processingOrdersModel.data.length,
                  itemBuilder: (c, i) {
                    return orderItem(
                      id: processingOrdersModel.data[i].id,
                      title: processingOrdersModel.data[i].categoryTitle,
                      icon: processingOrdersModel.data[i].categoryIcon,
                      orderNum: processingOrdersModel.data[i].orderNum,
                      price: processingOrdersModel.data[i].price,
                      status: processingOrdersModel.data[i].status,
                      roomId: processingOrdersModel.data[i].roomId,
                    );
                  }),
    );
  }

  Widget orderItem(
      {int id, roomId, String title, status, price, orderNum, icon}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => OrderDetails(
                  id: id,
                )));
      },
      child: Container(
        margin: EdgeInsets.only(top: 18, right: 12, left: 12),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: NetworkImage(icon)),
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(status,
                      style: TextStyle(fontSize: 14, color: MyColors.green)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr("totalPrice"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    price + " " + tr("rs"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 2,
              color: Colors.grey.shade400,
              indent: 8,
              endIndent: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr("orderNum"),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(
                    orderNum,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: roomId != 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 8, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr("ContactTheTechnician"),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    Material(
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        splashColor: MyColors.primary,
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                    roomId: roomId,
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Mdi.messageTextOutline,
                            size: 32,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool loading = true;
  ProcessingOrdersModel processingOrdersModel = ProcessingOrdersModel();
  Future getProcessingOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/my-orders/current");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          // "uuid": preferences.getString("uuid"),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          processingOrdersModel = ProcessingOrdersModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }
}

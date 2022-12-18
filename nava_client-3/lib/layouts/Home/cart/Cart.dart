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
import 'package:nava/helpers/models/CartModel.dart';
import 'package:nava/layouts/Home/main/SubCategoryDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/customs/CustomBackButton.dart';
import '../Home.dart';
import 'AddNotesAndImages.dart';
import 'Address.dart';

class Cart extends StatefulWidget {
  final int categoryId;

  const Cart({Key key, this.categoryId}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(tr("orderSummary"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(ctx: context),
      ),
      bottomSheet: loading
          ? MyLoading()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .33,
              decoration: BoxDecoration(
                color: MyColors.secondary,
                //border: Border.all(color: MyColors.grey, width: .5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tr("vat"), style: TextStyle(fontSize: 16)),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                cartModel.data.tax.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.black),
                              ),
                            ),
                            Text(
                              tr("rs"),
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  cartModel.data.total,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.black),
                                ),
                              ),
                              Text(tr("rs"), style: TextStyle(fontSize: 14)),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Divider(
                    //   thickness: 1.5,
                    // ),
                    CustomButton(
                      margin: EdgeInsets.only(top: 8),
                      //color: MyColors.white,
                      //textColor: MyColors.primary,
                      //borderColor: MyColors.primary,
                      title: tr("addNotesAndImages"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (c) => AddNotesAndImages(
                              id: cartModel.data.id,
                            ),
                          ),
                        );
                      },
                    ),
                    CustomButton(
                      margin: EdgeInsets.only(top: 8),
                      title: tr("continue"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (c) => Address(
                              orderId: cartModel.data.id,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
      body: loading
          ? MyLoading()
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemCount: cartModel.data.services.length,
              itemBuilder: (c, i) => cartItem(
                id: cartModel.data.services[i].id,
                index: i,
                img: cartModel.data.services[i].image,
                title: cartModel.data.services[i].title,
              ),
            ),
    );
  }

  Widget cartItem({
    int id,
    int index,
    String title,
    img,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: MyColors.secondary,
        borderRadius: BorderRadius.circular(5),
        //border: Border.all(width: .5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.edit,
                        color: MyColors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        deleteCartItem(id: id.toString());
                      },
                      child: Icon(
                        CupertinoIcons.delete,
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: cartModel.data.services[index].services.length * 30.0,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: cartModel.data.services[index].services.length,
              itemBuilder: (c, i) => cartServiceItem(
                title: cartModel.data.services[index].services[i].title,
                price:
                    cartModel.data.services[index].services[i].price.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cartServiceItem({String title, price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: MyColors.black),
          ),
          Row(
            children: [
              Text(
                price,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                tr("rs"),
                style: TextStyle(fontSize: 12, color: MyColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool loading = true;
  CartModel cartModel = CartModel();
  Future getCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(URL, "api/cart");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "uuid": preferences.getString("uuid"),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        print(responseData);
        if (responseData["key"] == "success") {
          if (responseData["data"]["services"] == null) {
            print("________________________ empty");
            Navigator.of(context).pop();
          } else if (responseData["data"]["total"] == "0") {
            print("________________________ empty []");
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) => Home()), (route) => false);
          } else {
            cartModel = CartModel.fromJson(responseData);
            print("________________________ not");
          }
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  Future deleteCartItem({String id}) async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString("token"));
    print(cartModel.data.id.toString());
    print(id);
    final url = Uri.http(URL, "api/delete-cart-item");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": cartModel.data.id.toString(),
          "sub_category_id": id,
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        print(responseData);
        if (responseData["key"] == "success") {
          getCart();
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      } else {
        print("${response.statusCode}");
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }
}

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:map_launcher/map_launcher.dart' as map;
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/LabelTextField.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/models/CartDetailsModel.dart';
import 'package:nava/layouts/Home/orders/SuccessfulOrder.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';
import '../../settings/contact_us/mainContactUs.dart';

enum PayType { visa, mada, cash, wallet }

class DetailedBill extends StatefulWidget {
  final int orderId;

  const DetailedBill({Key key, this.orderId}) : super(key: key);
  @override
  _DetailedBillState createState() => _DetailedBillState();
}

class _DetailedBillState extends State<DetailedBill> {
  @override
  void initState() {
    print("---------${widget.orderId}");
    print("---------${widget.orderId}");
    getCartDetails().then((value) => _add());
    super.initState();
  }

  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController _coupon = new TextEditingController();
  PayType type = PayType.visa;
  String payment = "visa";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 75),
          child: Column(
            children: [
              AppBar(
                backgroundColor: MyColors.primary,
                elevation: 0,
                title: Text(tr("detailedBill"),
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
                  ),
                ],
              ),
              AppBarFoot(),
            ],
          ),
        ),
        body: loading
            ? MyLoading()
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 15),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cartDetailsModel.data.time == null
                              ? "000000000000000"
                              : cartDetailsModel.data.time,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          cartDetailsModel.data.date,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: .5,
                    color: MyColors.black,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cartDetailsModel.data.categoryTitle,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Image(
                          image: ExactAssetImage(Res.energy),
                          height: 30,
                          color: MyColors.black,
                        )
                      ],
                    ),
                  ),
                  Divider(
                    thickness: .5,
                    color: MyColors.black,
                  ),
                  InkWell(
                    onTap: () async {
                      final coords = map.Coords(
                          cartDetailsModel.data.lat, cartDetailsModel.data.lng);
                      if (await map.MapLauncher.isMapAvailable(
                          map.MapType.google)) {
                        await map.MapLauncher.showMarker(
                          mapType: map.MapType.google,
                          coords: coords,
                          title: 'عنوان العميل',
                          description: '',
                        );
                      } else if (await map.MapLauncher.isMapAvailable(
                          map.MapType.apple)) {
                        await map.MapLauncher.showMarker(
                          mapType: map.MapType.apple,
                          coords: coords,
                          title: 'عنوان العميل',
                          description: '',
                        );
                      }
                      // MapsLauncher.launchCoordinates(
                      //     cartDetailsModel.data.lat, cartDetailsModel.data.lng);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr("address"),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "showMap".tr(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .25,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyColors.offPrimary, width: 1)),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(cartDetailsModel.data.lat,
                            cartDetailsModel.data.lng),
                        zoom: 15,
                      ),
                      markers: Set<Marker>.of(markers.values),
                    ),
                  ),
                  Divider(
                    thickness: .5,
                    color: MyColors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            tr("address"),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyColors.offPrimary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Text(
                                "${tr("city")} : ",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                cartDetailsModel.data.region.toString(),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Text(
                              "${tr("addedNotes")} : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * .6,
                                child: Text(
                                  cartDetailsModel.data.addressNotes.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: .5,
                    color: MyColors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      tr("serviceDetails"),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.offPrimary),
                    ),
                  ),
                  Container(
                    height: 260.0 * cartDetailsModel.data.services.length,
                    child: ListView.builder(
                        itemCount: cartDetailsModel.data.services.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (c, i) {
                          return serviceItem(
                            index: i,
                            img: cartDetailsModel.data.services[i].image,
                            title: cartDetailsModel.data.services[i].title,
                            price: cartDetailsModel.data.services[i].total
                                .toString(),
                          );
                        }),
                  ),
                  Divider(
                    thickness: .5,
                    color: MyColors.black,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Row(
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
                                cartDetailsModel.data.tax.toString(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              tr("rs"),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  cartDetailsModel.data.couponValue != '0'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tr("couponVal"),
                                style: TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                      cartDetailsModel.data.couponValue,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    tr("rs"),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                                total == null
                                    ? cartDetailsModel.data.total
                                    : total.toString(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              tr("rs"),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: .5,
                    color: MyColors.black,
                  ),
                  Text(
                    tr("coupon"),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MyColors.offPrimary),
                  ),
                  AnimatedCrossFade(
                    firstChild: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LabelTextField(
                              margin: EdgeInsets.only(top: 0),
                              maxWidth: MediaQuery.of(context).size.width * .63,
                              minWidth: MediaQuery.of(context).size.width * .60,
                              type: TextInputType.text,
                              controller: _coupon,
                            ),
                            CustomButton(
                              width: MediaQuery.of(context).size.width * .27,
                              margin: EdgeInsets.only(top: 0),
                              borderRadius: BorderRadius.circular(10),
                              title: tr("active"),
                              onTap: () {
                                addCoupon();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    secondChild: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      child: Row(
                        children: [
                          Text(
                            "couponHasBeenAdded".tr(),
                            style: TextStyle(fontSize: 18),
                          ),
                          Spacer(),
                          Icon(
                            Icons.check_circle,
                            color: Colors.greenAccent,
                          )
                        ],
                      ),
                    ),
                    crossFadeState: cartDetailsModel.data.couponValue != '0'
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(seconds: 2),
                  ),
                  Divider(
                    thickness: .5,
                    color: MyColors.black,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr("selectPay"),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.offPrimary),
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
                                activeColor: MyColors.primary,
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
                            Image(
                              image: ExactAssetImage(Res.visa),
                              width: 50,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                tr("visa"),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
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
                            Image(
                              image: ExactAssetImage(Res.mada),
                              width: 50,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                tr("mada"),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
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
                            Image(
                              image: ExactAssetImage(Res.cashpayment),
                              width: 50,
                              height: 30,
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                tr("cash"),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
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
                            Image(
                              image: ExactAssetImage(Res.wallet),
                              width: 40,
                              height: 30,
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                tr("wallet"),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  btnLoading
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: SpinKitDoubleBounce(
                              color: MyColors.primary, size: 25.0))
                      : CustomButton(
                          margin: EdgeInsets.symmetric(vertical: 25),
                          title: "confirmOrder".tr(),
                          onTap: () {
                            // placeOrder();
                            checkPlaceOrder();
                          },
                        ),
                ],
              ),
      ),
    );
  }

  Widget serviceItem({int index, String img, title, price}) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(),
                    image: DecorationImage(
                        image: NetworkImage(img), fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height:
                26.0 * cartDetailsModel.data.services[index].services.length,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    cartDetailsModel.data.services[index].services.length,
                itemBuilder: (c, i) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cartDetailsModel
                              .data.services[index].services[i].title,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: MyColors.primary),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                cartDetailsModel
                                    .data.services[index].services[i].price
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              tr("rs"),
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
          Divider(
            height: 0,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("price"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        price,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      tr("rs"),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  void _add() async {
    var markerIdVal = "1";
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(cartDetailsModel.data.lat, cartDetailsModel.data.lng),
      onTap: () {},
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  double minTotal;
  double maxTotal;
  bool loading = true;
  CartDetailsModel cartDetailsModel = CartDetailsModel();
  Future getCartDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("orderId:" + widget.orderId.toString());
    print(preferences.getString("token"));
    final url = Uri.https(URL, "api/cart-details");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": widget.orderId.toString(),
        },
      ).timeout(Duration(seconds: 10),
          onTimeout: () => throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          cartDetailsModel = CartDetailsModel.fromJson(responseData);
          minTotal =
              double.parse(cartDetailsModel.data.miniOrderCharge.toString());
          maxTotal = double.parse(cartDetailsModel.data.total.toString());
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  var total;
  Future addCoupon() async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/add-coupon");
    try {
      final response = await http.post(url, body: {
        "lang": preferences.getString("lang"),
        "order_id": widget.orderId.toString(),
        "coupon": _coupon.text,
      }, headers: {
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
          print(responseData["data"]["value"]);
          print(responseData["data"]["total"]);
          setState(() {
            cartDetailsModel.data.couponValue = responseData["data"]["value"];
            total = responseData["data"]["total"];
          });
          Fluttertoast.showToast(
            msg: responseData["msg"],
          );
        } else {
          Fluttertoast.showToast(
            msg: responseData["msg"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      }
    } catch (e, t) {
      print("error $e   track $t");
    }
  }

  bool btnLoading = false;
  Future placeOrder() async {
    setState(() {
      btnLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("${preferences.getString("token")}");
    print(widget.orderId);
    // print(payment);
    final url = Uri.https(URL, "api/place-order");
    try {
      final response = await http.post(url, body: {
        "lang": preferences.getString("lang"),
        "order_id": widget.orderId.toString(),
        "pay_type": payment,
      }, headers: {
        "Authorization": "Bearer ${preferences.getString("token")}"
      }).timeout(
        Duration(seconds: 7),
        onTimeout: () => throw 'no internet please connect to internet',
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          btnLoading = false;
        });
        print(responseData);
        if (responseData["key"] == "success") {
          print("place order success");

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => SuccessfulOrder()),
              (route) => false);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e   track $t");
    }
  }

  checkPlaceOrder() {
    print(minTotal);
    print(minTotal);
    print(maxTotal);
    print(maxTotal);
    if (maxTotal < minTotal) {
      showDialog(
          context: context,
          builder: (context) {
            return Container(
              height: 200,
              child: AlertDialog(
                title: Icon(
                  CupertinoIcons.exclamationmark_octagon,
                  color: MyColors.primary,
                  size: 50,
                ),
                content: Container(
                  width: MediaQuery.of(context).size.width * .95,
                  height: MediaQuery.of(context).size.height * .08,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(tr("alert"),style: GoogleFonts.almarai(fontSize: 20,fontWeight: FontWeight.bold),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(tr("alertMsgMin1"),
                              style: GoogleFonts.almarai(fontSize: 14)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(minTotal.toString(),
                                style: GoogleFonts.almarai(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Text(tr("rs"),
                              style: GoogleFonts.almarai(fontSize: 14)),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(tr("alertMsgMin2"),
                            style: GoogleFonts.almarai(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                          title: tr("confirm"),
                          width: 100,
                          onTap: () {
                            placeOrder();
                          }),
                      CustomButton(
                          title: tr("back"),
                          color: MyColors.grey,
                          width: 100,
                          onTap: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                ],
              ),
            );
          });
    } else {
      placeOrder();
    }
  }
}

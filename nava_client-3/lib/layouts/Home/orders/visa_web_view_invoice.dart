import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/layouts/Home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisaWebViewInvoice extends StatefulWidget {
  final int billNo;

  const VisaWebViewInvoice({Key key, this.billNo}) : super(key: key);

  @override
  _VisaWebViewInvoiceState createState() => _VisaWebViewInvoiceState();
}

class _VisaWebViewInvoiceState extends State<VisaWebViewInvoice> {
  GlobalKey<ScaffoldState> _scafold = new GlobalKey<ScaffoldState>();
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  DioBase dioBase = DioBase();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("----------------initState------------");
    flutterWebViewPlugin.close();
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      print("----------------on destroy------------");
    });
    // _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
    //   print("----------------_onStateChanged------------");
    // });
    _onUrlChanged =
        flutterWebViewPlugin.onUrlChanged.listen((String url) async {
          if (mounted) {
            await getListenData(url);
            setState(() {
              visaUrl = url;
            });
            print(
                "------------------------ onUrlChanged --------------------------");
            print("url: $url");
          }
        });
  }

  String visaUrl;
  Response payResponse;

  Future getListenData(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await dioBase.get(url, headers: {
      "Authorization": "Bearer ${preferences.getString("token")}"
    }).then((response) {
      print("test: $url");
      print("test: $response");
      // Fluttertoast.showToast(msg: tr("Something Went Wrong"));
      setState(() {
        payResponse = response;
      });
    }).then((value) {
      return payResponse.data["key"] == "success"
          ? Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => Home()), (route) => false)
          : payResponse.data["key"] == "fail"
          ? Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => Home()), (route) => false)
          : () {};
    });

    // payResponse.data["key"]=="success"?
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false)
    //     :payResponse.data["key"]=="fail"?
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false)
    //     :(){};
  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      key: _scafold,
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        elevation: 0,
        title: Text(tr("visa"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) => Home()), (route) => false);
          },
        ),
      ),
      url:
      "https://navaservices.net/api/pay-invoice-visa?lang=ar&bill_id=${widget
          .billNo}",
    );
  }
}
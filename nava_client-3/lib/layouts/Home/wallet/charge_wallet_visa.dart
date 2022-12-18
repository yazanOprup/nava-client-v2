import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/CustomBackButton.dart';

import '../Home.dart';

class ChargeWalletVisa extends StatefulWidget {
  final int amount;
  final int userId;
  const ChargeWalletVisa({Key key, this.amount, this.userId}) : super(key: key);

  @override
  _ChargeWalletVisaState createState() => _ChargeWalletVisaState();
}

class _ChargeWalletVisaState extends State<ChargeWalletVisa> {
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

    _onUrlChanged =
        flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      if (mounted) {
        if (url == 'https://navaservices.net/api/success') {
          Fluttertoast.showToast(msg: "walletHasBeenCharged".tr());
          // Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (ctx) => Home(
                  index: 2,
                ),
              ),
              (route) => false);
        } else if (url == 'https://navaservices.net/api/fail') {
          Fluttertoast.showToast(msg: "walletHasn'tBeenCharged".tr());
          // Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
        }
        print(
            "------------------------ onUrlChanged --------------------------");
        print("url: $url");
      }
    });
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
    print(widget.userId);
    return WebviewScaffold(
      key: _scafold,
      appBar: AppBar(
        // backgroundColor: MyColors.primary,
        // elevation: 0,
        title: Text(tr("visa"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(
          ctx: context,
        ),
      ),
      url:
          "http://navaservices.net/api/pay-wallet-visa?amount=${widget.amount}&user_id=${widget.userId}",
    );
  }
}

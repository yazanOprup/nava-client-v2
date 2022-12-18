import 'package:flutter/material.dart';

class QrInvoice extends StatelessWidget {
  QrInvoice({this.price, this.date, this.tax});

  final String date;
  final double price;
  final String tax;

  String name = "شركة اعمل نافا للتشغيل والصيانة";
  //double price = 20;

  //final DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Image(
        fit: BoxFit.fill,
        image: NetworkImage(
          "http://95.217.2.114:8090/qrcode/generateQRCode/$name/310685405200003/$date/$price/$tax",
        ),
      ),
    );
  }
}

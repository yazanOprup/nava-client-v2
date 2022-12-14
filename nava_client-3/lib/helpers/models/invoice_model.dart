// To parse this JSON data, do
//
//     final invoiceModel = invoiceModelFromJson(jsonString);

import 'dart:convert';

InvoiceModel invoiceModelFromJson(String str) =>
    InvoiceModel.fromJson(json.decode(str));

String invoiceModelToJson(InvoiceModel data) => json.encode(data.toJson());

class InvoiceModel {
  InvoiceModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        key: json["key"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "msg": msg,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.notes,
    this.tax,
    this.price,
  });

  int id;
  String notes;
  double tax;
  String price;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        notes: json["notes"],
        tax: json["tax"].toDouble(),
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notes": notes,
        "tax": tax,
        "price": price,
      };
}

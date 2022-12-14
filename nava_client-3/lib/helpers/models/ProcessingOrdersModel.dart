// To parse this JSON data, do
//
//     final processingOrdersModel = processingOrdersModelFromJson(jsonString);

import 'dart:convert';

ProcessingOrdersModel processingOrdersModelFromJson(String str) =>
    ProcessingOrdersModel.fromJson(json.decode(str));

String processingOrdersModelToJson(ProcessingOrdersModel data) =>
    json.encode(data.toJson());

class ProcessingOrdersModel {
  ProcessingOrdersModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  List<Datum> data;

  factory ProcessingOrdersModel.fromJson(Map<String, dynamic> json) =>
      ProcessingOrdersModel(
        key: json["key"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {this.id,
      this.orderNum,
      this.categoryTitle,
      this.price,
      this.status,
      this.roomId,
      this.categoryIcon});

  int id;
  String orderNum;
  String categoryTitle;
  String categoryIcon;
  String price;
  String status;
  int roomId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderNum: json["order_num"],
        categoryTitle: json["category_title"],
        categoryIcon: json["category_icon"],
        price: json["price"],
        status: json["status"],
        roomId: json["room_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_num": orderNum,
        "category_title": categoryTitle,
        "category_icon": categoryIcon,
        "price": price,
        "status": status,
        "room_id": roomId,
      };
}

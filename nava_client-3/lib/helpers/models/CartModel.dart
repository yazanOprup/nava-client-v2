// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
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
    this.orderNum,
    this.services,
    this.tax,
    this.total,
  });

  int id;
  String orderNum;
  List<DataService> services;
  String tax;
  String total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    orderNum: json["order_num"],
    services: List<DataService>.from(json["services"].map((x) => DataService.fromJson(x))),
    tax: json["tax"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_num": orderNum,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "tax": tax,
    "total": total,
  };
}

class DataService {
  DataService({
    this.id,
    this.title,
    this.image,
    this.services,
    this.total,
  });

  int id;
  String title;
  String image;
  List<ServiceService> services;
  int total;

  factory DataService.fromJson(Map<String, dynamic> json) => DataService(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    services: List<ServiceService>.from(json["services"].map((x) => ServiceService.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "total": total,
  };
}

class ServiceService {
  ServiceService({
    this.id,
    this.title,
    this.price,
    this.count,
  });

  int id;
  String title;
  int price;
  String count;

  factory ServiceService.fromJson(Map<String, dynamic> json) => ServiceService(
    id: json["id"],
    title: json["title"],
    price: json["price"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "count": count,
  };
}

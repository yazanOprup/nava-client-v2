// To parse this JSON data, do
//
//     final cartDetailsModel = cartDetailsModelFromJson(jsonString);

import 'dart:convert';

CartDetailsModel cartDetailsModelFromJson(String str) =>
    CartDetailsModel.fromJson(json.decode(str));

String cartDetailsModelToJson(CartDetailsModel data) =>
    json.encode(data.toJson());

class CartDetailsModel {
  CartDetailsModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory CartDetailsModel.fromJson(Map<String, dynamic> json) =>
      CartDetailsModel(
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
  Data(
      {this.id,
      this.orderNum,
      this.date,
      this.time,
      this.categoryTitle,
      this.lat,
      this.lng,
      this.region,
      this.residence,
      this.floor,
      this.street,
      this.addressNotes,
      this.services,
      this.tax,
      this.total,
      this.couponValue,
      this.miniOrderCharge,
      this.payType});

  int id;
  String orderNum;
  String date;
  String time;
  String categoryTitle;
  double lat;
  double lng;
  String region;
  String residence;
  String floor;
  String street;
  String addressNotes;
  List<DataService> services;
  double tax;
  String couponValue;
  String total;
  String miniOrderCharge;
  String payType;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        orderNum: json["order_num"],
        date: json["date"],
        time: json["time"],
        categoryTitle: json["category_title"],
        lat: double.parse(json["lat"]),
        lng: double.parse(json["lng"]),
        region: json["region"],
        residence: json["residence"],
        floor: json["floor"],
        street: json["street"],
        addressNotes: json["address_notes"],
        services: List<DataService>.from(
            json["services"].map((x) => DataService.fromJson(x))),
        tax: double.parse(json["tax"]),
        total: json["total"],
        couponValue: json["couponValue"],
        miniOrderCharge: json["mini_order_charge"],
        payType: json["pay_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_num": orderNum,
        "date": date,
        "time": time,
        "category_title": categoryTitle,
        "lat": lat,
        "lng": lng,
        "region": region,
        "residence": residence,
        "floor": floor,
        "street": street,
        "address_notes": addressNotes,
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
        "tax": tax,
        "total": total,
        "mini_order_charge": miniOrderCharge,
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
        services: List<ServiceService>.from(
            json["services"].map((x) => ServiceService.fromJson(x))),
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
    this.image,
  });

  int id;
  String title;
  int price;
  String image;

  factory ServiceService.fromJson(Map<String, dynamic> json) => ServiceService(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "image": image,
      };
}

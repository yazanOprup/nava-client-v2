// To parse this JSON data, do
//
//     final regionsModel = regionsModelFromJson(jsonString);

import 'dart:convert';

RegionsModel regionsModelFromJson(String str) => RegionsModel.fromJson(json.decode(str));

String regionsModelToJson(RegionsModel data) => json.encode(data.toJson());

class RegionsModel {
  RegionsModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  List<Datum> data;

  factory RegionsModel.fromJson(Map<String, dynamic> json) => RegionsModel(
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
  Datum({
    this.id,
    this.title,
  });

  int id;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

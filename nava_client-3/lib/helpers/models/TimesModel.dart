// To parse this JSON data, do
//
//     final timesModel = timesModelFromJson(jsonString);

import 'dart:convert';

TimesModel timesModelFromJson(String str) => TimesModel.fromJson(json.decode(str));

String timesModelToJson(TimesModel data) => json.encode(data.toJson());

class TimesModel {
  TimesModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  List<String> data;

  factory TimesModel.fromJson(Map<String, dynamic> json) => TimesModel(
    key: json["key"],
    msg: json["msg"],
    data: List<String>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}

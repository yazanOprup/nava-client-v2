// To parse this JSON data, do
//
//     final homeSliderModel = homeSliderModelFromJson(jsonString);

import 'dart:convert';

HomeSliderModel homeSliderModelFromJson(String str) =>
    HomeSliderModel.fromJson(json.decode(str));

String homeSliderModelToJson(HomeSliderModel data) =>
    json.encode(data.toJson());

class HomeSliderModel {
  HomeSliderModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory HomeSliderModel.fromJson(Map<String, dynamic> json) =>
      HomeSliderModel(
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
    this.sliders,
  });

  List<Slider> sliders;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sliders:
            List<Slider>.from(json["sliders"].map((x) => Slider.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sliders": List<dynamic>.from(sliders.map((x) => x.toJson())),
      };
}

class Slider {
  Slider({
    this.id,
    this.title,
    this.image,
    this.categoryId,
    this.subCategoryId,
    this.subCategoryTitle,
    this.subCategoryImage,
  });

  int id;
  String title;
  String image;
  String categoryId;
  String subCategoryId;
  String subCategoryTitle;
  String subCategoryImage;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        subCategoryTitle: json["sub_category_title"],
        subCategoryImage: json["sub_category_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "sub_category_title": subCategoryTitle,
        "sub_category_image": subCategoryImage,
      };
}

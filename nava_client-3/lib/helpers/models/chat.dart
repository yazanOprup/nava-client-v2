// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
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
    this.roomId,
    this.messages,
  });

  int roomId;
  Messages messages;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        roomId: json["room_id"],
        messages: Messages.fromJson(json["messages"]),
      );

  Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "messages": messages.toJson(),
      };
}

class Messages {
  Messages({
    this.data,
    this.pagination,
  });

  List<Datum> data;
  Pagination pagination;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
      };
}

class Datum {
  Datum({
    this.id,
    this.isSender,
    this.userId,
    this.message,
    this.type,
    this.isSeen,
    this.orderFinish,
  });

  int id;
  int isSender;
  int userId;
  Message message;
  Type type;
  int isSeen;
  bool orderFinish;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        isSender: json["is_sender"],
        userId: json["user_id"],
        message: Message.fromJson(json["message"]),
        type: typeValues.map[json["type"]],
        isSeen: json["is_seen"],
        orderFinish: json["order_finish"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_sender": isSender,
        "user_id": userId,
        "message": message.toJson(),
        "type": typeValues.reverse[type],
        "is_seen": isSeen,
        "order_finish": orderFinish,
      };
}

class Message {
  Message({
    this.id,
    this.body,
    this.roomId,
    this.userId,
    this.type,
    this.createdAt,
  });

  int id;
  String body;
  int roomId;
  int userId;
  Type type;
  DateTime createdAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        body: json["body"],
        roomId: json["room_id"],
        userId: json["user_id"],
        type: typeValues.map[json["type"]],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "room_id": roomId,
        "user_id": userId,
        "type": typeValues.reverse[type],
        "created_at": createdAt.toIso8601String(),
      };
}

enum Type { TEXT }

final typeValues = EnumValues({"text": Type.TEXT});

class Pagination {
  Pagination({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        count: json["count"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "count": count,
        "per_page": perPage,
        "current_page": currentPage,
        "total_pages": totalPages,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

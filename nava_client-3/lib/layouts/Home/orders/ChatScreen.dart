import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../helpers/constants/base.dart';
import '../../../helpers/customs/Loading.dart';
import '../../../helpers/models/chat.dart';

class ChatScreen extends StatefulWidget {
  final int roomId;
  ChatScreen({this.roomId});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  Timer _timer;

  @override
  void initState() {
    print("room id : " + widget.roomId.toString());
    _timer = new Timer.periodic(Duration(seconds: 6), (Timer timer) => getChat());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: AppBar(
            title: Text(
              tr("ContactTheTechnician"),
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: MyColors.primary,
            elevation: 0,
          ),
        ),
      ),
      bottomSheet: Container(
        color: MyColors.primary,
        height: 60,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 80,
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 10)),
              ),
            ),
            IconButton(
                onPressed: () async {
                  await sendMessage(messageController.text)
                      .then((value) => getChat());
                  messageController.clear();
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                )),
          ],
        ),
      ),
      body: loading
          ? MyLoading()
          : ListView.builder(
              reverse: true,
              padding: EdgeInsets.only(right: 15, left: 15, bottom: 75),
              itemCount: chat.data.messages.data.length,
              itemBuilder: (ctx, index) {
                int itemCount = chat.data.messages.data.length ?? 0;
                int reversedIndex = itemCount - 1 - index;
                if (chat.data.messages.data[reversedIndex].isSender == 1) {
                  return ChatBubble(
                    clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                    alignment: Alignment.centerRight,
                    elevation: 2,
                    margin: EdgeInsets.only(top: 20),
                    backGroundColor: Colors.blue,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.data.messages.data[reversedIndex].message.body,
                            textAlign: context.locale.countryCode == 'EG'
                                ? TextAlign.left
                                : TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            alignment: context.locale.countryCode == 'EG'
                                ? Alignment.bottomLeft
                                : Alignment.bottomRight,
                            child: Text(
                              timeago.format(
                                chat.data.messages.data[reversedIndex].message
                                    .createdAt,
                              ),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (chat.data.messages.data[index].isSender == 0) {
                  return ChatBubble(
                      clipper:
                          ChatBubbleClipper1(type: BubbleType.receiverBubble),
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 20),
                      backGroundColor: Colors.grey.shade200,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.data.messages.data[reversedIndex].message
                                  .body,
                              textAlign: context.locale.countryCode == 'EG'
                                  ? TextAlign.right
                                  : TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              alignment: context.locale.countryCode == 'EG'
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                              child: Text(
                                timeago.format(
                                  chat.data.messages.data[reversedIndex].message
                                      .createdAt,
                                ),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ));
                } else {
                  return SizedBox();
                }
              },
            ),
    );
  }

  bool loading = true;
  Chat chat = Chat();
  Future getChat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(
      URL,
      "api/chat",
      {
        "lang": preferences.getString("lang"),
        "room_id": widget.roomId.toString(),
        "page": "1"
      },
    );
    print(url);
    try {
      final response = await http.get(url, headers: {
        "Authorization": "Bearer ${preferences.getString("token")}"
      }).timeout(
        Duration(seconds: 7),
        onTimeout: () => throw 'no internet please connect to internet',
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData);
        setState(() => loading = false);
        if (responseData["key"] == "success") {
          chat = Chat.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e   track $t");
    }
  }

  Future sendMessage(String message) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(
      URL,
      "api/sendMessage",
      {
        "message": message,
        "room_id": widget.roomId.toString(),
      },
    );
    print(url);
    try {
      final response = await http.get(url, headers: {
        "Authorization": "Bearer ${preferences.getString("token")}"
      }).timeout(
        Duration(seconds: 7),
        onTimeout: () => throw 'no internet please connect to internet',
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        log(responseData);
        if (responseData["key"] == "success") {
          print("Message sent successfully");
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e   track $t");
    }
  }
}

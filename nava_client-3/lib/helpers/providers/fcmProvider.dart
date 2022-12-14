import 'package:flutter/material.dart';

class FcmProvider with ChangeNotifier {
  String fcmToken;

  void setToken({String value}) {
    fcmToken = value;
    notifyListeners();

  }
}

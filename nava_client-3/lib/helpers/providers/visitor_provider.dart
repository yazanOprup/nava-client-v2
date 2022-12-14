import 'package:flutter/material.dart';

class VisitorProvider with ChangeNotifier{
  bool _visitor=true;

  bool get visitor => _visitor;

  set visitor(bool value) {
    _visitor = value;
    notifyListeners();
  }
}
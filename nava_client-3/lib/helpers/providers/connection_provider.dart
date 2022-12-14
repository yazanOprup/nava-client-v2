import 'package:flutter/material.dart';

class ConnectionStateProvider with ChangeNotifier{
  bool _connection=true;

  bool get connection => _connection;

  set connection(bool value) {
    _connection = value;
  }
}
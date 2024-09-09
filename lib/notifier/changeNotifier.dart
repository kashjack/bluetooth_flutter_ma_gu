import 'package:flutter/material.dart';


class ConnectNotifier extends ChangeNotifier {
  static final ConnectNotifier _instance = ConnectNotifier._privateConstructor();

  ConnectNotifier._privateConstructor();

  static ConnectNotifier get instance => _instance;

  bool isConnected = false;

  void setConnectStatus(bool isConnected) {
    _instance.isConnected = isConnected;
    notifyListeners();
  }
}
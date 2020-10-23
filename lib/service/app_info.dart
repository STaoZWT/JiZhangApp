import 'package:flutter/material.dart';
import 'shared_pref.dart';

class AppInfoProvider with ChangeNotifier {

  String _themeColor = null;

  String get themeColor => _themeColor;


  void setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }


}
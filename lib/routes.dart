import 'package:flutter/material.dart';
import './editbill/edit_account_picker_page.dart';
import './editbill/edit_class_picker_page.dart';
import './editbill/edit_member_picker_page.dart';

final routes = {
  "/editClassPicker": (context) => editClassPicker(),
  "/editAccountPicker": (context) => editAccountPicker(),
  "/editMemberPicker": (context) => editMemberPicker(),
};

//统一处理，固定写法
var onGenerateRoute = (RouteSettings settings) {
  //路由传值
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: settings.arguments),
      );
      return route;
    } else {
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context),
      );
      return route;
    }
  } //统一处理
};

//vesion 1
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chart/Tabs/piechart2/chart_pie.dart';
import 'chart/chartpage.dart';
import 'login/register.dart';
import './editbill/edit_account_picker_page.dart';
import './editbill/edit_class_picker_page.dart';
import './editbill/edit_member_picker_page.dart';

void main() {
  runApp(MyApp()); //实例化时new省略
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/editClassPicker": (context) => editClassPicker(),
        "/editAccountPicker": (context) => editAccountPicker(),
        "/editMemberPicker": (context) => editMemberPicker(),
      },
      title: 'Flutter Demo',
      home: RegisterPage(),
      //onGenerateRoute: onGenerateRoute, //路由
    );
  }
}

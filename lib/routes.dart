import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/homepage.dart';
import 'package:flutter_jizhangapp/login/graphical_password_register.dart';
import 'package:flutter_jizhangapp/login/login.dart';
import 'package:flutter_jizhangapp/login/password_confirm.dart';

import 'chart/Tabs/account/dismissshow.dart';
import 'chart/Tabs/barchart/chart_bar.dart';
import 'chart/Tabs/piechart2/chart_pie.dart';
import 'login/graphical_password_login.dart';
import 'login/password_reset.dart';



//配置路由
final routes={
  //'/':(context,{arguments})=>PiechartPage(arguments:arguments),
  'pieChart':(context,)=>PiechartPage(),
  'barCart':(context,)=>BarchartPage(),
  'liushui':(context,)=>Dismissshow(),
  'home':(context,)=>HomePage(),
  'login':(context,)=>LoginPage(),
  'graphical_login':(context,{arguments})=>GraphicalPasswordLoginPage(),
  'graphical_register':(context,{arguments})=>GraphicalPasswordRegisterPage(),
  'password_confirm':(context,{arguments})=>PasswordConfirmPage(),
  'password_reset':(context,{arguments})=>PasswordResetPage(),
};

//统一处理，固定写法
var onGenerateRoute=(RouteSettings settings) { //路由传值
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
  }//统一处理
};

class ScreenArguments{
  final String usernameget;
  final String theme;
  ScreenArguments(this.usernameget,this.theme);
}
import 'package:flutter/material.dart';

import 'Tabs/account/dismissshow.dart';
import 'Tabs/barchart/chart_bar.dart';
import 'Tabs/piechart2/chart_pie.dart';


//配置路由
final routes={
  //'/':(context,{arguments})=>PiechartPage(arguments:arguments),
  '/pieChart':(context,)=>PiechartPage(),
  '/barCart':(context,)=>BarchartPage(),
  '/liushui':(context,)=>Dismissshow(),
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
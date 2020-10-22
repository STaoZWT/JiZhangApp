//vesion 1
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/const/common_color.dart';
import 'package:flutter_jizhangapp/login/splash.dart';
import 'package:flutter_jizhangapp/service/app_info.dart';
import 'package:provider/provider.dart';
import 'chart/Tabs/piechart2/chart_pie.dart';
import 'chart/chartpage.dart';
import 'login/register.dart';
import './editbill/edit_account_picker_page.dart';
import './editbill/edit_class_picker_page.dart';
import './editbill/edit_member_picker_page.dart';
import 'set_theme_page.dart';

void main() {
  runApp(MyApp()); //实例化时new省略
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Color _themeColor;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInfoProvider())
      ],
      child: Consumer<AppInfoProvider> (
        builder: (context, appInfo, _) {
          String colorKey = appInfo.themeColor;
          if (themeColorMap[colorKey] != null) {
            _themeColor = themeColorMap[colorKey];
          }

          return MaterialApp(
            theme: ThemeData.light().copyWith(
              primaryColor: _themeColor,
              accentColor: _themeColor,
              indicatorColor: Colors.white,
              iconTheme: IconThemeData().copyWith(
                color: _themeColor,
              )
            ),
            routes: {
              "/editClassPicker": (context) => editClassPicker(),
              "/editAccountPicker": (context) => editAccountPicker(),
              "/editMemberPicker": (context) => editMemberPicker(),
            },
            title: 'Flutter Demo',
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/homepage.dart';
import 'package:flutter_jizhangapp/login/graphical_password_login.dart';
import 'package:flutter_jizhangapp/login/graphical_password_register.dart';
import 'package:flutter_jizhangapp/login/introduction_screen.dart';
import 'package:flutter_jizhangapp/login/login.dart';
import 'package:flutter_jizhangapp/login/password_confirm.dart';
import 'package:flutter_jizhangapp/login/password_reset.dart';
import 'package:flutter_jizhangapp/login/register.dart';
import 'package:flutter_jizhangapp/login/splash.dart';
import 'package:flutter_jizhangapp/service/external_storage_backup.dart';
import './editbill/edit_account_picker_page.dart';
import './editbill/edit_class_picker_page.dart';
import './editbill/edit_member_picker_page.dart';

final routes = {
  "/editClassPicker": (context) => editClassPicker(),
  "/editAccountPicker": (context) => editAccountPicker(),
  "/editMemberPicker": (context) => editMemberPicker(),
  "home_screen": (context) => NavigationHomeScreen(),
  "home": (context) => HomePage(),
  "intro": (context) => IntroductionScreenPage(),
  "login": (context) => LoginPage(),
  "register": (context) => RegisterPage(),
  "graphical_login": (context) => GraphicalPasswordLoginPage(),
  "graphical_register": (context) => GraphicalPasswordRegisterPage(),
  "password_confirm": (context) => PasswordConfirmPage(),
  "password_reset": (context) => PasswordResetPage(),
  "backup": (context) => BackupToFile(),
  "splash": (context) => SplashScreen(),
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
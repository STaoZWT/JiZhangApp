//vesion 1
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/const/common_color.dart';
import 'package:flutter_jizhangapp/login/splash.dart';
import 'package:flutter_jizhangapp/routes.dart';
import 'package:flutter_jizhangapp/service/app_info.dart';
import 'package:flutter_jizhangapp/service/shared_pref.dart';
import 'package:provider/provider.dart';
import 'login/register.dart';
import './editbill/edit_account_picker_page.dart';
import './editbill/edit_class_picker_page.dart';
import './editbill/edit_member_picker_page.dart';
import 'set_theme_page.dart';
import './service/app_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String color1 = await getColorKey();
  print("color1 : $color1");
  runApp(MyApp(color1)); //实例化时new省略
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  String color1;
  MyApp(this.color1);

  @override
  State<StatefulWidget> createState() => AppState();

}

class AppState extends State<MyApp> {

  Color _themeColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Color _themeColor;

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppInfoProvider())
        ],
        child: Consumer<AppInfoProvider> (
            builder: (context, appInfo, _) {
              print("Widget' s color1 is ${widget.color1}");
              print("appInfo.themeColor is ${appInfo.themeColor}");
              String colorKey = (appInfo.themeColor == null) ? widget.color1 : appInfo.themeColor;
              print("colorKey is $colorKey");
              if (themeColorMap[colorKey] != null) {
                _themeColor = themeColorMap[colorKey];
              }
        return MaterialApp(
          theme: ThemeData.light().copyWith(
          //colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey),
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
          onGenerateRoute: onGenerateRoute,
    );
  },
  ),
  );
}


}




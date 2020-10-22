//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/login/password_reset.dart';
import './login/graphical_password_register.dart';
import './login/password_confirm.dart';
import './login/register.dart';
import 'chart/chartpage.dart';
import 'chart/select.dart';
import 'login/login.dart';
import 'service/shared_pref.dart';
import 'unknown_page.dart';
import 'editbill/edit_bill_page.dart';
import 'login/remove_user_data.dart';
import './total/TotalPage.dart';

import './homepage_drawer/drawer_user_controller.dart';
import './homepage_drawer/home_drawer.dart';
import './homepage_drawer/app_theme.dart';
import 'set_theme_page.dart';


//
class HomePage extends StatefulWidget {

  //
  const HomePage({Key key}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;



  @override
  void initState() {
    //drawerIndex = DrawerIndex.HOME;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle:true,
          automaticallyImplyLeading:false,
          title: Text(
            "Home Page",
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar: BottomNavigationBar(
          //底部导航
          //fixedColor: Colors.blue, //点击后是什么颜色
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.pie_chart,
                ),
                title: Text(
                  '图表',
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.attach_money,
                ),
                title: Text(
                  '记一笔',
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_balance_wallet,
                ),
                title: Text(
                  '账户',
                )),
          ],
          currentIndex: _currentIndex, //位标属性，表示底部导航栏当前处于哪个导航标签。初始化为第一个标签页面
          onTap: (int i) {
            setState(() {
              _currentIndex = i;
              if (_currentIndex == 0) {
                //setPassWord(null);
                //Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage()));
              } else if (_currentIndex == 1) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => CardAddBill()));
                //builder: (BuildContext context) => UnknownPage()));
              } else if (_currentIndex == 2) {
                //Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  //builder: (BuildContext context) => UnknownPage()));
                    builder: (BuildContext context) => TotalPage()));
              }
              ;
            });
          },
        ));
  }
}

// DrawerUserController(
// screenIndex: drawerIndex,
// drawerWidth: MediaQuery.of(context).size.width * 0.75,
// onDrawerCall: (DrawerIndex drawerIndexdata) {
// //changeIndex(drawerIndexdata);
// //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
// },
// //screenView: screenView,
// //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
// )

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;

  @override
  void initState() {
    screenView = const HomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: DrawerIndex.HOME,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    print(drawerIndexdata);
    if (drawerIndexdata == DrawerIndex.HOME) {
      print('去主页');
      //setState(() {
        screenView = const HomePage();
      //});
    } else if (drawerIndexdata == DrawerIndex.Help) {
      print('去修改文字密码');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => PasswordConfirmPage()));  //跳转到修改密码
    }
    else if (drawerIndexdata == DrawerIndex.FeedBack) {
      print('去修改手势密码');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => GraphicalPasswordRegisterPage()));
    }
    else if (drawerIndexdata == DrawerIndex.Invite) {
      print('去修改主题');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SetThemePage()));
      }
    else if (drawerIndexdata == DrawerIndex.Share) {
      print('去初始化');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => RemoveUserDataPage()));
    }
  }

}


//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/login/password_reset.dart';
import './login/graphical_password_register.dart';
import './login/password_confirm.dart';
import 'chart1/chartpage.dart';
import 'editbill/edit_bill_page.dart';
import 'login/remove_user_data.dart';
import './total/TotalPage.dart';

import './homepage_drawer/drawer_user_controller.dart';
import './homepage_drawer/home_drawer.dart';
import './homepage_drawer/app_theme.dart';
import 'set_theme_page.dart';
import './const/common_color.dart';
import 'dart:core';
import './service/database.dart';
import './data/model.dart';


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
  int billsCount;
  String income;
  String outcome;
  BillsModel latestBill;
  //String messageCount;


  bool flag = false;



  @override
  void initState() {
    super.initState();
    print('homepage init!');
    //drawerIndex = DrawerIndex.HOME;
    flag = false;
  }





  @override
  Widget build(BuildContext context) {
    //getHomePageData();
    if (flag==false) {
      getHomePageData();
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Scaffold(
          body: Center(
            child:ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 16, bottom: 18),
                  child: Container(
                    //height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,  //卡片颜色
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(68.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(  //阴影参数
                            color: Colors.grey,
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, bottom: 8, top: 16),
                                child: Text(
                                  '本月您已记账',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    //fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      letterSpacing: -0.1,
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, bottom: 3),
                                        child: Text(
                                          '$billsCount',    //本月记账笔数
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            //fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 60,
                                            color: Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, bottom: 8),
                                        child: Text(
                                          '笔',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            //fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            letterSpacing: -0.2,
                                            color: Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.access_time,
                                            color: Theme.of(context).accentColor
                                                .withOpacity(0.5),
                                            size: 16,
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 4.0),
                                            child: Text(
                                              '${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                //fontFamily: FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: 0.0,
                                                color: Theme.of(context).accentColor.withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 14),
                                        child: Text(
                                          '${weekdayCN(DateTime.now().weekday)}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            //fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                            color: Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 8, bottom: 8),
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 8, bottom: 16),
                          child: Text(
                            messageCountController (billsCount),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: -0.2,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

              ],
            ),

          ),
          floatingActionButton: Container(
            height: 60,
            width: 60,
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.white,
            ),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: (){

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => CardAddBill()));
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle:true,
            automaticallyImplyLeading:false,
            title: Text(
              "Home Page",
              style: TextStyle(color: Theme.of(context).primaryColor),
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
                    color: Colors.white,
                  ),
                  title: Text(
                    '记一笔',
                  )
              ),
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

  //以下将数字转换为星期
  String weekdayCN (int weekday) {
    String ans;
    switch(weekday){
      case 1 :{
        ans = '星期一';
        break;
      }
      case 2 :{
        ans = '星期二';
        break;
      }
      case 3 :{
        ans = '星期三';
        break;
      }
      case 4 :{
        ans = '星期四';
        break;
      }
      case 5 :{
        ans = '星期五';
        break;
      }
      case 6 :{
        ans = '星期六';
        break;
      }
      case 7 :{
        ans = '星期日';
        break;
      }
      default:
    }
    return ans;
  }

  //以下获得首页所需数据
  void getHomePageData() async {
    billsCount = await BillsDatabaseService.db.billsCountThisMonth();
    print('count:');
    print(billsCount);
    income = await BillsDatabaseService.db.assetInThisMonth();
    outcome = await BillsDatabaseService.db.assetOutThisMonth();
    latestBill = await BillsDatabaseService.db.LatestBill();

    if (latestBill == null) {}
    flag = true;
    setState(() {

    });
  }

  String messageCountController (int count) {
    String messageCount;
    if (count == 0) {
      messageCount = '从今天开始，养成记账好习惯吧！';
    }
    else if (count < 15) {
      messageCount = '爱记账，爱生活';
    }
    else {
      messageCount = '柴米油盐，细水长流';
    }
    return messageCount;
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


  //test




  @override
  void initState() {
    screenView = HomePage();
    super.initState();
    print('NavigationHome init!');
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
            screenIndex: DrawerIndex.HOME,  //侧边栏高亮的项目，保持为主页常亮
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


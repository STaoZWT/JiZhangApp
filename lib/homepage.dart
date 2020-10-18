import 'package:flutter/material.dart';
import './login/graphical_password_register.dart';
import './login/password_confirm.dart';
import './login/register.dart';
import 'chart/Tabs/piechart2/chart_pie.dart';
import 'chart/select.dart';
import 'login/login.dart';
import 'service/shared_pref.dart';
import 'unknown_page.dart';
import 'editbill/edit_bill_page.dart';
import 'login/remove_user_data.dart';
import './total/TotalPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Home Page",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                //第一个功能
                  title: Text('修改文字密码'),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    //点击事件
                    //Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PasswordConfirmPage()));
                  }),
              ListTile(
                //第二个功能
                  title: Text('设置/重置图形密码'),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    //点击事件
                    //Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            GraphicalPasswordRegisterPage()));
                  }),
              ListTile(
                //第三个功能
                  title: Text('清空账号信息'),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    //点击事件
                    //Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RemoveUserDataPage()));
                  }),
              Divider(),
              ListTile(
                //退出
                title: Text('退出'),
                trailing: Icon(Icons.cancel),
                onTap: () => Navigator.of(context).pop(), //收起侧边栏
              )
            ],
          ),
        ),
        body: Center(
          child: Text(
            "JiZhangAPP",
            style: TextStyle(fontSize: 40.0),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          //底部导航
          fixedColor: Colors.blue, //点击后是什么颜色
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
                //TODO：待整合记账、统计、图标页面
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => SelectPage()));
              } else if (_currentIndex == 1) {
                //Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => CardAddBill()));
                //builder: (BuildContext context) => UnknownPage()));
              } else if (_currentIndex == 2) {
                //Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //builder: (BuildContext context) => UnknownPage()));
                    builder: (BuildContext context) => TotalPage()));
              }
              ;
            });
          },
        ));
  }
}


// flutter_speed_dial: ^1.2.4
import 'package:flutter/material.dart';
import '../data/model.dart';
import 'NianPage.dart';
import 'JiPage.dart';
import 'YuePage.dart';
import 'RiPage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

int accountNumber;
List totalList;

class TimePage extends StatefulWidget {
  TimePage({Key key}) : super(key: key);

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  int _currentIndex = 0;
  List _pageList = [NianPage(), JiPage(), YuePage(), RiPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('账户按时间统计')),
      body: this._pageList[this._currentIndex],
      floatingActionButton: SpeedDial(
          child: Icon(Icons.add),
          marginRight: 25, //右边距
          marginBottom: 50, //下边距
          animatedIcon: AnimatedIcons.menu_close, //带动画的按钮
          animatedIconTheme: IconThemeData(size: 22.0),
          curve: Curves.bounceIn, //展开动画曲线
          overlayColor: Colors.black, //遮罩层颜色
          overlayOpacity: 0.5, //遮罩层透明度
          tooltip: '统计时间选择', //长按提示文字
          backgroundColor: Colors.blue, //按钮背景色
          foregroundColor: Colors.white, //按钮前景色/文字色
          elevation: 8.0, //阴影
          shape: CircleBorder(), //shape修饰
          children: [
            SpeedDialChild(
              child: Icon(Icons.accessibility),
              backgroundColor: Colors.red,
              label: '日',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  this._currentIndex = 3;
                });
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.brush),
              backgroundColor: Colors.orange,
              label: '月',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  this._currentIndex = 2;
                });
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.keyboard_voice),
              backgroundColor: Colors.green,
              label: '季',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  this._currentIndex = 1;
                });
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.keyboard_voice),
              backgroundColor: Colors.green,
              label: '年',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  this._currentIndex = 0;
                });
              },
            ),
          ]),
    );
  }
}

class TimePageContent extends StatefulWidget {
  TimePageContent({Key key}) : super(key: key);

  @override
  _TimePageContentState createState() => _TimePageContentState();
}

class _TimePageContentState extends State<TimePageContent> {
  //List totalList;
  List<BillsModel> billsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //totalList = countT();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment(-1, -1),
              child: Container(
                height: 800,
                width: 600,
                color: Colors.blue[50],
                // child: ListView(
                //   children: this._totalListData(),
                // ),
              )),
        ]),
      ),
    ]);
  }
}

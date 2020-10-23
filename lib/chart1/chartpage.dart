import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_jizhangapp/chart1/Tabs/piechart2/chart_pie.dart';
import 'package:flutter_jizhangapp/chart1/select.dart';
import 'package:flutter_jizhangapp/data/model.dart';

import 'Tabs/ui_view/app_theme.dart';



class ChartPage extends StatefulWidget {
  final String title;
  String typeSelect; //类型
  int type;
  var picked; //时间

  ChartPage({Key key, this.title, this.type, this.typeSelect, this.picked}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  int _currentIndex = 0;
  int pie_bar = 0; //0--饼状图  1--条形图

  //typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
  //type 1:收入， 2：支出
  //默认为“一级分类支出”
  String typeSelect = '一级分类';
  int type = 1;


  List<DateTime> picked = [
    new DateTime.utc(DateTime.now().year,1,1),
    new DateTime.now()
  ]; //picked存选择的时间段

  void _incrementCounter() {
    setState(() {
      _currentIndex++;
    });
  }

  List<BillsModel> data = [];

  void initState() {
    super.initState();
    //BillsDatabaseService.db.init();
    picked = widget.picked==null?picked:widget.picked;
    _currentIndex = _currentIndex;
    typeSelect = (widget.typeSelect)==null?typeSelect:(widget.typeSelect);
    type = (widget.type)==null?type:(widget.type);
  }

  pagechoose(int _currentIndex){
    if(_currentIndex == 0) { // 饼状图
      return PiechartPage(
          typeSelect: typeSelect,
          type: type,
          picked: picked);
    }
  }


  double topBarOpacity = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          //centerTitle: true,
          title: Text(
            '饼状图',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: JizhangAppTheme.fontName,
              fontWeight: FontWeight.w200,
              fontSize: 22 + 6 - 6 * topBarOpacity,
              letterSpacing: 1.2,
              color: JizhangAppTheme.darkerText,
            ),
          ),
          actions: <Widget>[
            IconButton(  ///时间选择
              icon: new Icon(Icons.calendar_today),
              iconSize: 40.0,
              alignment: Alignment(0.0, 0.0),//Alignment.center,//
              color: Colors.grey[500],
              onPressed: () async {
                picked = await DateRagePicker
                    .showDatePicker(
                    context: context,
                    initialFirstDate: new DateTime.utc((DateTime.now()).year,(DateTime.now().month),1,0,0,0,0,0),
                    //初始--起始日期
                    initialLastDate: new DateTime.now(),
                    //初始--截止日期
                    firstDate: new DateTime((DateTime.fromMicrosecondsSinceEpoch(0)).year),
                    lastDate: new DateTime(((DateTime.now()).year)+1)
                );
                if (picked != null && picked.length == 2) {
                  print(picked);
                  Navigator.of(context).pop();
                  Navigator.push(  ///选择完时间，跳转图表界面
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ChartPage(
                              typeSelect: typeSelect,
                              type: type,
                              picked: picked)));
                }else{
                  picked = [
                    new DateTime.utc((DateTime.now()).year,(DateTime.now().month),1),
                    new DateTime.now()
                  ];
                }
              },
            ),
          ]
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.select_all),
            onPressed: (){
              Navigator.pushNamed(context, '/tabs');
            },
          ),
        ],*/
      ),
      body: pagechoose(_currentIndex),
      bottomNavigationBar: BottomNavigationBar( //界面下方按钮
          fixedColor: Colors.blue, //点击后是什么颜色
          iconSize: 20.0,//icon的大小
          currentIndex: this._currentIndex, //配置对应的索引值选中
          type: BottomNavigationBarType.fixed, //配置底部Tabs可以有多个按钮
          onTap: (int index){ //点击改变界面
            setState(() {
              this._currentIndex = index;
              print(_currentIndex);
              if(_currentIndex == 1) {  // 首页
                Navigator.of(context).pop();
                //Navigator.of(context).push(MaterialPageRoute(
                    //builder: (BuildContext context) => HomePage()));
              }
            });
          },
          items: [ //按钮定义
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.pie_chart, color: Theme.of(context).primaryColor,),
                title: Text("饼状图", style: TextStyle(color: Colors.black54),)
            ),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.home, color: Theme.of(context).primaryColor,),
                title: Text("首页", style: TextStyle(color: Colors.black54),)
            ),
          ]
      ),
    );
  }
}




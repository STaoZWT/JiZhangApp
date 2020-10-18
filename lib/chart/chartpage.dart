import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_jizhangapp/chart/select.dart';
import 'package:flutter_jizhangapp/data/model.dart';
import 'package:flutter_jizhangapp/service/database.dart';
import 'package:toast/toast.dart';
import '../homepage.dart';
import 'Tabs/barchart/chart_bar.dart';
import 'Tabs/piechart2/chart_pie.dart';



class ChartPage extends StatefulWidget {
  final String title;
  String typeSelect; //类型
  int type;
  var picked; //时间
  int pie_bar;

  ChartPage({Key key, this.title, this.type, this.typeSelect, this.picked, this.pie_bar}) : super(key: key);

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
  String selected = "一级分类支出"; ///选择图表显示类型!!!!!!!!!!!!!!!!

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

  //typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
  //type 0:收入， 1：支出
  //默认为“一级分类支出”
  title(String typeSelect, int type) {
    if(type==0){
      return Text("$typeSelect"+"收入",style: TextStyle(fontSize: 30.0));
    }else if(type==1){
      return Text("$typeSelect"+"支出",style: TextStyle(fontSize: 30.0));
    }
  }


  void initState() {
    super.initState();
    //BillsDatabaseService.db.init();
    picked = widget.picked==null?picked:widget.picked;
    pie_bar = widget.pie_bar==null?pie_bar:widget.pie_bar;
    _currentIndex = widget.pie_bar==null?_currentIndex:widget.pie_bar;
    typeSelect = (widget.typeSelect)==null?typeSelect:(widget.typeSelect);
    type = (widget.type)==null?type:(widget.type);
  }

  pagechoose(int _currentIndex){
    if(_currentIndex == 1 || pie_bar == 1) { // 条形图
      pie_bar = 0;
      return BarchartPage(
          typeSelect: typeSelect,
          type: type,
          picked: picked);
    }else if(_currentIndex == 0) { // 饼状图
      return PiechartPage(
          typeSelect: typeSelect,
          type: type,
          picked: picked);
    }
    return PiechartPage(
        typeSelect: typeSelect,
        type: type,
        picked: picked);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: title(typeSelect, type),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.arrow_right),
              iconSize: 50.0,
              alignment: Alignment(0.0, 0.0),//Alignment.center,//
              color: Colors.grey[500],
              onPressed:(){
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    //transition: TransitionType.inFromBottom,
                    CupertinoPageRoute(
                        builder: (context) => SelectPage(
                            pie_bar: _currentIndex,
                            typeSelect: typeSelect,
                            type: type,
                            picked: picked)));
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
              if(_currentIndex == 2) {  // 首页
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
              }
            });
          },
          items: [ //按钮定义
            BottomNavigationBarItem(
                backgroundColor: Colors.lightBlueAccent,
                icon: Icon(Icons.pie_chart),
                title: Text("饼状图")
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.lightBlueAccent,
                icon: Icon(Icons.insert_chart),
                title: Text("条形图")
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.lightBlueAccent,
                icon: Icon(Icons.home),
                title: Text("首页")
            ),
          ]
      ),
    );
  }
}





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/chart/Tabs/piechart2/chart_pie.dart';
import 'package:flutter_jizhangapp/data/model.dart';
import 'package:flutter_jizhangapp/service/database.dart';
import '../../../homepage.dart';
import '../../chart_material.dart';
import '../../select.dart';
import 'barchart_chart.dart';

///barchart的数据类型仔细看发现没有统一

class BarchartPage extends StatefulWidget {
  String title;
  //List<BarData> dataBarEd; //接收传值
  String typeSelect;
  int type;
  var picked;

  BarchartPage({Key key, this.title, this.typeSelect,
                this.type, this.picked}) : super(key: key);

  @override
  _BarchartPageState createState() => _BarchartPageState();
}

class _BarchartPageState extends State<BarchartPage> {
  int _currentIndex = 2;


  //typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
  //type 0:收入， 1：支出
  //默认为“一级分类支出”
  String typeSelect = '一级分类';
  int type = 1;
  String selected = "分类支出"; ///选择图表显示类型!!!!!!!!!!!!!!!!

  List<DateTime> picked = [
    DateTime.fromMillisecondsSinceEpoch(0),
    DateTime.now()
  ]; //picked存选择的时间段

  /*List<BarData> dataBar = [
    BarData('1', Random().nextInt(100), charts.ColorUtil.fromDartColor(Color(0xFF00FF00))), //ARGB颜色
    BarData('2', Random().nextInt(100), charts.ColorUtil.fromDartColor(Color(0xFFFF7F00))),
    BarData('3', Random().nextInt(100), charts.ColorUtil.fromDartColor(Color(0xFFFFFF00))),
    BarData('4', Random().nextInt(100), charts.ColorUtil.fromDartColor(Color(0xFFD26699))),
    //PieSales(4, random.nextInt(100), charts.ColorUtil.fromDartColor(Color(0xFF7F7F7F))),
    //PieSales(5, random.nextInt(100), charts.ColorUtil.fromDartColor(Color(0xFF0000FF))),
  ];*/

  ///初始化 控制器
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //初始化 扇形 数据
    picked = widget.picked; //初始化显示时间
    print(picked);
    setDataFromDB();
  }

  List<BillsModel> data = [];
  List<BarData> dataBarEd = [];
  ///给时间
  ///给时间
  setDataFromDB() async { // 得到数据
    /**for(int i=1;i<=8;i++){
        BillsModel oneBillData = BillsModel.random();
        BillsDatabaseService.db.addBillInDB(oneBillData);
        }**/
    /*var dataAll = await BillsDatabaseService.db.getBillsFromDBByDate(widget.flag==0?widget.picked[0]:picked[0],
                                                                    widget.flag==0?widget.picked[1]:picked[1]);*/
    var dataAll = await BillsDatabaseService.db.getBillsFromDBByDate(picked[0],picked[1]);
    setState(() {
      data = dataAll;
      //print(data);
      typeSelect = widget.typeSelect;
      type = widget.type;
      dataBarEd = (data==null || data.length<=0)?
                  []:dataProcessBar(typeSelect, type);//, member, account);
      //, class1, class2);
      print('111');
      print(dataBarEd);
    });
  }

  //根据已经选中的时间和分类统计数据
  //饼状图
  List<PieData> dataProcessPie(String typeSelect, int type) {
    //data = await BillsDatabaseService.db.getBillsFromDB(); ///获取所有数据
    List<PieData> dataPie;
    dataPie = statisticsPie(data, typeSelect, type);
    return dataPie;
  }

  //条形图
  List<BarData> dataProcessBar(String typeSelect, int type) {
    //data = await BillsDatabaseService.db.getBillsFromDB(); ///获取所有数据????
    //await setDataFromDB();
    List<BarData> dataBar;
    dataBar = statisticsBar(data, typeSelect, type);
    return dataBar;
  }

  void _incrementCounter() {
    setState(() {
      _currentIndex++;
    });
  }

  //typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
  //type 1:收入， 2：支出
  //默认为“一级分类支出”
  title(String typeSelect, int type) {
    if(type==0){
      return Text("$typeSelect"+"收入",style: TextStyle(fontSize: 30.0));
    }else if(type==1){
      return Text("$typeSelect"+"支出",style: TextStyle(fontSize: 30.0));
    }
    /*if(type==1 && typeSelect==1){
      return Text("一级分类收入",style: TextStyle(fontSize: 30.0));
    }else if(type==1 && typeSelect==2){
      return Text("二级分类收入",style: TextStyle(fontSize: 30.0));
    }else if(type==1 && typeSelect==3){
      return Text("成员分类收入",style: TextStyle(fontSize: 30.0));
    }else if(type==1 && typeSelect==4){
      return Text("账户分类收入",style: TextStyle(fontSize: 30.0));
    }else if(type==2 && typeSelect==1){
      return Text("一级分类支出",style: TextStyle(fontSize: 30.0));
    }else if(type==2 && typeSelect==2){
      return Text("二级分类支出",style: TextStyle(fontSize: 30.0));
    }else if(type==2 && typeSelect==3){
      return Text("成员分类支出",style: TextStyle(fontSize: 30.0));
    }else if(type==2 && typeSelect==4){
      return Text("账户分类支出",style: TextStyle(fontSize: 30.0));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("条形图"),
          centerTitle: true,
          /*actions: <Widget>[
            IconButton(
              icon: Icon(Icons.select_all),
              onPressed: (){
                Navigator.pushNamed(context, '/select');
              },
            ),
          ],*/
        ),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                //color: Color(0xFFFF0000),
                child: Center(
                  child: title(widget.typeSelect, widget.type),
                ),
              ),
            ),
            Expanded( //显示起始时间
              flex:2,
              child: Container(
                //color: Color(0xFF0000FF),
                //传入相应的参数
                child: new Text('起始时间${picked[0].year}-${picked[0].month}-${picked[0].day}\n'+
                    '终止时间${picked[1].year}-${picked[1].month}-${picked[1].day}',
                    style: TextStyle(fontSize: 15.0)),
              ),
            ),
            Expanded(
              flex: 16,
              child: Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                //color: Color(0xFF00FF00),
                child: /*(dataBarEd==null)?
                    Text("Nothing!"):*/
                    Center(
                        child: SubscriberChart(
                          data: dataBarEd,
                        )
                    ),
              ),
            )
          ],
        ),
        /*(dataBarEd.length==0)?Text("Nothing!"):Center(
            child: SubscriberChart(
              data: dataBarEd,
            )),*/
        bottomNavigationBar: BottomNavigationBar( //界面下方按钮
        fixedColor: Colors.blue, //点击后是什么颜色
        iconSize: 20.0,//icon的大小
        currentIndex: this._currentIndex, //配置对应的索引值选中
        type: BottomNavigationBarType.fixed, //配置底部Tabs可以有多个按钮
        onTap: (int index){ //点击改变界面
          setState((){
            this._currentIndex=index;
            if(_currentIndex == 0){
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => SelectPage(
                          typeSelect: widget.typeSelect,
                          type: widget.type,
                          picked: widget.picked)));
            }else if(_currentIndex == 1){
              Navigator.of(context).pop();
              //List<PieData> dataPieEd = dataProcessPie(typeSelect, type); //获取数据
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PiechartPage(
                          typeSelect: widget.typeSelect,
                          type: widget.type,
                          picked: widget.picked)));
            }else if(_currentIndex == 2){
              print("仍然时条形图");
            }else if(_currentIndex == 3) {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => HomePage()));
            }
          });
        },
        items: [ //按钮定义
          BottomNavigationBarItem( ///一开始的图表的title显示不出来
              backgroundColor: Colors.lightBlueAccent, //按钮背景色
              icon: Icon(Icons.select_all),
              title: Text("选择")
          ),
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





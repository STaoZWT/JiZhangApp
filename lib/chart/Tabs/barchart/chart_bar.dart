import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/chart/Tabs/piechart2/chart_pie.dart';
import 'package:flutter_jizhangapp/data/model.dart';
import 'package:flutter_jizhangapp/service/database.dart';
import '../../../homepage.dart';
import '../../chart_material.dart';
import '../../chartpage.dart';
import '../../select.dart';
import 'barchart_chart.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

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
      //print('111');
      //print(dataBarEd);
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

  data_empty(List<BarData> dataBarEd){
    if(dataBarEd==null){
      return true;
    }else if(dataBarEd.length==0){
      return true;
    }else if(dataBarEd.length>=0){
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Card(
                margin: EdgeInsets.all(8.0),
                elevation: 15.0,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(14.0))),
                child: Container( // 时间
                    height: 50,
                    width: double.infinity,
                    //color: Color(0xFF0000FF),
                    child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Center()
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text('起始时间${picked[0].year}-${picked[0].month}-${picked[0].day}\n'+
                                  '终止时间${picked[1].year}-${picked[1].month}-${picked[1].day}',
                                  style: TextStyle(fontSize: 15.0)),
                            ),
                          ),
                          Expanded(  // 选择时间
                            flex: 1,
                            child: IconButton(
                              icon: new Icon(Icons.access_time),
                              iconSize: 40.0,
                              color: Colors.grey[500],
                              onPressed: () async { //初始日期要修改  //picked储存选择的时间期限
                                picked = await DateRagePicker
                                    .showDatePicker(
                                    context: context,
                                    initialFirstDate: new DateTime.now(),
                                    //初始--起始日期
                                    initialLastDate: (new DateTime.now()).add(
                                        new Duration(days: 7)),
                                    //初始--截止日期
                                    firstDate: new DateTime(2020),
                                    lastDate: new DateTime(2021)
                                );
                                if (picked != null && picked.length == 2) {
                                  print(picked);
                                  //await setDataFromDB(picked[0],picked[1]);
                                  //List<PieData> dataPieEd = dataProcessPie(typeSelect, type); //获取数据
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => ChartPage(
                                              pie_bar: 1,
                                              typeSelect: typeSelect,
                                              type: type,
                                              picked: picked)));
                                  /*Navigator.pushNamed(context, '/pieChart',arguments: {
                                    "dataPieEd": dataPieEd, //数据
                                    "typeSelect": typeSelect, //类型
                                    "type": type,
                                    "picked": picked, //时间
                                  });///在arguments里面带上我们需要传参值*/
                                }else{
                                  picked = [
                                    new DateTime.utc(2000,10,1),
                                    new DateTime.utc(2030,10,31)
                                  ];
                                }
                              },
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Center()
                          ),
                        ]
                    )
                )
            ),
            Card(
              margin: EdgeInsets.all(20.0),
              elevation: 15.0,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(14.0))),
              child:
              Container(
                height: 400,
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 20.0),
                //color: Color(0xFF00FF00),
                child: data_empty(dataBarEd)?Container():
                Center(
                    child: SubscriberChart(
                      data: dataBarEd,
                    )
                ),
              ),
            )
        ],
      )
    );
  }
}





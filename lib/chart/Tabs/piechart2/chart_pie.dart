import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/chart/Tabs/account/test_liushui.dart';
import 'package:flutter_jizhangapp/data/model.dart';
import 'package:flutter_jizhangapp/service/database.dart';
import '../../chart_material.dart';
import '../../chartpage.dart';

import 'MyCustomCircle.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;


///加上显示时间
/// bug如果sales很小可能被吞，小数后2位
/// 界面会不会传多次值丢失

class PiechartPage extends StatefulWidget {
  String title;
  String typeSelect; //类型
  int type;
  var picked; //时间

  PiechartPage({Key key, this.title,
                this.type, this.typeSelect, this.picked}) : super(key: key);

  @override
  _PiechartPageState createState() => _PiechartPageState();
}

class _PiechartPageState extends State<PiechartPage> {

  int _currentIndex = 1;

  //typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
  //type 0:收入， 1：支出
  //默认为“一级分类支出”
  String typeSelect = '一级分类';
  int type = 1;
  String selected = "一级分类支出"; ///选择图表显示类型!!!!!!!!!!!!!!!!

  List<DateTime> picked = [
    DateTime.utc(DateTime.now().year,1,1),
    DateTime.now()
  ]; //picked存选择的时间段

  //数据源 下标  表示当前是PieData哪个对象
  int subscript = 0;
  //当前选中
  int currentSelect = 0;

  //数据源
  List<PieData> mData = [];
  //传递值
  PieData pieData;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _currentIndex++;
    });
  }

  ///改变饼状图
  void _changeData() {
    setState(() {
      ++subscript;
      ++currentSelect;
      if(subscript == mData.length){
        subscript = 0;
        currentSelect = 0;
      }
      pieData = mData[subscript];
    });
  }

  List<BillsModel> data;
  List<String> member;
  List<String> account;
  List<String> class1;
  List<String> class2;

  ///初始化 控制器
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //BillsDatabaseService.db.init();
    picked = ((widget.picked)==null)?picked:(widget.picked); //初始化显示时间
    //初始化 扇形 数据
    setDataFromDB();
  }

  empty(List<PieData> mData){
    if(mData==null){
      return true;
    }else if(mData.length<=0){
      return true;
    }else if(mData.length>0){
      return false;
    }
  }

  ///给时间
  setDataFromDB() async { // 得到数据
    var dataAll = await BillsDatabaseService.db.getBillsFromDBByDate(picked[0],picked[1]);
    setState(() {
      data = dataAll;
      //print(data);
      /*for(int i=0; i<data.length; i++){
        print(data[i].type); print(data[i].category2);print(data[i].value100);print(data[i].category1);//print(data[i]);
      }*/
      typeSelect = (widget.typeSelect)==null?typeSelect:(widget.typeSelect);
      //print(widget.typeSelect);
      type = (widget.type)==null?type:(widget.type);
      //print(widget.type);
      mData = (data==null || data.length<=0)?
          []:dataProcessPie(typeSelect, type);
      //print(mData);
      pieData = empty(mData)?null:mData[0];
      //print(pieData);
    });
  }

  //根据已经选中的时间和分类统计数据
  //饼状图
  List<PieData> dataProcessPie(String typeSelect, int type) {
    List<PieData> dataPie;
    dataPie = statisticsPie(data, typeSelect, type);//, member, account);
    print(dataPie);
    return dataPie;
  }

  //根据已经选中的时间和分类统计数据
  //条形图
  List<BarData> dataProcessBar(String typeSelect, int type){
    //var data = await BillsDatabaseService.db.getBillsFromDB(); ///获取所有数据
    List<BarData> dataBar;
    dataBar = statisticsBar(data, typeSelect, type);
    return dataBar;
  }

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

  Liushui(PieData piedata){
      return Row(
        children: [
          Expanded(
              flex: 1,
              child: IconButton(
                icon: new Icon(Icons.arrow_right),
                iconSize: 10.0,
                color: piedata.color,
                onPressed: (){
                  Navigator.of(context).pop();
                  String checked = mData[subscript].name; ///类别
                  List<LiushuiData> liuData = getLiuData(data, checked, widget.typeSelect, widget.type);
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Dismissshow_testPage(
                              pie_bar: 0,
                              typeSelect: widget.typeSelect,
                              type: widget.type,
                              picked: widget.picked,
                              liuData: liuData)));
                },
              )
          ),
          Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                child: Text(piedata.name, style: TextStyle(fontSize: 25.0)),
              )
          ),
          Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.only(left: 0.0, bottom: 5.0),
                child: Text('${piedata.percentage}', style: TextStyle(fontSize: 24.0)),
              )
          ),
          Expanded(
              flex: 8,
              child: Container()
          ),
          Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text('${piedata.price}', style: TextStyle(fontSize: 25.0)),
              )
          ),
        ],
      );
  }

  data_empty(List<PieData> mData){
    if(mData==null){
      return true;
    }else if(mData.length==0){
      return true;
    }else if(mData.length>=0){
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
                                  initialFirstDate: new DateTime.utc((DateTime.now()).year,(DateTime.now().month),1,0,0,0,0,0),
                                  //初始--起始日期
                                  initialLastDate: new DateTime.now(),
                                  //初始--截止日期
                                  firstDate: new DateTime((DateTime.fromMicrosecondsSinceEpoch(0)).year),
                                  lastDate: new DateTime(((DateTime.now()).year)+1)
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
                                            pie_bar: 0,
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
                                  new DateTime.utc((DateTime.now()).year,(DateTime.now().month),1),
                                  new DateTime.now()
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
          Card(  // 饼状图
              margin: EdgeInsets.all(8.0),
              elevation: 15.0,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(14.0))),
              child: Container(
                height: 290,
                width: double.infinity,
                //color: Color(0xFF0000FF),
                child: Column(
                  children: [
                    Expanded(  // 饼状图
                      flex:7,
                      child: Container(
                        //color: Color(0xFF0000FF),
                        child: Row(
                          children: [
                            Expanded(  //左侧
                                flex:1,
                                child: Container()
                            ),
                            Expanded(  //图
                              flex: 7,
                              child: Container(
                                //color: Colors.blueGrey,
                                  width: double.infinity, //double类型
                                  height: double.infinity,
                                  //decoration: BoxDecoration(color:Colors.yellowAccent),
                                  //padding: const EdgeInsets.only(bottom: 20.0),
                                  //传入相应的参数
                                  child: Center(
                                    //child: data_empty(mData)?Container():
                                    child: data_empty(mData)?new MyCustomCircle(
                                        null,
                                        null, 0
                                    ):
                                    new MyCustomCircle(
                                        mData,
                                        pieData, currentSelect
                                    ),
                                  )
                              ),
                            ),
                            Expanded(  //右侧
                              flex: 2,
                              child: Container(
                                //color: Color(0xFF0000FF),
                                //padding: const EdgeInsets.only(right: 20),
                                  child: IconButton(
                                    //padding: const EdgeInsets.only(right: 40),
                                    icon: new Icon(Icons.arrow_right),
                                    iconSize: 60.0,
                                    color: Colors.green[500],
                                    onPressed:(){
                                      data_empty(mData)?print('Nothing'):
                                      _changeData();
                                    },
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(  // 选中的类别
                      flex: 2,
                      child: data_empty(mData)?Container():
                      MaterialButton(
                        //color: Colors.deepOrangeAccent,
                          padding: const EdgeInsets.only(right: 40),
                          onPressed: (){
                            Navigator.of(context).pop();
                            String checked = mData[subscript].name; ///类别
                            List<LiushuiData> liuData = getLiuData(data, checked, widget.typeSelect, widget.type);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Dismissshow_testPage(
                                        pie_bar: 0,
                                        typeSelect: widget.typeSelect,
                                        type: widget.type,
                                        picked: widget.picked,
                                        liuData: liuData)));
                          },
                          child: Center(
                              child: Text(mData[currentSelect].name,
                                style: TextStyle( //backgroundColor:Colors.white,
                                    inherit: true,
                                    color: Colors.black,
                                    fontSize: 25),)
                          )
                      ),
                    )
                  ],
                ),
              )
          ),
          Card(  // 类别
              margin: EdgeInsets.all(8.0),
              elevation: 15.0,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(14.0))),
              child: Container(
                  height: 260,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                                      child: Text('类别', style: TextStyle(fontSize: 20.0)),
                                    )
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 0.0, bottom: 5.0),
                                      child: Text('    比例', style: TextStyle(fontSize: 20.0)),
                                    )
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Container()
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 5.0),
                                      child: Text('金额/元', style: TextStyle(fontSize: 20.0)),
                                    )
                                ),
                              ],
                            ),
                            decoration: new BoxDecoration(
                                border: new Border(
                                  bottom: BorderSide(color: Colors.black, width: 2.0), //信息的分割线
                                )
                            ),
                          )
                      ),
                      Expanded(  //类别图例
                          flex: 8,
                          child: mData==null?Container():
                          ListView.builder(
                              itemCount: mData.length,
                              itemBuilder: (context, index) {
                                final item = mData[index];
                                return new GestureDetector(
                                    child: new Container(
                                        height: 50.0, //每一条信息的高度
                                        //padding: const EdgeInsets.only(left: 20.0), //每条信息左边距
                                        decoration: (index==(mData.length)-1)?BoxDecoration():  ///最后一条信息下面没有线
                                          new BoxDecoration(
                                              border: new Border(
                                                bottom: BorderSide(color: Colors.black, width: 1.0), //信息的分割线
                                              )
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 3,
                                                child: IconButton(
                                                  icon: new Icon(Icons.arrow_right),
                                                  iconSize: 40.0,
                                                  padding: const EdgeInsets.only(bottom: 5.0),
                                                  color: mData[index].color,
                                                  onPressed: (){
                                                    String checked = mData[index].name; ///类别
                                                    List<LiushuiData> liuData = getLiuData(data, checked, widget.typeSelect, widget.type);
                                                    Navigator.of(context).pop();
                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                            builder: (context) => Dismissshow_testPage(
                                                                pie_bar: 0,
                                                                typeSelect: widget.typeSelect,
                                                                type: widget.type,
                                                                picked: widget.picked,
                                                                liuData: liuData)));
                                                  },
                                                )
                                            ),
                                            Expanded(
                                                flex: 4,
                                                child: Container(
                                                  //color: Colors.blue,
                                                  padding: const EdgeInsets.only(bottom: 5.0),
                                                  child: Text(mData[index].name, style: TextStyle(fontSize: 12.0)),
                                                )
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                  padding: const EdgeInsets.only(left: 0.0, bottom: 5.0),
                                                  child: Text('  ${formatNum(mData[index].percentage, 2)*100}%', style: TextStyle(fontSize: 18.0)),
                                                )
                                            ),
                                            Expanded(
                                                flex: 8,
                                                child: Container()
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                  padding: const EdgeInsets.only(bottom: 5.0),
                                                  child: Text('${(mData[index].price)/100}', style: TextStyle(fontSize: 18.0)),
                                                )
                                            ),
                                          ],
                                        )
                                    )
                                );
                              }
                          )
                      ),
                    ],
                  )
              )
          ),
        ],
      ),
    );
  }
}




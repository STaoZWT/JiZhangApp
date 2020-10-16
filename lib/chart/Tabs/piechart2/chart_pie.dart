import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/chart/Tabs/account/dismissshow.dart';
import 'package:flutter_jizhangapp/chart/Tabs/barchart/chart_bar.dart';
import 'package:flutter_jizhangapp/data/model.dart';
import 'package:flutter_jizhangapp/service/database.dart';
import '../../../homepage.dart';
import '../../chart_material.dart';
import '../../select.dart';
import 'MyCustomCircle.dart';


///加上显示时间
/// bug如果sales很小可能被吞，小数后2位
/// 界面会不会传多次值丢失

class PiechartPage extends StatefulWidget {
  //List<PieData> dataPieEd; //接收传值
  String title;
  //Function() triggerRefetch;
  String typeSelect; //类型
  int type;
  //int flag;
  var picked; //时间

  PiechartPage({Key key, this.title, //this.dataPieEd, this.flag = 1, this.triggerRefetch,
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
  String selected = "分类支出"; ///选择图表显示类型!!!!!!!!!!!!!!!!

  List<DateTime> picked = [
    DateTime.fromMillisecondsSinceEpoch(0),
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

  ///点击按钮时  改变显示的内容
  void _left() {
    setState(() {
      if (subscript > 0) {
        --subscript;
        --currentSelect;
      }
      pieData = mData[subscript];
    });
  }

  ///改变饼状图
  void _changeData() {
    setState(() {
      if (subscript < mData.length) {
        ++subscript;
        ++currentSelect;
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

  ///给时间
  setDataFromDB() async { // 得到数据
    var dataAll = await BillsDatabaseService.db.getBillsFromDBByDate(picked[0],picked[1]);
    setState(() {
      data = dataAll;
      //print(data);
      //typeSelect = (widget.typeSelect)==null?typeSelect:(widget.typeSelect);
      //print(widget.typeSelect);
      //type = (widget.type)==null?type:(widget.type);
      //print(widget.type);
      mData = (data==null || data.length<=0)?
          []:dataProcessPie(widget.typeSelect, widget.type);//, member, account);
          //, class1, class2);
      //print(mData);
      pieData = mData==[]?null:mData[0];
      //print(pieData);
    });
  }

  //根据已经选中的时间和分类统计数据
  //饼状图
  List<PieData> dataProcessPie(String typeSelect, int type) {
    //, List<String> member, List<String> account) {
    //await setDataFromDB();
    List<PieData> dataPie;
    dataPie = statisticsPie(data, typeSelect, type);//, member, account);
    print(dataPie);
    return dataPie;
  }

  //var memberPickerData = await getPicker("mmemberPicker");
  //var accountPickerData = await getPicker("maccountPicker");
  //var class1PickerData = await getPicker("mclass1Picker");
  //var class2PickerData = await getPicker("mclass2Picker");

  //member = JsonDecoder().convert(memberPickerData);
  //account = JsonDecoder().convert(accountPickerData);
  //class1 = JsonDecoder().convert(class1PickerData);
  //class2 = JsonDecoder().convert(class2PickerData);

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
          title: Text("饼状图"),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          //decoration: BoxDecoration(color:Colors.red),
          child: Column(
            children: [
              Expanded( //标题
                flex: 2,
                child: Center(
                  //color: Color(0xFFFF0000),
                  child: title(widget.typeSelect, widget.type),
                ),

              ),
              Expanded( //显示起始时间
                flex:1,
                child: Container(
                  //color: Color(0xFF0000FF),
                  //传入相应的参数
                  child: new Text('起始时间${picked[0].year}-${picked[0].month}-${picked[0].day}\n'+
                      '终止时间${picked[1].year}-${picked[1].month}-${picked[1].day}',
                      style: TextStyle(fontSize: 15.0)),
                ),
              ),
              Expanded( //图表
                flex:10,
                child: Container(
                  //color: Color(0xFF00FF00),
                  child: Column(
                    children: [
                      Expanded( //图
                        flex: 7,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(  //左侧
                                flex:1,
                                child: Container(
                                  //color: Color(0xFF00FF00),
                                  padding: const EdgeInsets.only(bottom: 80.0),
                                  child: IconButton(
                                    icon: new Icon(Icons.arrow_left),
                                    iconSize: 60.0,
                                    color: Colors.green[500],
                                    onPressed:(){
                                      _left();
                                    },
                                  ),
                                ),
                              ),
                              Expanded(  //图
                                flex: 5,
                                child: Container(
                                    width: double.infinity, //double类型
                                    height: double.infinity,
                                    //decoration: BoxDecoration(color:Colors.yellowAccent),
                                    padding: const EdgeInsets.only(bottom: 80.0),
                                    //传入相应的参数
                                    child: Center(
                                      child: /*(mData.length<=0 || mData.length==null)?
                                          Text('Nothing'):*/
                                          new MyCustomCircle(
                                              mData,
                                              pieData, currentSelect
                                          ),
                                    )
                                ),
                              ),
                              Expanded(  //右侧
                                flex: 1,
                                child: Container(
                                  //color: Color(0xFF0000FF),
                                  padding: const EdgeInsets.only(bottom: 80.0),
                                  child: IconButton(
                                    icon: new Icon(Icons.arrow_right),
                                    iconSize: 60.0,
                                    color: Colors.green[500],
                                    onPressed:(){
                                      _changeData();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded( //确认键
                        flex: 3,
                        child: Container(
                          //color: Color(0xFFFF0000),
                          width: 150.0,
                          height: 10.0,
                          padding: const EdgeInsets.only(bottom: 90.0),
                          child: RaisedButton(
                            child: Text("确认",
                                style: TextStyle(color:Colors.black,fontSize:17)
                            ),
                            onPressed: (){
                              Navigator.of(context).pop();
                              String checked = mData[subscript].name; ///类别
                              //print("检查");
                              //print(checked);
                              //print(data);
                              List<LiushuiData> liuData = getLiuData(data, checked, widget.typeSelect, widget.type);
                              //print(liuData);
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Dismissshow(
                                          typeSelect: widget.typeSelect,
                                          type: widget.type,
                                          picked: widget.picked,
                                          liuData: liuData)));
                            },
                          ),
                        ),
                      )
                    ],
                  )

                ),
              ),
              Expanded(
                flex:1,
                child: Container(
                  //color: Color(0xFF0000FF),
                ),
              )
            ],

          ),
        ),
        /*Container(
          color: Color(0xFFFFFF00),
          //color: Color(0xfff4f4f4),
          height: 1200.0,
          width: 650.0,
          //decoration: BoxDecoration(color:Colors.red),
          child: new Card(
            margin: const EdgeInsets.all(0.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // 左侧按钮
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new IconButton(
                      icon: new Icon(Icons.arrow_left),
                      iconSize: 40.0,
                      color: Colors.green[500],
                      onPressed:(){
                        _left();
                      },
                    ),
                  ],
                ),
                //  自定义的饼状图
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                      width: 320.0, //double类型
                      height: 300.0,
                      decoration: BoxDecoration(color:Colors.yellowAccent),
                      padding: const EdgeInsets.only(bottom: 60.0),
                      //传入相应的参数
                      child: pieData==null?Text('Nothing'):new MyCustomCircle(
                          //arguments["dataPieEd"], pieData, currentSelect),
                          //widget.flag==0?widget.dataPieEd:mData,
                          mData,
                          pieData, currentSelect),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 100.0,
                        height: 20.0,
                        //padding: const EdgeInsets.only(bottom: 20.0),
                        //传入相应的参数
                        child: new Text("起始时间${picked[0]} 终止时间${picked[1]}"),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          width: 40.0,
                          height: 20.0,
                          //padding: const EdgeInsets.only(bottom: 20.0),
                          //传入相应的参数
                          child: RaisedButton(
                            child: Text("确认",
                                style: TextStyle(color:Colors.black,fontSize:17)
                            ),
                            onPressed: (){
                              Navigator.of(context).pop();
                              int checked = int.parse(mData[subscript].name); ///转换后需要对应注意
                              List<LiushuiData> liuData = getLiuData(data, checked, typeSelect, type);
                              //print(liuData);
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Dismissshow(
                                          typeSelect: typeSelect,
                                          type: type,
                                          picked: picked,
                                          liuData: liuData)));
                              /*Navigator.pushNamed(context, '/liushui',arguments: {
                            "liuData": liuData, //数据
                          });///在arguments里面带上我们需要传参值 picked*/
                              /*Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Dismissshow(subscript)));*/
                            },
                          ),
                        ),
                    ),
                  ]
                ),
                // 右侧按钮
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new IconButton(
                      icon: new Icon(Icons.arrow_right),
                      iconSize: 40.0,
                      color: Colors.green[500],
                      onPressed:(){
                        _changeData();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),*/

        bottomNavigationBar: BottomNavigationBar( //界面下方按钮
          fixedColor: Colors.blue, //点击后是什么颜色
          iconSize: 20.0,//icon的大小
          currentIndex: this._currentIndex, //配置对应的索引值选中
          type: BottomNavigationBarType.fixed, //配置底部Tabs可以有多个按钮
          onTap: (int index) { //点击改变界面
            setState(() {
              this._currentIndex = index;
              if (_currentIndex == 0) {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => SelectPage(
                            typeSelect: widget.typeSelect,
                            type: widget.type,
                            picked: widget.picked)));
              } else if (_currentIndex == 1) {
                print("仍然是饼状图");
                //print(widget.dataPieEd);
              } else if (_currentIndex == 2) {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => BarchartPage(
                            typeSelect: widget.typeSelect,
                            type: widget.type,
                            picked: widget.picked)));
                /*Navigator.pushNamed(context, '/barCart',arguments: {
                  "dataBarEd": dataBarEd, //数据
                  "typeSelect": typeSelect, //类型
                  "type": type,
                  "picked": picked, //时间
                });///在arguments里面带上我们需要传参值 picked*/
              } else if (_currentIndex == 3) {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
              }
            });
          },
          items: [ //按钮定义
            BottomNavigationBarItem(
              ///一开始的图表的title显示不出来
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




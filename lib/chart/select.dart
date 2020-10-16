import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_jizhangapp/data/model.dart';
import 'package:flutter_jizhangapp/service/database.dart';
import 'package:toast/toast.dart';
import '../homepage.dart';
import 'Tabs/barchart/chart_bar.dart';
import 'Tabs/piechart2/chart_pie.dart';



class SelectPage extends StatefulWidget {
  final String title;
  String typeSelect; //类型
  int type;
  var picked; //时间

  SelectPage({Key key, this.title, this.type, this.typeSelect, this.picked}) : super(key: key);

  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  int _currentIndex = 0;

  //typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
  //type 1:收入， 2：支出
  //默认为“一级分类支出”
  String typeSelect = '一级分类';
  int type = 1;
  String selected = "分类支出"; ///选择图表显示类型!!!!!!!!!!!!!!!!

  List<DateTime> picked = [
    new DateTime.utc(2000,10,1),
    new DateTime.utc(2030,10,31)
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
    //setDataFromDB(picked[0],picked[1]);
  }

  ///调试--增加数据
  addData() async{
    /*for(int i=1;i<=8;i++){
      BillsModel oneBillData = BillsModel.random();
      BillsDatabaseService.db.addBillInDB(oneBillData);
    }*/
    BillsModel oneBillData = new BillsModel();
    oneBillData.title ='1';
    oneBillData.member = '本人';
    oneBillData.accountOut = '银行卡';
    oneBillData.category1 = '旅游';
    oneBillData.type = 0;
    oneBillData.category2 = '吃饭';
    oneBillData.accountIn = null;
    oneBillData.id = 1;
    oneBillData.value100 = 1003;
    oneBillData.date = DateTime.now();
    BillsDatabaseService.db.addBillInDB(oneBillData);

    BillsModel oneBillData1 = new BillsModel();
    oneBillData1.title ='1';
    oneBillData1.member = '本人';
    oneBillData1.accountOut = '银行卡';
    oneBillData1.category1 = '游戏';
    oneBillData1.type = 1;
    oneBillData1.category2 = '吃饭';
    oneBillData1.accountIn = null;
    oneBillData1.id = 1;
    oneBillData1.value100 = 1003;
    oneBillData1.date = DateTime.now();
    BillsDatabaseService.db.addBillInDB(oneBillData1);

    BillsModel oneBillData2 = new BillsModel();
    oneBillData2.title ='1';
    oneBillData2.member = 'ss';
    oneBillData2.accountOut = '水卡';
    oneBillData2.category1 = '游戏';
    oneBillData2.type = 1;
    oneBillData2.category2 = '喝水';
    oneBillData2.accountIn = null;
    oneBillData2.id = 1;
    oneBillData2.value100 = 1003;
    oneBillData2.date = DateTime.now();
    BillsDatabaseService.db.addBillInDB(oneBillData2);
  }

  clearData() async{
    BillsDatabaseService.db.deleteBillAllInDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("图表"),
        centerTitle: true,
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.select_all),
            onPressed: (){
              Navigator.pushNamed(context, '/tabs');
            },
          ),
        ],*/
      ),
      body: GridView.count(
        crossAxisCount: 5,
        children: <Widget>[
          Text("支出图表",
            style: TextStyle(backgroundColor:Colors.white,inherit:true,color:Colors.green,fontSize:20),
          ),
          RaisedButton(
            child: Text("分类支出",
                style: TextStyle(color:Colors.black,fontSize:17)
            ),
            onPressed: (){
              selected = "分类支出";
              typeSelect = '一级分类';
              type = 1;
              print(selected);
              Navigator.of(context).pop();
              //List<PieData> dataPieEd = dataProcessPie(typeSelect, type); //获取数据
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PiechartPage(
                          typeSelect: typeSelect,
                          type: type,
                          picked: picked)));
            },
          ),
          RaisedButton(
            child: Text("二级支出",
                style: TextStyle(color:Colors.black,fontSize:17)
            ),
            onPressed: (){
              selected = "二级支出";
              typeSelect = '二级分类';
              type = 1;
              print(selected);
              Navigator.of(context).pop();
              //List<PieData> dataPieEd = dataProcessPie(typeSelect, type); //获取数据
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PiechartPage(
                          typeSelect: typeSelect,
                          type: type,
                          picked: picked)));
            },
          ),
          RaisedButton(
            child: Text("账户支出",
                style: TextStyle(color:Colors.black,fontSize:17)
            ),
            onPressed: (){
              selected = "账户支出";
              typeSelect = '账户分类';
              type = 1;
              print(selected);
              Navigator.of(context).pop();
              //List<PieData> dataPieEd = dataProcessPie(typeSelect, type); //获取数据
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PiechartPage(
                          typeSelect: typeSelect,
                          type: type,
                          picked: picked)));
            },
          ),
          RaisedButton(
            child: Text("成员支出",
                style: TextStyle(color:Colors.black,fontSize:17)
            ),
            onPressed: (){
              selected = "成员支出";
              typeSelect = '成员分类';
              type = 1;
              print(selected);
              Navigator.of(context).pop();
              //List<PieData> dataPieEd = dataProcessPie(typeSelect, type); //获取数据
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PiechartPage(
                          typeSelect: typeSelect,
                          type: type,
                          picked: picked)));
            },
          ),
          Text("收入图表",
            style: TextStyle(backgroundColor:Colors.white,inherit:true,color:Colors.red,fontSize:20),
          ),
          RaisedButton(
            child: Text("分类收入",
                style: TextStyle(color:Colors.black,fontSize:17)
            ),
            onPressed: (){
              selected = "分类收入";
              typeSelect = '一级分类';
              type = 0;
              print(selected);
              Navigator.of(context).pop();
              //List<PieData> dataPieEd = dataProcessPie(typeSelect, type); //获取数据
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PiechartPage(
                          typeSelect: typeSelect,
                          type: type,
                          picked: picked)));
            },
          ),
          RaisedButton(
            child: Text("二级收入",
                style: TextStyle(color:Colors.black,fontSize:17)
            ),
            onPressed: (){
              selected = "二级收入";
              typeSelect = '二级分类';
              type = 0;
              print(selected);
              Navigator.of(context).pop();
              //List<PieData> dataPieEd = dataProcessPie(typeSelect, type); //获取数据
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PiechartPage(
                          typeSelect: typeSelect,
                          type: type,
                          picked: picked)));
            },
          ),
          RaisedButton(
            child: Text("账户收入",
                style: TextStyle(color:Colors.black,fontSize:17)
            ),
            onPressed: (){
              selected = "账户收入";
              typeSelect = '账户分类';
              type = 0;
              print(selected);
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PiechartPage(
                          typeSelect: typeSelect,
                          type: type,
                          picked: picked)));
            },
          ),
          RaisedButton(
            child: Text("成员收入",
                style: TextStyle(color:Colors.black,fontSize:17)
            ),
            onPressed: (){
              selected = "成员收入";
              typeSelect = '成员分类';
              type = 0;
              print(selected);
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PiechartPage(
                          typeSelect: typeSelect,
                          type: type,
                          picked: picked)));
            },
          ),
          MaterialButton(  ///选择时间
              color: Colors.deepOrangeAccent,
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
                          builder: (context) => PiechartPage(
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
              child: Center(
                  child: Text("选择时间段",
                    style: TextStyle( //backgroundColor:Colors.white,
                        inherit: true,
                        color: Colors.black,
                        fontSize: 15),)
              )
          ),
          RaisedButton(
            child: Text("增加数据",
                style: TextStyle(color:Colors.black,fontSize:17)
            ),
            onPressed: (){
              addData();//增加数据
              Toast.show("已经增加8条随机数据",context);
            },
          ),
          RaisedButton(
            child: Text("清空数据",
                style: TextStyle(color:Colors.black,fontSize:17)
            ),
            onPressed: (){
              clearData();//增加数据
              /*Scaffold.of(context).showSnackBar(  //底部弹出信息
                  new SnackBar(content: new Text('已经清空数据')));*/
              Toast.show("已经清空数据",context);
            },
          ),
        ],
      ),

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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SelectPage()));
              }else if(_currentIndex == 1){
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => PiechartPage(
                            typeSelect: typeSelect,
                            type: type,
                            picked: picked)));
              }else if(_currentIndex == 2){
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => BarchartPage(
                            typeSelect: typeSelect,
                            type: type,
                            picked: picked)));
                /*Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => BarchartPage()));*/
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
                title: Text("返回")
            ),
          ]
      ),
    );
  }
}





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_jizhangapp/data/model.dart';
import 'package:flutter_jizhangapp/service/database.dart';
import 'package:toast/toast.dart';
import 'chartpage.dart';



class SelectPage extends StatefulWidget {
  final String title;
  String typeSelect; //类型
  int type;
  var picked; //时间
  int pie_bar = 0; //0--饼状图  1--条形图

  SelectPage({Key key, this.title, this.type, this.typeSelect, this.picked, this.pie_bar}) : super(key: key);

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



  clearData() async{
    BillsDatabaseService.db.deleteBillAllInDB();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: title(typeSelect, type),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.arrow_left),
              iconSize: 50.0,
              alignment: Alignment(0.0, 0.0),//Alignment.center,//
              color: Colors.grey[500],
              onPressed:(){
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    //transition: TransitionType.inFromBottom,
                    CupertinoPageRoute(
                        builder: (context) => ChartPage(
                            pie_bar: widget.pie_bar,
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
      body: ListView(
        children: [
          Card(
              margin: EdgeInsets.all(8.0),
              elevation: 15.0,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(14.0))),
              child: Container(
                  width: double.infinity,
                  height: 100.0,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text("支出图表",
                          style: TextStyle(backgroundColor:Colors.white,inherit:true,color:Colors.black87,fontSize:16),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          //width: double.infinity,
                          child: RaisedButton(
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
                                      builder: (context) => ChartPage(
                                          pie_bar: widget.pie_bar,
                                          typeSelect: typeSelect,
                                          type: type,
                                          picked: picked)));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          //width: double.infinity,
                          child: RaisedButton(
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
                                      builder: (context) => ChartPage(
                                          pie_bar: widget.pie_bar,
                                          typeSelect: typeSelect,
                                          type: type,
                                          picked: picked)));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          //width: double.infinity,
                          child: RaisedButton(
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
                                      builder: (context) => ChartPage(
                                          pie_bar: widget.pie_bar,
                                          typeSelect: typeSelect,
                                          type: type,
                                          picked: picked)));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          //width: double.infinity,
                          child: RaisedButton(
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
                                      builder: (context) => ChartPage(
                                          pie_bar: widget.pie_bar,
                                          typeSelect: typeSelect,
                                          type: type,
                                          picked: picked)));
                            },
                          ),
                        ),
                      ),
                    ],
                ),
              ),
          ),
          Card(
            margin: EdgeInsets.all(8.0),
            elevation: 15.0,
            shape: const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(14.0))),
            child: Container(
              height: 100.0,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text("收入图表",
                      style: TextStyle(backgroundColor:Colors.white,inherit:true,color:Colors.black87,fontSize:16),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: double.infinity,
                      //width: double.infinity,
                      child: RaisedButton(
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
                                  builder: (context) => ChartPage(
                                      pie_bar: widget.pie_bar,
                                      typeSelect: typeSelect,
                                      type: type,
                                      picked: picked)));
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: double.infinity,
                      //width: double.infinity,
                      child: RaisedButton(
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
                                  builder: (context) => ChartPage(
                                      pie_bar: widget.pie_bar,
                                      typeSelect: typeSelect,
                                      type: type,
                                      picked: picked)));
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: double.infinity,
                      //width: double.infinity,
                      child: RaisedButton(
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
                                  builder: (context) => ChartPage(
                                      pie_bar: widget.pie_bar,
                                      typeSelect: typeSelect,
                                      type: type,
                                      picked: picked)));
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: double.infinity,
                      //width: double.infinity,
                      child: RaisedButton(
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
                                  builder: (context) => ChartPage(
                                      pie_bar: widget.pie_bar,
                                      typeSelect: typeSelect,
                                      type: type,
                                      picked: picked)));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      )

    );
  }

/*GridView.count(
  crossAxisCount: 5,
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
),*/


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
    oneBillData2.category1 = '旅游';
    oneBillData2.type = 1;
    oneBillData2.category2 = '喝水';
    oneBillData2.accountIn = null;
    oneBillData2.id = 1;
    oneBillData2.value100 = 1003;
    oneBillData2.date = DateTime.now();
    BillsDatabaseService.db.addBillInDB(oneBillData2);
  }
}





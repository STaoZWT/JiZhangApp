import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_jizhangapp/chart1/Tabs/account/dismissshow.dart';
import 'package:flutter_jizhangapp/chart1/Tabs/piechart2/MyCustomCircle.dart';
import 'package:flutter_jizhangapp/chart1/Tabs/ui_view/app_theme.dart';
import 'package:flutter_jizhangapp/chart1/chart_material.dart';
import 'package:flutter_jizhangapp/chart1/select.dart';
import 'package:flutter_jizhangapp/data/model.dart';
import 'package:flutter_jizhangapp/service/database.dart';

import '../../../homepage.dart';
import '../../chartpage.dart';


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

  data_empty(List<PieData> mData){
    if(mData==null){
      return true;
    }else if(mData.length<=0){
      return true;
    }else if(mData.length>=0){
      return false;
    }
    return true;
  }

  ///给时间
  setDataFromDB() async { // 得到数据
    var dataAll = await BillsDatabaseService.db.getBillsFromDBByDate(picked[0],picked[1]);
    setState(() {
      data = dataAll;
      print(data);
      for(int i=0; i<data.length; i++){
        print(data[i].type); print(data[i].category2);print(data[i].value100);print(data[i].category1);//print(data[i]);
      }
      typeSelect = (widget.typeSelect)==null?typeSelect:(widget.typeSelect);
      //print(widget.typeSelect);
      type = (widget.type)==null?type:(widget.type);
      //print(widget.type);
      mData = (data==null || data.length<=0)?
          []:dataProcessPie(typeSelect, type);
      print(mData);
      pieData = data_empty(mData)?null:mData[0];
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

  //typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
  //type 0:收入， 1：支出
  //默认为“一级分类支出”
  title(String typeSelect, int type) {
    if(type==0){
      return Text("$typeSelect"+"收入",style: TextStyle(fontSize: 23.0, color: JizhangAppTheme.deactivatedText,));
    }else if(type==1){
      return Text("$typeSelect"+"支出",style: TextStyle(fontSize: 23.0, color: JizhangAppTheme.deactivatedText,));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            height: 20.0,
          ),
          Container(  ///卡片
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.white,//JizhangAppTheme.nearlyBlue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: JizhangAppTheme.grey.withOpacity(0.3),
                      offset: Offset(4, 3),
                      blurRadius: 8.0),
                ],
              ),
              width: double.infinity,
              height: 280.0,
              child: Row(
                children: [
                  Expanded(  ///左侧  时间
                    flex: 6,
                    child: Container(
                      //color: Colors.red,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                          Expanded(  ///起始时间
                            flex: 4,
                            child: GestureDetector(
                              child: Container(
                                //color: Colors.yellowAccent,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6, bottom: 1),
                                      child: Text(
                                        '开始日期',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily:
                                          JizhangAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          letterSpacing: -0.1,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 30,
                                          height: 38,
                                          child: Icon(Icons.access_time,size: 25.0,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 4, bottom: 8),
                                          child: Text(
                                            '${picked[0].year}',  ///起始时间 年
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily:
                                                JizhangAppTheme
                                                    .fontName,
                                                fontWeight:
                                                FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.blueGrey
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 2, bottom: 9),
                                          child: Text(
                                            // '${picked[0].month}.'+'${picked[0].day}',  ///月 日
                                            (picked[0].month as int < 10 ? '0${picked[0].month}' : '${picked[0].month}') + '.' +
                                            (picked[0].day as int < 10 ? '0${picked[0].day}' : '${picked[0].day}'),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                              JizhangAppTheme
                                                  .fontName,
                                              fontWeight:
                                              FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: -0.2,
                                              color: JizhangAppTheme
                                                  .grey
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async { //初始日期要修改  //picked储存选择的时间期限
                                picked = await DateRagePicker
                                    .showDatePicker(
                                    context: context,
                                    initialFirstDate: picked[0],
                                    //初始--起始日期
                                    initialLastDate: picked[1],
                                    //初始--截止日期
                                    firstDate: new DateTime((DateTime.fromMicrosecondsSinceEpoch(0)).year),
                                    lastDate: new DateTime(((DateTime.now()).year)+1)
                                );
                                if (picked != null && picked.length == 2) {
                                  print(picked);
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => ChartPage(
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
                          ),

                          Expanded(  ///终止时间
                            flex: 6,
                            child: GestureDetector(
                              child: Container(
                                //color: Colors.yellowAccent,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6, bottom: 1),
                                      child: Text(
                                        '结束日期',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily:
                                          JizhangAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          letterSpacing: -0.1,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 30,
                                          height: 38,
                                          child: Icon(Icons.access_time,size: 25.0,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 4, bottom: 8),
                                          child: Text(
                                            '${picked[1].year}', ///终止时间 年
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily:
                                                JizhangAppTheme
                                                    .fontName,
                                                fontWeight:
                                                FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.blueGrey
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 2, bottom: 9),
                                          child: Text(
                                            (picked[1].month as int < 10 ? '0${picked[1].month}' : '${picked[1].month}') + '.' +
                                                (picked[1].day as int < 10 ? '0${picked[1].day}' : '${picked[1].day}'),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                              JizhangAppTheme
                                                  .fontName,
                                              fontWeight:
                                              FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: -0.2,
                                              color: JizhangAppTheme
                                                  .grey
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              onTap: () async { //初始日期要修改  //picked储存选择的时间期限
                                picked = await DateRagePicker
                                    .showDatePicker(
                                    context: context,
                                    initialFirstDate: picked[0],
                                    //初始--起始日期
                                    initialLastDate: picked[1],
                                    //初始--截止日期
                                    firstDate: new DateTime((DateTime.fromMicrosecondsSinceEpoch(0)).year),
                                    lastDate: new DateTime(((DateTime.now()).year)+1)
                                );
                                if (picked != null && picked.length == 2) {
                                  print(picked);
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => ChartPage(
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
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                        ],
                      )
                    ),
                  ),
                  Expanded(  ///饼状图
                    flex: 10,
                    child: Container(
                        //color: Colors.blueGrey,
                        width: double.infinity, //double类型
                        height: double.infinity,
                        //decoration: BoxDecoration(color:Colors.yellowAccent),
                        padding: const EdgeInsets.only(top: 20.0),
                        //传入相应的参数
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: data_empty(mData)?new MyCustomCircle(
                                    null,
                                    null, 0
                                ):
                                new MyCustomCircle(
                                    mData,
                                    pieData, currentSelect
                                ),
                              ),
                            ),
                            Expanded(  // 选中的类别
                              flex: 1,
                              child: Center(
                                child: data_empty(mData)?
                                Text('快去新建一笔记账吧！', style: TextStyle( //backgroundColor:Colors.white,
                                    inherit: true,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16),
                                  textAlign: TextAlign.center,
                                ):
                                MaterialButton(  ///类别按钮
                                  //color: Colors.deepOrangeAccent,
                                    padding: const EdgeInsets.only(bottom: 20),
                                    onPressed: (){
                                      //Navigator.of(context).pop();
                                      String checked = mData[subscript].name; ///类别
                                      List<LiushuiData> liuData = getLiuData(data, checked, widget.typeSelect, widget.type);
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => Dismissshow(
                                                  typeSelect: widget.typeSelect,
                                                  type: widget.type,
                                                  picked: widget.picked,
                                                  liuData: liuData,
                                                  color: mData[subscript].color,))).then((value) => setDataFromDB());
                                    },
                                    child: Center(
                                        child: Text(mData[currentSelect].name,
                                          style: TextStyle( //backgroundColor:Colors.white,
                                              inherit: true,
                                              color: Colors.blueGrey,
                                              fontSize: 24),)
                                    )
                                ),
                              )
                            )
                          ],
                        ),
                    ),
                  ),
                  Expanded(  //右侧
                    flex: 2,
                    child: GestureDetector(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              //color: Color(0xFF0000FF),
                              //alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Card(
                                elevation: 0,
                                margin: const EdgeInsets.only(right: 9, top:25),
                                child: Icon(Icons.arrow_right, size:40.0,
                                  color: Theme.of(context).primaryColor
                                ),
                              )
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container()
                          )
                        ],
                      ),
                      onTap: (){
                        data_empty(mData)?print('Nothing'):
                        _changeData();
                      },
                    )
                  ),
                ],
              ),
          ),
          Container(
            height: 10.0,
          ),
          Card(  // 类别
              margin: EdgeInsets.all(16.0),
              elevation: 2.0,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(14.0))),
              child: Container(
                  height: 260,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Card(
                              //margin: EdgeInsets.all(8.0),
                              elevation: 0.0,
                              margin: EdgeInsets.only(bottom: 1.0),
                              color: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(7.0))),
                              child:
                              Container(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 11,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 38.0, bottom: 5.0),
                                      child: Text('类别', style: TextStyle(fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor)),
                                    )
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 0.0, bottom: 5.0),
                                      child: Text(' 比例', style: TextStyle(fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).primaryColor)),
                                    )
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container()
                                ),
                                Expanded(
                                    flex: 9,
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 5.0),
                                      child: Text('金额', style: TextStyle(fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).primaryColor)),
                                    )
                                ),
                              ],
                            ),
                            /*decoration: new BoxDecoration(
                                border: new Border(
                                  bottom: BorderSide(color: Colors.black, width: 2.0), //信息的分割线
                                )
                            ),*/
                          )
                          )
                      ),
                      Expanded(  //类别图例
                          flex: 12,
                          child: mData==null?Container():
                          ListView.builder(
                              itemCount: mData.length,
                              itemBuilder: (context, index) {
                                final item = mData[index];
                                return new GestureDetector(
                                  child: new Card(
                                      //margin: EdgeInsets.all(8.0),
                                      elevation: 0.5,
                                      color: Colors.white,
                                      child: Container(
                                            height: 55, //每一条信息的高度
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 3,
                                                    child: Card(
                                                      elevation: 0,
                                                      child: Icon(Icons.arrow_right, size: 40.0, color: mData[index].color,),
                                                      margin: const EdgeInsets.only(bottom: 5.0),
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 8,
                                                    child: Container(
                                                      //color: Colors.blue,
                                                      padding: const EdgeInsets.only(bottom: 5.0),
                                                      child: Text(mData[index].name, style: TextStyle(fontSize: 15.0,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.blueGrey,)),
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 6,
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 0.0, bottom: 5.0),
                                                      child: Text(' ${formatNum((mData[index].percentage)*100, 2)==0?
                                                          formatNum((mData[index].percentage)*100, 3):
                                                          formatNum((mData[index].percentage)*100, 2)}%'
                                                          , style: TextStyle(fontSize: 17.0,
                                                              color: Colors.grey)),
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container()
                                                ),
                                                Expanded(
                                                    flex: 9,
                                                    child: Container(
                                                      padding: const EdgeInsets.only(bottom: 5.0), //'${formatNum(mData[index].price, 4)}'
                                                      child: Text('${mData[index].price}', style: TextStyle(fontSize: 17.0,
                                                                    color: mData[index].color)),
                                                    )
                                                ),
                                              ],
                                            )
                                        )
                                    ),
                                  onTap: (){
                                    String checked = mData[index].name; ///类别
                                    List<LiushuiData> liuData = getLiuData(data, checked, widget.typeSelect, widget.type);
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => Dismissshow(
                                              typeSelect: widget.typeSelect,
                                              type: widget.type,
                                              picked: widget.picked,
                                              liuData: liuData,
                                              color: mData[index].color,))).then((value) => setDataFromDB());

                                  },
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





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
      return Text("   $typeSelect"+"收入",style: TextStyle(fontSize: 23.0, color: JizhangAppTheme.deactivatedText,));
    }else if(type==1){
      return Text("   $typeSelect"+"支出",style: TextStyle(fontSize: 23.0, color: JizhangAppTheme.deactivatedText,));
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
                  List<LiushuiData> liuData = getLiuData(data, checked, typeSelect, type);
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Dismissshow(
                              typeSelect: typeSelect,
                              type: type,
                              picked: picked,
                              liuData: liuData)));
                },
              )
          ),
          Expanded(
              flex: 8,
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
              flex: 3,
              child: Container()
          ),
          Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text('${piedata.price}', style: TextStyle(fontSize: 25.0)),
              )
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        //padding: const EdgeInsets.only(top: 40),
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 60.0,
            ///副标题
            child: Row(
              children: [
                Expanded(  ///副标题
                  flex: 6,
                  child: title(typeSelect, type)
                ),
                Expanded(  ///选择分类
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: IconButton(  ///时间选择
                          icon: new Icon(Icons.select_all, color: JizhangAppTheme.grey, size: 18, ),
                          onPressed:(){
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                //transition: TransitionType.inFromBottom,
                                CupertinoPageRoute(
                                    builder: (context) => SelectPage(
                                        typeSelect: typeSelect,
                                        type: type,
                                        picked: picked)));
                          },
                        )
                        /*Icon(
                          Icons.select_all,
                          color: JizhangAppTheme.grey,
                          size: 18,
                        ),*/
                      ),
                      Text(
                        '分类',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: JizhangAppTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          letterSpacing: -0.2,
                          color: JizhangAppTheme.darkerText,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(  ///卡片
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.blue,//JizhangAppTheme.nearlyBlue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: JizhangAppTheme.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
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
                            flex: 1,
                            child: Container(),
                          ),
                          Expanded(  ///起始时间
                            flex: 2,
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
                                      'begin',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                        JizhangAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.1,
                                        color: JizhangAppTheme.grey
                                            .withOpacity(0.5),
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
                                        width: 28,
                                        height: 28,
                                        child: IconButton(  ///选择时间
                                          icon: new Icon(Icons.access_time),
                                          iconSize: 25.0,
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
                                        /*Image.asset(
                                                        "assets/fitness_app/eaten.png"),*/
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 6, bottom: 0),
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
                                            color: JizhangAppTheme
                                                .darkerText,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 3, bottom: 1),
                                        child: Text(
                                          '${picked[0].month}.'+'${picked[0].day}',  ///月 日
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
                          ),
                          Expanded(  ///终止时间
                            flex: 2,
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
                                      'end',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                        JizhangAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.1,
                                        color: JizhangAppTheme.grey
                                            .withOpacity(0.5),
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
                                        width: 28,
                                        height: 28,
                                        child: IconButton(  ///选择时间
                                          icon: new Icon(Icons.access_time),
                                          iconSize: 25.0,
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
                                        /*Image.asset(
                                                        "assets/fitness_app/burned.png"),*/
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 6, bottom: 0),
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
                                            color: JizhangAppTheme
                                                .darkerText,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 3, bottom: 1),
                                        child: Text(
                                          '${picked[1].month}.'+'${picked[1].day}', ///月 日
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
                          ),
                          Expanded(
                            flex: 1,
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
                                Text('Nothing!', style: TextStyle( //backgroundColor:Colors.white,
                                    inherit: true,
                                    color: Colors.grey,
                                    fontSize: 25),):
                                MaterialButton(  ///类别按钮
                                  //color: Colors.deepOrangeAccent,
                                    padding: const EdgeInsets.only(bottom: 20),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                      String checked = mData[subscript].name; ///类别
                                      List<LiushuiData> liuData = getLiuData(data, checked, widget.typeSelect, widget.type);
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => Dismissshow(
                                                  typeSelect: widget.typeSelect,
                                                  type: widget.type,
                                                  picked: widget.picked,
                                                  liuData: liuData)));
                                    },
                                    child: Center(
                                        child: Text(mData[currentSelect].name,
                                          style: TextStyle( //backgroundColor:Colors.white,
                                              inherit: true,
                                              color: Colors.grey,
                                              fontSize: 25),)
                                    )
                                ),
                              )
                            )
                          ],
                        ),
                    ),
                  ),
                  Expanded(  //右侧
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                              //color: Color(0xFF0000FF),
                              padding: const EdgeInsets.only(top: 20.0),
                              child: IconButton(
                                //padding: const EdgeInsets.only(right: 40),
                                icon: new Icon(Icons.arrow_right),
                                iconSize: 40.0,
                                color: Colors.green[500],
                                onPressed:(){
                                  data_empty(mData)?print('Nothing'):
                                  _changeData();
                                },
                              )
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container()
                        )
                      ],
                    )

                  ),
                ],
              ),
          ),
          Card(  // 类别
              margin: EdgeInsets.all(10.0),
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
                          flex: 4,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 11,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 38.0, bottom: 5.0),
                                      child: Text('类别', style: TextStyle(fontSize: 20.0)),
                                    )
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 0.0, bottom: 5.0),
                                      child: Text('比例', style: TextStyle(fontSize: 20.0)),
                                    )
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Container()
                                ),
                                Expanded(
                                    flex: 7,
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 5.0),
                                      child: Text('金额/元', style: TextStyle(fontSize: 18.0)),
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
                          flex: 12,
                          child: mData==null?Container():
                          ListView.builder(
                              itemCount: mData.length,
                              itemBuilder: (context, index) {
                                final item = mData[index];
                                return new GestureDetector(
                                    child: new Container(
                                        height: 55, //每一条信息的高度
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
                                                            builder: (context) => Dismissshow(
                                                                typeSelect: widget.typeSelect,
                                                                type: widget.type,
                                                                picked: widget.picked,
                                                                liuData: liuData)));
                                                  },
                                                )
                                            ),
                                            Expanded(
                                                flex: 8,
                                                child: Container(
                                                  //color: Colors.blue,
                                                  padding: const EdgeInsets.only(bottom: 5.0),
                                                  child: Text(mData[index].name, style: TextStyle(fontSize: 15.0)),
                                                )
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                  padding: const EdgeInsets.only(left: 0.0, bottom: 5.0),
                                                  child: Text('${formatNum(mData[index].percentage, 2)==0?
                                                      formatNum((mData[index].percentage)*100, 3):
                                                      formatNum((mData[index].percentage)*100, 2)}%'
                                                      , style: TextStyle(fontSize: 17.0)),
                                                )
                                            ),
                                            Expanded(
                                                flex: 4,
                                                child: Container()
                                            ),
                                            Expanded(
                                                flex: 7,
                                                child: Container(
                                                  padding: const EdgeInsets.only(bottom: 5.0),
                                                  child: Text('${formatNum((mData[index].price)/100, 3)}', style: TextStyle(fontSize: 17.0)),
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




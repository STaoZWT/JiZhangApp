import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/chart1/Tabs/ui_view/app_theme.dart';
import 'package:flutter_jizhangapp/chart1/chartpage.dart';
import 'package:flutter_jizhangapp/data/model.dart';
import 'package:flutter_jizhangapp/service/database.dart';


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

  double topBarOpacity = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
              '分类选择',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20.0, color: Theme.of(context).primaryColor),
          ),
          leading: Builder(builder: (context){
            return IconButton(
              icon: Icon(Icons.arrow_back,color: Theme.of(context).primaryColor,size: 28,),
              onPressed: (){
                Navigator.of(context).pop();
                /*Navigator.push(
                    context,
                    //transition: TransitionType.inFromBottom,
                    CupertinoPageRoute(
                        builder: (context) => ChartPage(
                            typeSelect: typeSelect,
                            type: type,
                            picked: picked)));*/
              },
            );
          }),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("image/cat.jpg"),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.8), BlendMode.lighten))),
        child: GridView(
          padding: EdgeInsets.only(left: 30.0,right: 30.0,top: 20.0),
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 30.0,
              childAspectRatio: 0.99
          ),
          children: [
            /*Center(
              child:Text("支出图表",
                style: TextStyle(backgroundColor:Colors.transparent,inherit:true,color:Colors.blueGrey,fontSize:22),
              ),
            ),
            Center(
              child:Text("收入图表",
                style: TextStyle(backgroundColor:Colors.transparent,inherit:true,color:Colors.blueGrey,fontSize:22),
              ),
            ),*/
            ///一级支出
            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 4,bottom: 4,left: 1,right: 1),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.looks_one, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '分类支出', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "分类支出";
                typeSelect = '一级分类';
                type = 1;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),
            ///一级收入
            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 4,bottom: 4,left: 1,right: 1),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.repeat_one, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '一级收入', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "分类收入";
                typeSelect = '一级分类';
                type = 0;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),
            ///二级支出
            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 4,bottom: 4,left: 1,right: 1),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.category, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '二级支出', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),)
              ),
              onTap: (){
                selected = "二级支出";
                typeSelect = '二级分类';
                type = 1;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),
            ///二级收入
            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 4,bottom: 4,left: 1,right: 1),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.looks_two, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '二级收入', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "二级收入";
                typeSelect = '二级分类';
                type = 0;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),

            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child:Card(
                    margin: EdgeInsets.only(top: 4,bottom: 4,left: 1,right: 1),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.account_box, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '账户支出', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "账户支出";
                typeSelect = '账户分类';
                type = 1;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),
            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 4,bottom: 4,left: 1,right: 1),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.account_circle, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '账户收入', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "账户收入";
                typeSelect = '账户分类';
                type = 0;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),

            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 4,bottom: 4,left: 1,right: 6),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.people, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '成员支出', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "成员支出";
                typeSelect = '成员分类';
                type = 1;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),
            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 1,bottom: 4,left: 1,right: 6),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.people_outline, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '成员收入', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "成员收入";
                typeSelect = '成员分类';
                type = 0;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),

            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 4,bottom: 4,left: 1,right: 6),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.shop, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '商家支出', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "商家支出";
                typeSelect = '商家分类';
                type = 1;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),
            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 1,bottom: 4,left: 1,right: 6),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.shop_two, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '商家收入', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "商家收入";
                typeSelect = '商家分类';
                type = 0;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),

            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 4,bottom: 4,left: 1,right: 6),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.pageview, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '项目支出', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "项目支出";
                typeSelect = '项目分类';
                type = 1;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),
            GestureDetector(
              child: Container(
                  color: Colors.white12,
                  child: Card(
                    margin: EdgeInsets.only(top: 1,bottom: 4,left: 1,right: 6),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 28,
                          child: Icon(Icons.looks, size: 28.0,
                            color: Theme.of(context).primaryColor,),
                        ),
                        Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 4),
                            child: Center(
                              child: Text(
                                '项目收入', ///终止时间 年
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily:
                                  JizhangAppTheme
                                      .fontName,
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
              onTap: (){
                selected = "项目收入";
                typeSelect = '项目分类';
                type = 0;
                print(selected);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChartPage(
                        typeSelect: typeSelect,
                        type: type,
                        picked: picked)));
              },
            ),
          ],
        ),
      ),


    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_jizhangapp/chart1/chart_material.dart';
import 'package:flutter_jizhangapp/chart1/chartpage.dart';
import 'package:flutter_jizhangapp/service/database.dart';
import 'package:toast/toast.dart';


class Dismissshow_testPage extends StatefulWidget {
  List<LiushuiData> liuData; //接收传值
  String typeSelect; //类型
  int type;
  var picked; //时间

  Dismissshow_testPage({Key key, this.liuData, this.type, this.typeSelect, this.picked}) : super(key: key);

  @override
  _Dismissshow_testPage createState() => _Dismissshow_testPage();
}

class _Dismissshow_testPage extends State<Dismissshow_testPage> {

  //传入数据!!!!!!!!!
  //类别、时间、金额
  /*String c1c2mc;//类别
  DateTime date; //日期
  int value; //金额*/

  setDataFromDB(int id) async { // 得到数据
    await BillsDatabaseService.db.deleteBillIdInDB(id);
  }

  String checked;
  int type;

  @override
  void initState() {
    checked = ((widget.liuData)[0]).c1c2mc;
    type = widget.type;
  }


  //typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
  //type 0:收入， 1：支出
  //默认为“一级分类支出”
  title() {
    if(type==0){
      return Text("$checked"+"收入",style: TextStyle(fontSize: 30.0));
    }else if(type==1){
      return Text("$checked"+"支出",style: TextStyle(fontSize: 30.0));
    }
  }

  timeEqual(DateTime time1, DateTime time2){
    if(time1==null){
      return false;
    }
    if(time1.year==time2.year &&  // 同一天
        time1.month==time2.month &&
        time1.day==time2.day){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar( //标题
          backgroundColor: Colors.blue,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ChartPage(
                            typeSelect: widget.typeSelect,
                            type: widget.type,
                            picked: widget.picked)));
              }),
          centerTitle: true,
          title: title()//界面标题内容
      ),
      body: new ListView.builder(
            itemCount: (widget.liuData).length,
            itemBuilder: (context, index) {
              final item = (widget.liuData)[index];
              DateTime time = (index==0)?null:(widget.liuData)[index-1].date;
              return new GestureDetector(
                onHorizontalDragEnd: (endDetails) {
                  setState(() {
                    (widget.liuData)[index].show =
                    (widget.liuData)[index].show == true ? false : true;
                  });
                },
                child: Container(
                    height: timeEqual(time,(widget.liuData)[index].date)?45.0:80.0, //每一条信息的高度
                    padding: const EdgeInsets.only(left: 5.0), //每条信息左边距
                    /*decoration: new BoxDecoration(
                    border: new Border(
                      bottom: BorderSide(color: Colors.black, width: 0.5), //信息的分割线
                    )),*/
                    child: Column(
                      children: [
                        Expanded(
                          flex: timeEqual(time,(widget.liuData)[index].date)?1:3,
                          child: timeEqual(time,(widget.liuData)[index].date)?
                          Container( //间隔线
                            height: 0.5,
                            color: Colors.white54,
                          ):
                          Container( //时间
                            height: 30,
                            width: double.infinity,
                            padding: const EdgeInsets.only(left:10.0, top: 10.0), //每条信息左边距
                            color: Colors.white54,
                            child: Text('${(item.date).year}-${(item.date).month}-${(item.date).day}',
                                style: TextStyle(fontSize: 23.0)),
                          ),
                          /*Card( //时间
                              //margin: EdgeInsets.all(5.0),
                              elevation: 15.0,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(14.0))),
                              child: Container(
                                height: 30.0,
                                width: double.infinity,
                                child: Text('${(item.date).year}-${(item.date).month}-${(item.date).day}',
                                    style: TextStyle(fontSize: 23.0)),
                              )*/
                        ),
                        Expanded(
                          flex: timeEqual(time,(widget.liuData)[index].date)?100:4,
                          child: Card(
                            //margin: EdgeInsets.all(5.0),
                            elevation: 15.0,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(14.0))),
                            child:Container(
                              height: 40.0, //每一条信息的高度
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 5.0, bottom: 5.0), //每条信息左边距
                              /*decoration: new BoxDecoration(
                                border: new Border(
                                  bottom: BorderSide(color: Colors.black, width: 0.5), //信息的分割线
                                )),*/
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  item.show == true ? //是否被删除
                                  new RaisedButton(
                                      child: new Text('删除'),
                                      onPressed: () {
                                        print('click');
                                        setState(() {
                                          Toast.show('${widget.typeSelect}'+'   '
                                              '${(widget.liuData)[index].c1c2mc}   已删除',context);
                                          setDataFromDB((widget.liuData)[index].id);
                                          (widget.liuData).removeAt(index);  //删除某条信息!!!!!!!!!
                                        });
                                      },
                                      color: Colors.red,
                                      splashColor: Colors.pink[100])
                                      : new Text(''),
                                  new Text('${(widget.liuData)[index].category2}: '+
                                      //'${(widget.liuData)[index].type==0?'收入':''}'+
                                      //'${(widget.liuData)[index].type==1?'支出':''}'+
                                      //'${(widget.liuData)[index].type==3?'转出账户:':''}'+
                                      //'${(widget.liuData)[index].type==4?'转入账户:':''}'+
                                      '\t\t${((widget.liuData)[index].value)/100}元',
                                      //'${((widget.liuData)[index].date).year}-${((widget.liuData)[index].date).month}-${((widget.liuData)[index].date).day}',
                                      style: TextStyle(fontSize: 20.0)),
                                ],
                              ),
                          ),
                          )
                        ),
                      ],
                    ),
                  ),

              );
            },
          ),

    );
  }
}

/*Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: timeEqual(time,(widget.liuData)[index].date)?
                      Container():
                      Container(
                        height: 20.0,
                        width: double.infinity,
                        child: Text('${(item.date).year}-${(item.date).month}-${(item.date).day}'),
                      ),
                  ),
                  Expanded(
                    //flex: 5,
                    child: Container(
                      height: 50.0, //每一条信息的高度
                      padding: const EdgeInsets.only(left: 20.0), //每条信息左边距
                      /*decoration: new BoxDecoration(
                      border: new Border(
                        bottom: BorderSide(color: Colors.black, width: 0.5), //信息的分割线
                      )),*/
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          item.show == true ? //是否被删除
                          new RaisedButton(
                              child: new Text('删除'),
                              onPressed: () {
                                print('click');
                                setState(() {
                                  Toast.show('${widget.typeSelect}'+'   '
                                      '${(widget.liuData)[index].c1c2mc}   已删除',context);
                                  setDataFromDB((widget.liuData)[index].id);
                                  (widget.liuData).removeAt(index);  //删除某条信息!!!!!!!!!
                                });
                              },
                              color: Colors.red,
                              splashColor: Colors.pink[100])
                              : new Text(''),
                          new Text('${(widget.liuData)[index].c1c2mc}: '+'${(widget.liuData)[index].type==0?'收入':''}'+
                              '${(widget.liuData)[index].type==1?'支出':''}'+
                              //'${(widget.liuData)[index].type==3?'转出账户:':''}'+
                              //'${(widget.liuData)[index].type==4?'转入账户:':''}'+
                              '金额${((widget.liuData)[index].value)/100} '+
                              '${((widget.liuData)[index].date).year}-${((widget.liuData)[index].date).month}-${((widget.liuData)[index].date).day}')
                        ],
                      ),
                    ),
                  ),
                ],
              )*/

/*Scaffold(
      appBar: new AppBar( //标题
        backgroundColor: Colors.blue,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ChartPage(
                          pie_bar: widget.pie_bar,
                          typeSelect: widget.typeSelect,
                          type: widget.type,
                          picked: widget.picked)));
            }),
        centerTitle: true,
        title: title()//界面标题内容
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
          itemCount: (widget.liuData).length,
          itemBuilder: (context, index) {
            final item = (widget.liuData)[index];
            return new GestureDetector(
              child:  Card(
                margin: EdgeInsets.all(8.0),
                elevation: 15.0,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(14.0))),
                child: new Container(
                  height: 250,
                  width: double.infinity,
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Expanded( //日期
                            flex: 3,
                            child: Text('${(item.time).year}'+'-${(item.time).month}'+'-${(item.time).day}'),
                          ),
                          Expanded( //流水
                            flex: 8,
                            child: ListView.builder(
                              itemCount: (item.data).length,
                              itemBuilder: (context, index1) {
                                final item1 = (item.data)[index1];
                                return new GestureDetector(
                                  onHorizontalDragEnd: (endDetails) {
                                    setState(() {
                                      item1.show =
                                      item1.show == true ? false : true;
                                    });
                                  },
                                  child: new Container(
                                    height: 50.0, //每一条信息的高度
                                    padding: const EdgeInsets.only(left: 20.0), //每条信息左边距
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                          bottom: BorderSide(color: Colors.black, width: 0.5), //信息的分割线
                                        )
                                    ),
                                    child: new Row(
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        item1.show == true ? //是否被删除
                                        new RaisedButton(
                                            child: new Text('删除'),
                                            onPressed: () {
                                              print('click');
                                              setState(() {
                                                Toast.show('${widget.typeSelect}'+'   '
                                                    '${item1.category2}   已删除',context);
                                                setDataFromDB(item1.id);
                                                (item.data).removeAt(index);  //删除某条信息!!!!!!!!!
                                              });
                                            },
                                            color: Colors.red,
                                            splashColor: Colors.pink[100]
                                        ) : new Text(''),
                                        new Text('${item1.category2}: '+
                                            '金额${item1.value/100} '+
                                            '${(item.time).year}-${(item.time).month}-${(item.time).day}')
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              )
            );
          }
        ),
      )
    );*/



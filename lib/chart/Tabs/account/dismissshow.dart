import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_jizhangapp/service/database.dart';
import 'package:toast/toast.dart';

import '../../chart_material.dart';
import '../../chartpage.dart';

class Dismissshow extends StatefulWidget {
  List<LiushuiData> liuData; //接收传值
  String typeSelect; //类型
  int type;
  var picked; //时间
  int pie_bar = 0; //0--饼状图  1--条形图

  Dismissshow({Key key, this.liuData, this.type, this.typeSelect, this.picked, this.pie_bar}) : super(key: key);

  @override
  _Dismissshow createState() => _Dismissshow();
}

class _Dismissshow extends State<Dismissshow> {

  //传入数据!!!!!!!!!
  //类别、时间、金额
  /*String c1c2mc;//类别
  DateTime date; //日期
  int value; //金额*/

  setDataFromDB(int id) async { // 得到数据
    await BillsDatabaseService.db.deleteBillIdInDB(id);
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
        title: title((widget.liuData)[0].c1c2mc, widget.type)//界面标题内容
      ),
      body: Card(
        margin: EdgeInsets.all(8.0),
        elevation: 15.0,
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(14.0))),
        child: new ListView.builder(
          itemCount: (widget.liuData).length,
          itemBuilder: (context, index) {
            final item = (widget.liuData)[index];
            return new GestureDetector(
              onHorizontalDragEnd: (endDetails) {
                setState(() {
                  (widget.liuData)[index].show =
                  (widget.liuData)[index].show == true ? false : true;
                });
              },
              child: new Container(
                height: 50.0, //每一条信息的高度
                padding: const EdgeInsets.only(left: 20.0), //每条信息左边距
                decoration: new BoxDecoration(
                    border: new Border(
                      bottom: BorderSide(color: Colors.black, width: 0.5), //信息的分割线
                    )),
                child: new Row(
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
                        '金额${((widget.liuData)[index].value)/100} '+
                        '${((widget.liuData)[index].date).year}-${((widget.liuData)[index].date).month}-${((widget.liuData)[index].date).day}')
                  ],
                ),
              ),
            );
          },
        ),
      )
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_jizhangapp/chart1/chart_material.dart';
import 'package:flutter_jizhangapp/chart1/chartpage.dart';
import 'package:flutter_jizhangapp/service/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../../service/database.dart';
import '../../../data/model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dismissshow extends StatefulWidget {
  String title;
  List<LiushuiData> liuData; //接收传值
  String typeSelect; //类型
  int type;
  var picked; //时间
  Color color; //对应颜色

  Dismissshow(
      {Key key,
      this.title,
      this.liuData,
      this.type,
      this.typeSelect,
      this.picked,
      this.color})
      : super(key: key);

  @override
  _Dismissshow createState() => _Dismissshow();
}

class _Dismissshow extends State<Dismissshow> {
  //传入数据!!!!!!!!!
  //类别、时间、金额
  /*String c1c2mc;//类别
  DateTime date; //日期
  int value; //金额*/

  setDataFromDB(int id) async {
    // 得到数据
    await BillsDatabaseService.db.deleteBillIdInDB(id);
  }

  String checked;
  int type;

  @override
  void initState() {
    checked = empty(widget.liuData) ? widget.title : (widget.liuData)[0].c1c2mc;
    type = widget.type;
  }

  //typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
  //type 0:收入， 1：支出
  //默认为“一级分类支出”
  title(BuildContext context) {
    if (widget.type == 0) {
      return Text("$checked" + " 收入",
          style:
              TextStyle(fontSize: 21.0, color: Theme.of(context).primaryColor));
    } else if (widget.type == 1) {
      return Text("$checked" + " 支出",
          style:
              TextStyle(fontSize: 21.0, color: Theme.of(context).primaryColor));
    }
  }

  timeEqual(DateTime time1, DateTime time2) {
    if (time1 == null) {
      return false;
    }
    if (time1.year == time2.year && // 同一天
        time1.month == time2.month &&
        time1.day == time2.day) {
      return true;
    } else {
      return false;
    }
  }

  weekday(int weekday) {
    if (weekday == 1) {
      return '一';
    } else if (weekday == 2) {
      return '二';
    } else if (weekday == 3) {
      return '三';
    } else if (weekday == 4) {
      return '四';
    } else if (weekday == 5) {
      return '五';
    } else if (weekday == 6) {
      return '六';
    } else if (weekday == 7) {
      return '日';
    }
  }

  empty(List<LiushuiData> liuData) {
    if (liuData == null) {
      return true;
    } else if (liuData.length <= 0) {
      return true;
    } else if (liuData.length >= 0) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          //标题
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).primaryColor, size: 28),
              onPressed: () {
                Navigator.of(context).pop();
                /*Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ChartPage(
                            typeSelect: widget.typeSelect,
                            type: widget.type,
                            picked: widget.picked)));*/
              }),
          centerTitle: true,
          title: title(context) //界面标题内容
          ),
      body: empty(widget.liuData)
          ? Container()
          : ListView.builder(
              itemCount: (widget.liuData).length,
              itemBuilder: (context, index) {
                final item = (widget.liuData)[index];
                DateTime time =
                    (index == 0) ? null : (widget.liuData)[index - 1].date;
                return new GestureDetector(
                  onHorizontalDragEnd: (endDetails) {
                    setState(() {
                      (widget.liuData)[index].show =
                          (widget.liuData)[index].show == true ? false : true;
                    });
                  },
                  child: Container(
                    height: timeEqual(time, (widget.liuData)[index].date)
                        ? 70.0
                        : 120.0, //每一条信息的高度
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.only(left: 5.0), //每条信息左边距
                    /*decoration: new BoxDecoration(
                    border: new Border(
                      bottom: BorderSide(color: Colors.black, width: 0.5), //信息的分割线
                    )),*/
                    child: Column(
                      children: [
                        Expanded(
                          flex: timeEqual(time, (widget.liuData)[index].date)
                              ? 1
                              : 4,
                          child: timeEqual(time, (widget.liuData)[index].date)
                              ? Center(
                                  //间隔线
                                  child: Container(),
                                )
                              : Container(
                                  //时间
                                  height: 30,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom:10),
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 10.0), //每条信息左边距
                                  //color: Colors.white54,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text('${(item.date).year}',
                                            style: TextStyle(
                                                fontSize: 22.0,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                            '${(item.date).month}.${(item.date).day}',
                                            style: TextStyle(
                                                fontSize: 21.0,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                            '周' + weekday((item.date).weekday),
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Container(),
                                      )
                                    ],
                                  )),
                        ),
                        Expanded(
                            flex: timeEqual(time, (widget.liuData)[index].date)
                                ? 200
                                : 6,
                              child: Slidable(
                                actionPane:
                                    SlidableStrechActionPane(), //滑出选项的面板 动画
                                actionExtentRatio: 0.25,
                                child: Card(
                                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                    elevation: 2.0,
                                    color: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(7.0))),
                                      child: SizedBox(
                                        height: 200,
                                        width: 500,
                                        child: ListTile(
                                          leading: new Icon(
                                            Icons.category,
                                            color: widget.color,
                                          ),
                                          title: new Text(
                                              '${(widget.liuData)[index].category2}:' +
                                                  '           ' +
                                                  '${formatNum(((widget.liuData)[index].value) / 100, 3)} 元',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.blueGrey)),
                                          subtitle: new Text(
                                            '${(item.date).hour}时${(item.date).minute}分',
                                          ),
                                          onTap: () => print("$index被点击了"),
                                          onLongPress: () => print("$index被长按了"),
                                        ),
                                      ),
                                ),
                                secondaryActions: <Widget>[
                                  //右侧按钮列表
                                  IconSlideAction(
                                    caption: '详情',
                                    color: Colors.black45,
                                    icon: Icons.more_horiz,
                                    onTap: () async {
                                      BillsModel bill = await getDataFromDB((widget.liuData)[index].id);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("确定"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                              title: //Text('流水详情'),
                                              Container(
                                                height: 50,
                                                width: 200,
                                                child: Row(
                                                  children: <Widget>[
                                                    Text('流水详情',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 20,
                                                        letterSpacing: -0.1,
                                                        color: Theme.of(context).primaryColor
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                    ),
                                                    IconButton(
                                                      icon:Icon(Icons.close),
                                                      onPressed:() {Navigator.of(context).pop();},
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              content:
                                              SizedBox(
                                                width: 150,
                                                height: 400,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 4, right: 4, top: 8, bottom: 16),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      //时间
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(Icons.date_range),
                                                                  Text(
                                                                    ' 时间',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(

                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 16,
                                                                      letterSpacing: -0.2,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '${bill.date.month}月${bill.date.day}日',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 16,
                                                                  color:
                                                                  Theme.of(context).primaryColor,
                                                                ),
                                                              ),

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //金额
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  FaIcon(FontAwesomeIcons.yenSign),
                                                                  Text(
                                                                    '  金额',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(

                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 16,
                                                                      letterSpacing: -0.2,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '${value100ConvertToText (bill.value100)} 元',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 16,
                                                                  color:
                                                                  Theme.of(context).primaryColor,
                                                                ),
                                                              ),

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //分类1、转出账户
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(Icons.arrow_forward_ios,),
                                                                  Text(
                                                                    (bill.type==2)?' 转出':' 分类1',
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 16,
                                                                      letterSpacing: -0.2,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                (bill.type==2)?'${bill.accountOut}':'${bill.category1}',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 16,
                                                                  color:
                                                                  Theme.of(context).primaryColor,
                                                                ),
                                                              ),

                                                            ),

                                                          ],
                                                        ),

                                                      ),
                                                      //分类2、转入账户
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(Icons.arrow_forward_ios,),
                                                                  Text(
                                                                    (bill.type==2)?' 转入':' 分类2',
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 16,
                                                                      letterSpacing: -0.2,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                (bill.type==2)?'${bill.accountIn}':'${bill.category2}',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 16,
                                                                  color:
                                                                  Theme.of(context).primaryColor,
                                                                ),
                                                              ),

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //账户
                                                      Visibility(
                                                        visible: bill.type != 2,
                                                        child: Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: <Widget>[
                                                                    Icon(Icons.account_balance_wallet),
                                                                    Text(
                                                                      ' 账户',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 16,
                                                                        letterSpacing: -0.2,
                                                                        color: Theme.of(context).primaryColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  '${bill.accountOut}',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 16,
                                                                    color:
                                                                    Theme.of(context).primaryColor,
                                                                  ),
                                                                ),

                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      //成员
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(Icons.supervisor_account),
                                                                  Text(
                                                                    ' 成员',
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 16,
                                                                      letterSpacing: -0.2,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '${bill.member}',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 16,
                                                                  color:
                                                                  Theme.of(context).primaryColor,
                                                                ),
                                                              ),

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //商家
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(Icons.shop),
                                                                  Text(
                                                                    ' 商家',
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 16,
                                                                      letterSpacing: -0.2,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '${bill.merchant2}',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 16,
                                                                  color:
                                                                  Theme.of(context).primaryColor,
                                                                ),
                                                              ),

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      //项目
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(Icons.looks),
                                                                  Text(
                                                                    ' 项目',
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 16,
                                                                      letterSpacing: -0.2,
                                                                      color: Theme.of(context).primaryColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '${bill.project2}',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 16,
                                                                  color:
                                                                  Theme.of(context).primaryColor,
                                                                ),
                                                              ),

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 24, right: 24, top: 8, bottom: 8),
                                                        child: Divider(),
                                                      ),
                                                      //备注
                                                      Expanded(
                                                        flex: 3,
                                                        child:Text(
                                                          '${bill.title}',
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 12,
                                                            color:
                                                            Theme.of(context).primaryColor.withOpacity(0.4),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          ;

                                        },
                                      );
                                    },
                                  ),
                                  IconSlideAction(
                                    caption: '删除',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    closeOnTap: false,
                                    onTap: () {
                                      //_showSnackBar('Delete');
                                      print('click');
                                      setState(() {
                                        Toast.show(
                                            '${widget.typeSelect}' +
                                                '   '
                                                    '${(widget.liuData)[index].c1c2mc}   已删除',
                                            context);
                                        setDataFromDB(
                                            (widget.liuData)[index].id);
                                        (widget.liuData)
                                            .removeAt(index); //删除某条信息!!!!!!!!!
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    Dismissshow(
                                                      typeSelect:
                                                          widget.typeSelect,
                                                      type: widget.type,
                                                      picked: widget.picked,
                                                      liuData: widget.liuData,
                                                      title: checked,
                                                      color: widget.color,
                                                    )));
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<BillsModel> getDataFromDB(int id) async {
    BillsModel bill = await BillsDatabaseService.db.getBillById(id);
    return bill;
  }

  String value100ConvertToText (int value100) {
    String ans = (value100 > 99)?
    value100.toString().substring(0, value100.toString().length-2)
        + '.'
        + value100.toString().substring(value100.toString().length-2, value100.toString().length):
    (value100 > 9) ? '0.' + value100.toString() :'0.0' + value100.toString();
    return ans;
  }

}


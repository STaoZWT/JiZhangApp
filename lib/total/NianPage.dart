// flutter_speed_dial: ^1.2.4
//flutter_slidable: ^0.5.4
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import '../total/TotalPage.dart';
import '../data/model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_jizhangapp/service/database.dart';

import 'TimePage.dart';

int accountNumber;
int flag = 0;

class NianPage extends StatefulWidget {
  NianPage({Key key}) : super(key: key);

  @override
  _NianPageState createState() => _NianPageState();
}

class _NianPageState extends State<NianPage> {
  @override
  Widget build(BuildContext context) {
    return NianPageContent();
  }
}

class NianPageContent extends StatefulWidget {
  NianPageContent({Key key}) : super(key: key);

  @override
  _NianPageContentState createState() => _NianPageContentState();
}

class _NianPageContentState extends State<NianPageContent>
    with TickerProviderStateMixin {
  int maxAc;
  List totalList = [
    {'账户': 0, '金额100': 0, '金额': '0'}
  ];
  List<BillsModel> billsList;
//账单明细
  List detailList = [
    {
      'id': 0,
      'type': '类型',
      'date': DateTime.now(),
      'title': '备注',
      'category1': '一级分类',
      'category2': '二级分类',
      'member': '成员',
      '金额100': 0,
      '金额': '0',
      '明细': []
    }
  ];
  List yearList = [
    {'日期': DateTime.now().year, '金额100': 0, '金额': '0', '明细': []}
  ];
  List yearList1 = [
    {'日期': DateTime.now().year, '金额100': 0, '金额': '0', '明细': []}
  ];

  setBillsFromDB() async {
    print("Entered setBills");
    var fetchedBills = await BillsDatabaseService.db.getBillsFromDB();
    setState(() {
      billsList = fetchedBills;
    });
  }

  addBill() async {
    BillsModel billsModel = BillsModel.random();
    await BillsDatabaseService.db.addBillInDB(billsModel);
  }

  // deleteBillInDB(BillsModel billToDelete) async {
  //   final db = await database;
  //   await db.delete('Bills', where: '_id = ?', whereArgs: [billToDelete.id]);
  //   print('Bill deleted');
  // }

  List accountName = [];
  int maxAcCount() {
    if (billsList == null) {
      flag = 0;
      return 0;
    } else if (billsList.length <= 0) {
      flag = 0;
      return 0;
    } else if (billsList.length > 0) {
      accountName.add(billsList[0].accountIn);
      accountName.clear();
      for (var i = 0; i < billsList.length; i++) {
        accountName.add(billsList[i].accountIn);
        accountName.add(billsList[i].accountOut);
      }
      var s = new Set();
      s.addAll(accountName);
      accountName = s.toList();
      accountName.insert(0, '净资产');
      flag = 1;
      return accountName.length;
    }
    flag = 0;
    return 0;
  }

  List inittotalList() {
    totalList.clear();
    //totalList.add({'账户': '净资产', '金额100': 0, '金额': '0'});
    for (var i = 0; i < maxAc; i++) {
      String tempaccountName = accountName[i];
      totalList.add({'账户': tempaccountName, '金额100': 0, '金额': '0'});
    }
    return totalList;
  }

  List countT() {
    //清零
    for (var j = 0; j < maxAc; j++) {
      totalList[j]['金额100'] = 0;
      totalList[j]['金额'] = '0';
    }
    //计算
    for (var i = 0; i < billsList.length; i++) {
      if (billsList[i].type == 0) {
        for (var j = 1; j < maxAc; j++) {
          if (billsList[i].accountOut == totalList[j]['账户']) {
            totalList[j]['金额100'] += billsList[i].value100;
            totalList[0]['金额100'] += billsList[i].value100;
          }
        }
      } else if (billsList[i].type == 1) {
        for (var j = 1; j < maxAc; j++) {
          if (billsList[i].accountOut == totalList[j]['账户']) {
            totalList[j]['金额100'] -= billsList[i].value100;
            totalList[0]['金额100'] -= billsList[i].value100;
          }
        }
      } else if (billsList[i].type == 2) {
        for (var j = 1; j < maxAc; j++) {
          if (billsList[i].accountOut == totalList[j]['账户']) {
            totalList[j]['金额100'] -= billsList[i].value100;
            totalList[0]['金额100'] -= billsList[i].value100;
          }
          if (billsList[i].accountIn == totalList[j]['账户']) {
            totalList[j]['金额100'] += billsList[i].value100;
            totalList[0]['金额100'] += billsList[i].value100;
          }
        }
      }
    }
    for (var j = 0; j < maxAc; j++) {
      String temp;
      String temp100 = totalList[j]['金额100'].toString();
      if (totalList[j]['金额100'] == 0) {
        temp = '0.00';
      } else if (totalList[j]['金额100'] > -10 && totalList[j]['金额100'] < 0) {
        temp = temp100.substring(0, 1) + "0.0" + temp100.substring(1, 2);
      } else if (totalList[j]['金额100'] > 0 && totalList[j]['金额100'] < 10) {
        temp = "0.0" + temp100.substring(1, 1);
      } else if (totalList[j]['金额100'] > -100 && totalList[j]['金额100'] <= -10) {
        temp = temp100.substring(0, 1) + "0." + temp100.substring(1, 3);
      } else if (totalList[j]['金额100'] >= 10 && totalList[j]['金额100'] < 100) {
        temp = "0." + temp100.substring(0, 2);
      } else {
        temp = temp100.substring(0, temp100.length - 2) +
            "." +
            temp100.substring(temp100.length - 2, temp100.length);
      }
      totalList[j]['金额'] = temp;
    }
    return totalList;
  }

  initall() async {
    await setBillsFromDB();
    //print(billsList.length);
    //billsList.sort((a, b) => (b.date).compareTo(a.date));
    maxAc = maxAcCount();
    //print(maxAc);
    totalList = inittotalList();
    totalList = countT();
    yearList = inityearList();
    yearList1.clear();
    for (var i = 0; i < yearList.length; i++) {
      if (yearList[i]['存在'] == 1) {
        yearList1.add(yearList[i]);
      }
    }
    flag = 1;
  }

  Animation animation;
  AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    flag = 0;
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    animation = new Tween(begin: 0.0, end: 0.5).animate(animationController);
    accountNumber = acountChange();
    initall();
  }

  _changeTrailing(bool expand) {
    setState(() {
      if (expand) {
        animationController.reverse();
      } else {
        animationController.forward();
      }
    });
  }

  empty(List<BillsModel> billsList) {
    if (billsList == null) {
      flag = 0;
      return true;
    } else if (billsList.length <= 0) {
      flag = 0;
      return true;
    } else if (billsList.length > 0) {
      flag = 1;
      return false;
    }
    flag = 0;
    return true;
  }

  List inityearList() {
    DateTime lastTime = DateTime.now();
    DateTime firstTime = empty(billsList) ? DateTime.now() : billsList[0].date;

    // print(
    //     '///////////////////////////////////////////yeardifference///////////////////////////////////////////');
    // print(yeardifference);
    List nianList = [
      {
        'id': 0,
        '日期': DateTime(2020, 09, 18, 20, 23, 45),
        '金额100': 0,
        '金额': '0',
        '明细': [],
        '存在': 0
      }
    ];

    //重建
    nianList.clear();

    String tempaccountName =
        empty(billsList) || accountNumber > accountName.length - 1
            ? null
            : accountName[accountNumber];
    if (tempaccountName == '净资产') {
      for (var i = 0; i < billsList.length; i++) {
        if (lastTime.isAfter(billsList[i].date)) {
          lastTime = billsList[i].date;
        }
        if (firstTime.isBefore(billsList[i].date)) {
          firstTime = billsList[i].date;
        }
      }
      final yeardifference = firstTime.year - lastTime.year;
      int yeartemp = lastTime.year - 1;
      for (var i = 0; i < yeardifference + 1; i++) {
        detailList.clear();
        yeartemp++;
        nianList
            .add({'日期': yeartemp, '金额100': 0, '金额': '0', '明细': [], '存在': 0});

        for (var j = 0; j < billsList.length; j++) {
          if (billsList[j].date.year == yeartemp) {
            if (billsList[j].type == 0) {
              nianList[i]['金额100'] += billsList[j].value100;
              String detailtemp;
              String detailtemp100 = billsList[j].value100.toString();
              if (billsList[j].value100 == 0) {
                detailtemp = '0.00';
              } else if (billsList[j].value100 > 0 &&
                  billsList[j].value100 < 10) {
                detailtemp = "0.0" + detailtemp100.substring(1, 1);
              } else if (billsList[j].value100 >= 10 &&
                  billsList[j].value100 < 100) {
                detailtemp = "0." + detailtemp100.substring(0, 2);
              } else {
                detailtemp =
                    detailtemp100.substring(0, detailtemp100.length - 2) +
                        "." +
                        detailtemp100.substring(
                            detailtemp100.length - 2, detailtemp100.length);
              }
              String tempcardName2 = billsList[j].accountIn;
              nianList[i]['存在'] = 1;
              detailList.add({
                'id': billsList[j].id,
                'type': tempcardName2,
                'date': billsList[j].date,
                'title': billsList[j].title,
                'category1': billsList[j].category1,
                'category2': billsList[j].category2,
                'member': billsList[j].member,
                '金额100': billsList[j].value100,
                '金额': detailtemp,
              });
            } else if (billsList[j].type == 1) {
              nianList[i]['金额100'] -= billsList[j].value100;
              String detailtemp;
              String detailtemp100 = billsList[j].value100.toString();

              if (billsList[j].value100 == 0) {
                detailtemp = '0.00';
              } else if (billsList[j].value100 > 0 &&
                  billsList[j].value100 < 10) {
                detailtemp = "0.0" + detailtemp100.substring(1, 1);
              } else if (billsList[j].value100 >= 10 &&
                  billsList[j].value100 < 100) {
                detailtemp = "0." + detailtemp100.substring(0, 2);
              } else {
                detailtemp ='-'+
                    detailtemp100.substring(0, detailtemp100.length - 2) +
                        "." +
                        detailtemp100.substring(
                            detailtemp100.length - 2, detailtemp100.length);
              }

              String tempcardName1 = billsList[j].accountOut;
              nianList[i]['存在'] = 1;
              detailList.add({
                'id': billsList[j].id,
                'type': tempcardName1,
                'date': billsList[j].date,
                'title': billsList[j].title,
                'category1': billsList[j].category1,
                'category2': billsList[j].category2,
                'member': billsList[j].member,
                '金额100': billsList[j].value100,
                '金额': detailtemp,
              });
            } else if (billsList[j].type == 2) {
              String detailtemp;
              String detailtemp100 = billsList[j].value100.toString();
              if (billsList[j].value100 == 0) {
                detailtemp = '0.00';
              } else if (billsList[j].value100 > 0 &&
                  billsList[j].value100 < 10) {
                detailtemp = "0.0" + detailtemp100.substring(1, 1);
              } else if (billsList[j].value100 >= 10 &&
                  billsList[j].value100 < 100) {
                detailtemp = "0." + detailtemp100.substring(0, 2);
              } else {
                detailtemp =
                    detailtemp100.substring(0, detailtemp100.length - 2) +
                    "." +
                    detailtemp100.substring(
                        detailtemp100.length - 2, detailtemp100.length);
              }
              String tempcardName1 = billsList[j].accountOut;
              String tempcardName2 = billsList[j].accountIn;
              nianList[i]['存在'] = 1;
              detailList.add({
                'id': billsList[j].id,
                'type': tempcardName1 + '转账到' + tempcardName2,
                'date': billsList[j].date,
                'title': billsList[j].title,
                'category1': billsList[j].category1,
                'category2': billsList[j].category2,
                'member': billsList[j].member,
                '金额100': billsList[j].value100,
                '金额': detailtemp,
              });
            }
          }
        }
        String temp;
        String temp100 = nianList[i]['金额100'].toString();
        if (nianList[i]['金额100'] == 0) {
          temp = '0.00';
        } else if (nianList[i]['金额100'] > -10 && nianList[i]['金额100'] < 0) {
          temp = temp100.substring(0, 1) + "0.0" + temp100.substring(1, 2);
        } else if (nianList[i]['金额100'] > 0 && nianList[i]['金额100'] < 10) {
          temp = "0.0" + temp100.substring(1, 1);
        } else if (nianList[i]['金额100'] > -100 && nianList[i]['金额100'] <= -10) {
          temp = temp100.substring(0, 1) + "0." + temp100.substring(1, 3);
        } else if (nianList[i]['金额100'] >= 10 && nianList[i]['金额100'] < 100) {
          temp = "0." + temp100.substring(0, 2);
        } else {
          temp = temp100.substring(0, temp100.length - 2) +
              "." +
              temp100.substring(temp100.length - 2, temp100.length);
        }
        nianList[i]['金额'] = temp;
        for (Map s in detailList) nianList[i]['明细'].add(s);
      }
    } else {
      for (var i = 0; i < billsList.length; i++) {
        if (billsList[i].accountIn == tempaccountName ||
            billsList[i].accountOut == tempaccountName) {
          if (lastTime.isAfter(billsList[i].date)) {
            lastTime = billsList[i].date;
          }
          if (firstTime.isBefore(billsList[i].date)) {
            firstTime = billsList[i].date;
          }
        }
      }
      final yeardifference = firstTime.year - lastTime.year;
      int yeartemp = lastTime.year - 1;
      for (var i = 0; i < yeardifference + 1; i++) {
        detailList.clear();
        yeartemp++;
        nianList
            .add({'日期': yeartemp, '金额100': 0, '金额': '0', '明细': [], '存在': 0});
        for (var j = 0; j < billsList.length; j++) {
          if (billsList[j].date.year == yeartemp) {
            if (billsList[j].type == 0) {
              if (billsList[j].accountIn == tempaccountName) {
                nianList[i]['金额100'] += billsList[j].value100;
                String detailtemp;
                String detailtemp100 = billsList[j].value100.toString();
                if (billsList[j].value100 == 0) {
                  detailtemp = '0.00';
                } else if (billsList[j].value100 > 0 &&
                    billsList[j].value100 < 10) {
                  detailtemp = "0.0" + detailtemp100.substring(1, 1);
                } else if (billsList[j].value100 >= 10 &&
                    billsList[j].value100 < 100) {
                  detailtemp = "0." + detailtemp100.substring(0, 2);
                } else {
                  detailtemp =
                      detailtemp100.substring(0, detailtemp100.length - 2) +
                          "." +
                          detailtemp100.substring(
                              detailtemp100.length - 2, detailtemp100.length);
                }
                String tempcardName2 = billsList[j].accountIn;
                nianList[i]['存在'] = 1;
                detailList.add({
                  'id': billsList[j].id,
                  'date': billsList[j].date,
                  'type': tempcardName2,
                  'title': billsList[j].title,
                  'category1': billsList[j].category1,
                  'category2': billsList[j].category2,
                  'member': billsList[j].member,
                  '金额100': billsList[j].value100,
                  '金额': detailtemp,
                });
              }
            } else if (billsList[j].type == 1) {
              if (billsList[j].accountOut == tempaccountName) {
                nianList[i]['金额100'] -= billsList[j].value100;
                String detailtemp;
                String detailtemp100 = billsList[j].value100.toString();
                if (billsList[j].value100 == 0) {
                  detailtemp = '0.00';
                } else if (billsList[j].value100 > 0 &&
                    billsList[j].value100 < 10) {
                  detailtemp = "0.0" + detailtemp100.substring(1, 1);
                } else if (billsList[j].value100 >= 10 &&
                    billsList[j].value100 < 100) {
                  detailtemp = "0." + detailtemp100.substring(0, 2);
                } else {
                  detailtemp ='-'+
                      detailtemp100.substring(0, detailtemp100.length - 2) +
                          "." +
                          detailtemp100.substring(
                              detailtemp100.length - 2, detailtemp100.length);
                }
                String tempcardName1 = billsList[j].accountOut;
                nianList[i]['存在'] = 1;
                detailList.add({
                  'id': billsList[j].id,
                  'date': billsList[j].date,
                  'type': tempcardName1,
                  'title': billsList[j].title,
                  'category1': billsList[j].category1,
                  'category2': billsList[j].category2,
                  'member': billsList[j].member,
                  '金额100': billsList[j].value100,
                  '金额': detailtemp,
                });
              }
            } else if (billsList[j].type == 2) {
              if (billsList[j].accountOut == tempaccountName) {
                nianList[i]['金额100'] -= billsList[j].value100;
                String detailtemp;
                String detailtemp100 = billsList[j].value100.toString();
                if (billsList[j].value100 == 0) {
                  detailtemp = '0.00';
                } else if (billsList[j].value100 > 0 &&
                    billsList[j].value100 < 10) {
                  detailtemp = "0.0" + detailtemp100.substring(1, 1);
                } else if (billsList[j].value100 >= 10 &&
                    billsList[j].value100 < 100) {
                  detailtemp = "0." + detailtemp100.substring(0, 2);
                } else {
                  detailtemp = '-' +
                      detailtemp100.substring(0, detailtemp100.length - 2) +
                      "." +
                      detailtemp100.substring(
                          detailtemp100.length - 2, detailtemp100.length);
                }
                String tempcardName1 = billsList[j].accountOut;
                String tempcardName2 = billsList[j].accountIn;
                nianList[i]['存在'] = 1;
                detailList.add({
                  'id': billsList[j].id,
                  'date': billsList[j].date,
                  'type': tempcardName1 + '转账到' + tempcardName2,
                  'title': billsList[j].title,
                  'category1': billsList[j].category1,
                  'category2': billsList[j].category2,
                  'member': billsList[j].member,
                  '金额100': billsList[j].value100,
                  '金额': detailtemp,
                });
              }
              if (billsList[j].accountIn == tempaccountName) {
                nianList[i]['金额100'] += billsList[j].value100;
                String detailtemp;
                String detailtemp100 = billsList[j].value100.toString();
                if (billsList[j].value100 == 0) {
                  detailtemp = '0.00';
                } else if (billsList[j].value100 > 0 &&
                    billsList[j].value100 < 10) {
                  detailtemp = "0.0" + detailtemp100.substring(1, 1);
                } else if (billsList[j].value100 >= 10 &&
                    billsList[j].value100 < 100) {
                  detailtemp = "0." + detailtemp100.substring(0, 2);
                } else {
                  detailtemp =
                      detailtemp100.substring(0, detailtemp100.length - 2) +
                      "." +
                      detailtemp100.substring(
                          detailtemp100.length - 2, detailtemp100.length);
                }
                String tempcardName1 = billsList[j].accountOut;
                String tempcardName2 = billsList[j].accountIn;
                nianList[i]['存在'] = 1;
                detailList.add({
                  'id': billsList[j].id,
                  'date': billsList[j].date,
                  'type': tempcardName1 + '转账到' + tempcardName2,
                  'title': billsList[j].title,
                  'category1': billsList[j].category1,
                  'category2': billsList[j].category2,
                  'member': billsList[j].member,
                  '金额100': billsList[j].value100,
                  '金额': detailtemp,
                });
              }
            }
          }
        }
        String temp;
        String temp100 = nianList[i]['金额100'].toString();
        if (nianList[i]['金额100'] == 0) {
          temp = '0.00';
        } else if (nianList[i]['金额100'] > -10 && nianList[i]['金额100'] < 0) {
          temp = temp100.substring(0, 1) + "0.0" + temp100.substring(1, 2);
        } else if (nianList[i]['金额100'] > 0 && nianList[i]['金额100'] < 10) {
          temp = "0.0" + temp100.substring(1, 1);
        } else if (nianList[i]['金额100'] > -100 && nianList[i]['金额100'] <= -10) {
          temp = temp100.substring(0, 1) + "0." + temp100.substring(1, 3);
        } else if (nianList[i]['金额100'] >= 10 && nianList[i]['金额100'] < 100) {
          temp = "0." + temp100.substring(0, 2);
        } else {
          temp = temp100.substring(0, temp100.length - 2) +
              "." +
              temp100.substring(temp100.length - 2, temp100.length);
        }
        nianList[i]['金额'] = temp;
        for (Map s in detailList) nianList[i]['明细'].add(s);
      }
    }
    return nianList;
  }

  // final List lzData = <Widget>[
  //   Text(
  //     '流水明细',
  //   ),
  // ];

  setDataFromDB(int id) async {
    // 得到数据
    await BillsDatabaseService.db.deleteBillIdInDB(id);
  }

  Future<BillsModel> getDataFromDB(int id) async {
    BillsModel bill = await BillsDatabaseService.db.getBillById(id);
    return bill;
  }

  int flag=0;
  List<Widget> _yearListData() {
    var tempList = yearList1.map((value) {
      return Card(
        elevation: 2.0, //设置阴影
        margin: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))), //设置圆角
        child: new Column(
          // card只能有一个widget，但这个widget内容可以包含其他的widget
          children: [
            Container(
              //height: 70,
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: ExpansionTile(
                backgroundColor: Colors.transparent,
                title: new Text(
                  value['日期'].toString() +
                      '年\n' +
                      accountName[accountNumber] +
                      ' ' +
                      maxString(value['金额']),
                  style: new TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 19,
                  ),
                ),
                trailing: RotationTransition(
                  turns: animation,
                  child: Icon(Icons.arrow_drop_up),
                ),
                onExpansionChanged: (expand) {
                  _changeTrailing(expand);
                },
                initiallyExpanded: false,
                children: <Widget>[
                  Container(
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: value['明细'].length,
                      itemBuilder: (context, index) {
                        return new Container(
                            height: 72,
                            child: Card(
                                margin: EdgeInsets.all(1.0),
                                elevation: 2.0,
                                color: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7.0))),
                                child: Slidable(
                                  actionPane:
                                      SlidableStrechActionPane(), //滑出选项的面板 动画
                                  actionExtentRatio: 0.25,
                                  child: Stack(children: <Widget>[
                                    Align(
                                      alignment: Alignment(0.9, 0.0),
                                      child: Text(
                                          value['明细'][index]['金额'] + '元',
                                          style: TextStyle(
                                              color: Colors.blueGrey)),
                                    ),
                                    ListTile(
                                      leading: new Icon(
                                        Icons.category,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title: new Text(
                                          value['明细'][index]['category2'] + ':',
                                          style: TextStyle(
                                              color: Colors.blueGrey)),
                                      subtitle: new Text(value['明细'][index]
                                                  ['date']
                                              .month
                                              .toString() +
                                          '月' +
                                          value['明细'][index]['date']
                                              .day
                                              .toString() +
                                          '日 ' +
                                          value['明细'][index]['date']
                                              .hour
                                              .toString() +
                                          '时' +
                                          value['明细'][index]['date']
                                              .minute
                                              .toString() +
                                          '分'+ '\n' +
                                          value['明细'][index]['type'] +
                                          '  ' +
                                          value['明细'][index]['member'],style: TextStyle(fontSize: 12.0)),
                                      onTap: () {


                                        },
                                    ),
                                  ]),
                                  secondaryActions: <Widget>[
                                    //右侧按钮列表
                                    IconSlideAction(
                                      caption: '详情',
                                      color: Colors.black45,
                                      icon: Icons.more_horiz,
                                      onTap: () async {
                                        BillsModel bill = await getDataFromDB(value['明细'][index]['id']);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('流水详情'),
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
                                                                          Colors.black.withOpacity(0.7),
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
                                                                              Colors.black.withOpacity(0.7),
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
                                                                          Colors.black.withOpacity(0.7),
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
                                                                              Colors.black.withOpacity(0.7),
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
                                                                            Colors.black.withOpacity(0.7),
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
                                                                          Colors.black.withOpacity(0.7),
                                                                        ),
                                                                      ),

                                                                  ),
                                                                ],
                                                              ),
                                                            ),
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
                                                                        Colors.black.withOpacity(0.7),
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
                                                                        Colors.black.withOpacity(0.7),
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
                                                                            Colors.black.withOpacity(0.4),
                                                                          ),
                                                                        ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              );
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
                                        print('click');
                                        setState(() {
                                          Toast.show(
                                              '${value['明细'][index]['type']}' +
                                                  '  已删除',
                                              context);
                                          setDataFromDB(
                                              value['明细'][index]['id']);
                                          (value['明细']).removeAt(
                                              index); //删除某条信息!!!!!!!!!
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TimePage(
                                                        index: 0,)));
                                        });
                                      },
                                    ),
                                  ],
                                )));
                      },
                    ),
                  )
                  /*Container(
                    height: 20,
                    color: Colors.transparent,
                  ),*/
                ],
              ),
            ),
          ],
        ),
      );
    });
    return tempList.toList();
  }

  String value100ConvertToText (int value100) {
    String ans = (value100 > 99)?
    value100.toString().substring(0, value100.toString().length-2)
        + '.'
        + value100.toString().substring(value100.toString().length-2, value100.toString().length):
    (value100 > 9) ? '0.' + value100.toString() :'0.0' + value100.toString();
    return ans;
  }



  maxString(String money){
    if(money==null){
      return money+'元';
    }
    //+-99999999.99
    if(money.length>12){
      if(money.substring(0,1)=='-'){
        return '挥金如土';
      }else{
        return '腰缠万贯';
      }
    }else if(0<money.length && money.length<=12){
      return money+'元';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (flag == 0 || accountNumber > accountName.length - 1) {
      return Center(child: Container() //CircularProgressIndicator(),
          );
    } else if (flag == 1) {
      return Container(
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment(-1, -1),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: ListView(
                  children: this._yearListData(),
                ),
              )),
        ]),
      );
    }
  }



}

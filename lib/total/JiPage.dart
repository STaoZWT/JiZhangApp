// flutter_speed_dial: ^1.2.4
//flutter_slidable: ^0.5.4
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../total/TotalPage.dart';
import '../data/model.dart';
import '../service/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'TimePage.dart';

int accountNumber;
int flag = 0;

class JiPage extends StatefulWidget {
  JiPage({Key key}) : super(key: key);

  @override
  _JiPageState createState() => _JiPageState();
}

class _JiPageState extends State<JiPage> {
  @override
  Widget build(BuildContext context) {
    return JiPageContent();
  }
}

class JiPageContent extends StatefulWidget {
  JiPageContent({Key key}) : super(key: key);

  @override
  _JiPageContentState createState() => _JiPageContentState();
}

class _JiPageContentState extends State<JiPageContent>
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
  List jiList = [
    {'日期': DateTime.now(), '金额100': 0, '金额': '0', '明细': []}
  ];
  List jiList1 = [
    {'日期': DateTime.now(), '金额100': 0, '金额': '0', '明细': []}
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
      ///////////////////////////////////////////确定账户个数
      ///////////////////////////////////////////账户1，账户2......
      flag = 1;
      return accountName.length;
    }
    flag = 0;
    return 0;
  }

  List inittotalList() {
    totalList.clear();
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

    jiList = initjiList();
    jiList1.clear();
    for (var i = 0; i < jiList.length; i++) {
      if (jiList[i]['存在'] == 1) {
        jiList1.add(jiList[i]);
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
    accountNumber = acountChange();
    initall();
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    animation = new Tween(begin: 0.0, end: 0.5).animate(animationController);
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

  setDataFromDB(int id) async {
    // 得到数据
    await BillsDatabaseService.db.deleteBillIdInDB(id);
  }

  List initjiList() {
    DateTime lastTime = DateTime.now();
    DateTime firstTime = empty(billsList) ? DateTime.now() : billsList[0].date;

    List duList = [
      {
        'id': 0,
        '日期': DateTime(2020, 09, 18, 20, 23, 45),
        '金额100': 0,
        '金额': '0',
        '明细': [],
        '存在': 0
      }
    ];
    int decide(int month) {
      int month0;
      if (month >= 1 && month <= 3) {
        month0 = 1;
      } else if (month >= 4 && month <= 6) {
        month0 = 2;
      } else if (month >= 7 && month <= 9) {
        month0 = 3;
      } else if (month >= 10 && month <= 12) {
        month0 = 4;
      }
      return month0;
    }

    int next(int jidu0) {
      int jidu4;
      if (jidu0 == 1) {
        jidu4 = 2;
      } else if (jidu0 == 2) {
        jidu4 = 3;
      } else if (jidu0 == 3) {
        jidu4 = 4;
      } else if (jidu0 == 4) {
        jidu4 = 1;
      }
      return jidu4;
    }

    List start = [0, 1, 4, 7, 10];
    List end = [0, 3, 6, 9, 12];
    //重建
    duList.clear();
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
      int loopTime(DateTime last, DateTime first) {
        int jidu1 = decide(last.month);
        int jidu2 = decide(first.month);
        int time = -jidu1 + jidu2 + 4 * (yeardifference) + 1;
        return time;
      }

      int yeartemp = lastTime.year;
      int times = loopTime(lastTime, firstTime);

      int jidu = decide(lastTime.month);
      int lastjidu = jidu;
      for (var i = 0; i < times; i++) {
        detailList.clear();

        duList.add({
          'id': 0,
          '年份': yeartemp,
          '季度': jidu,
          '金额100': 0,
          '金额': '0',
          '明细': [],
          '存在': 0
        });
        lastjidu = jidu;
        jidu = next(jidu);

        for (var j = 0; j < billsList.length; j++) {
          if (billsList[j].date.year == yeartemp &&
              billsList[j].date.month >= start[lastjidu] &&
              billsList[j].date.month <= end[lastjidu]) {
            if (billsList[j].type == 0) {
              duList[i]['金额100'] += billsList[j].value100;
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
              duList[i]['存在'] = 1;
              detailList.add({
                'id': billsList[j].id,
                'type': tempcardName2 ,
                'date': billsList[j].date,
                'title': billsList[j].title,
                'category1': billsList[j].category1,
                'category2': billsList[j].category2,
                'member': billsList[j].member,
                '金额100': billsList[j].value100,
                '金额': detailtemp,
              });
            } else if (billsList[j].type == 1) {
              duList[i]['金额100'] -= billsList[j].value100;
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
              duList[i]['存在'] = 1;
              detailList.add({
                'id': billsList[j].id,
                'type': tempcardName1 ,
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
              duList[i]['存在'] = 1;
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
        if (jidu == 1) {
          yeartemp++;
        }
        String temp;
        String temp100 = duList[i]['金额100'].toString();
        if (duList[i]['金额100'] == 0) {
          temp = '0.00';
        } else if (duList[i]['金额100'] > -10 && duList[i]['金额100'] < 0) {
          temp = temp100.substring(0, 1) + "0.0" + temp100.substring(1, 2);
        } else if (duList[i]['金额100'] > 0 && duList[i]['金额100'] < 10) {
          temp = "0.0" + temp100.substring(1, 1);
        } else if (duList[i]['金额100'] > -100 && duList[i]['金额100'] <= -10) {
          temp = temp100.substring(0, 1) + "0." + temp100.substring(1, 3);
        } else if (duList[i]['金额100'] >= 10 && duList[i]['金额100'] < 100) {
          temp = "0." + temp100.substring(0, 2);
        } else {
          temp = temp100.substring(0, temp100.length - 2) +
              "." +
              temp100.substring(temp100.length - 2, temp100.length);
        }
        duList[i]['金额'] = temp;
        for (Map s in detailList) duList[i]['明细'].add(s);
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
      int loopTime(DateTime last, DateTime first) {
        int jidu1 = decide(last.month);
        int jidu2 = decide(first.month);
        int time = -jidu1 + jidu2 + 4 * (yeardifference) + 1;
        return time;
      }

      int yeartemp = lastTime.year;
      int times = loopTime(lastTime, firstTime);

      int jidu = decide(lastTime.month);
      int lastjidu = jidu;
      for (var i = 0; i < times; i++) {
        detailList.clear();
        duList.add({
          'id': 0,
          '年份': yeartemp,
          '季度': jidu,
          '金额100': 0,
          '金额': '0',
          '明细': [],
          '存在': 0
        });
        lastjidu = jidu;
        jidu = next(jidu);
        for (var j = 0; j < billsList.length; j++) {
          if (billsList[j].date.year == yeartemp &&
              billsList[j].date.month >= start[lastjidu] &&
              billsList[j].date.month <= end[lastjidu]) {
            if (billsList[j].type == 0) {
              if (billsList[j].accountIn == tempaccountName) {
                duList[i]['金额100'] += billsList[j].value100;
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

                duList[i]['存在'] = 1;
                detailList.add({
                  'id': billsList[j].id,
                  'type': tempcardName2 ,
                  'date': billsList[j].date,
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
                duList[i]['金额100'] -= billsList[j].value100;
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
                duList[i]['存在'] = 1;
                detailList.add({
                  'id': billsList[j].id,
                  'type': tempcardName1 ,
                  'title': billsList[j].title,
                  'category1': billsList[j].category1,
                  'date': billsList[j].date,
                  'category2': billsList[j].category2,
                  'member': billsList[j].member,
                  '金额100': billsList[j].value100,
                  '金额': detailtemp,
                });
              }
            } else if (billsList[j].type == 2) {
              if (billsList[j].accountIn == tempaccountName) {
                duList[i]['金额100'] += billsList[j].value100;
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
                duList[i]['存在'] = 1;
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
              if (billsList[j].accountOut == tempaccountName) {
                duList[i]['金额100'] -= billsList[j].value100;
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
                duList[i]['存在'] = 1;
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
        }
        if (jidu == 1) {
          yeartemp++;
        }
        String temp;
        String temp100 = duList[i]['金额100'].toString();
        if (duList[i]['金额100'] == 0) {
          temp = '0.00';
        } else if (duList[i]['金额100'] > -10 && duList[i]['金额100'] < 0) {
          temp = temp100.substring(0, 1) + "0.0" + temp100.substring(1, 2);
        } else if (duList[i]['金额100'] > 0 && duList[i]['金额100'] < 10) {
          temp = "0.0" + temp100.substring(1, 1);
        } else if (duList[i]['金额100'] > -100 && duList[i]['金额100'] <= -10) {
          temp = temp100.substring(0, 1) + "0." + temp100.substring(1, 3);
        } else if (duList[i]['金额100'] >= 10 && duList[i]['金额100'] < 100) {
          temp = "0." + temp100.substring(0, 2);
        } else {
          temp = temp100.substring(0, temp100.length - 2) +
              "." +
              temp100.substring(temp100.length - 2, temp100.length);
        }
        duList[i]['金额'] = temp;
        for (Map s in detailList) duList[i]['明细'].add(s);
      }
    }
    return duList;
  }

  // final List lzData = <Widget>[
  //   Text(
  //     '流水明细',
  //   ),
  // ];

  List<Widget> _jiListData() {
    var tempList = jiList1.map((value) {
      return Card(
        elevation: 2.0, //设置阴影
        margin: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))), //设置圆角
        child: new Column(
            // card只能有一个widget，但这个widget内容可以包含其他的widget
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: ExpansionTile(
                    backgroundColor: Colors.transparent,
                    title: new Text(
                      value['年份'].toString() +
                          '年 ' +
                          '第' +
                          value['季度'].toString() +
                          '季度\n' +
                          accountName[accountNumber] +
                          '   ' +
                          value['金额'] +
                          '元',
                      style: new TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                      ),
                    ),
                    trailing: RotationTransition(
                      turns: animation,
                      child: Icon(Icons.arrow_drop_down),
                      //child: Image.asset('assets/images/收起.png'),
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
                                height: 65,
                                child: Card(
                                    margin: EdgeInsets.all(5.0),
                                    elevation: 2.0,
                                    color: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0))),
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
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title: new Text(
                                              value['明细'][index]['category2'] +
                                                  ':',
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
                                              '分'
                                                  // '  ' +
                                                  // value['明细'][index]['title'] +
                                                  '\n' +
                                              value['明细'][index]['type'] +
                                              '  ' +
                                              value['明细'][index]['member'],style: TextStyle(fontSize: 12.0)),
                                          onTap: () => print("$index被点击了"),
                                          onLongPress: () =>
                                              print("$index被长按了"),
                                        ),
                                      ]),
                                      secondaryActions: <Widget>[
                                        //右侧按钮列表
                                        IconSlideAction(
                                          caption: '编辑',
                                          color: Colors.black45,
                                          icon: Icons.more_horiz,
                                          //onTap: () => _showSnackBar('More'),
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
                                                            index: 1,
                                                          )));
                                            });
                                          },
                                        ),
                                      ],
                                    )));
                          },
                        ),
                      ),
                    ]),
              ),
            ]),
      );
    });
    return tempList.toList();
  }

  _showSnackBar(String s) {
    if (s == 'Delete') {
      showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('提示？'),
              content: Text('确定删除该条记录？'),
              actions: <Widget>[
                FlatButton(
                  child: Text('取消'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                FlatButton(
                  child: Text('确定'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          });
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
                height: 800,
                width: 600,
                color: Colors.white,
                child: ListView(
                  children: this._jiListData(),
                ),
              )),
        ]),
      );
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/model.dart';
import '../homepage.dart';
import '../total/cardInkwell.dart';
import 'TimePage.dart';
import '../service/database.dart';
import '../service/shared_pref.dart';
import 'dart:convert';

int index_current;
int accountNumber1;
List addList;
List addList0;
int acountChange() {
  accountNumber1 = index_current;
  return accountNumber1;
}

class TotalPage extends StatefulWidget {
  TotalPage({Key key}) : super(key: key);

  @override
  _TotalPageState createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).primaryColor, size: 28),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text('分账户统计',
            style: TextStyle(
                fontSize: 23.0, color: Theme.of(context).primaryColor)),
      ),
      body: TotalPageContent(),
    );
  }
}

class TotalPageContent extends StatefulWidget {
  TotalPageContent({Key key}) : super(key: key);

  @override
  _TotalPageContentState createState() => _TotalPageContentState();
}

class _TotalPageContentState extends State<TotalPageContent> {
  int maxAc;
  List totalList = [
    {'账户': '净资产', '金额100': 0, '金额': '0'}
  ];

  List<BillsModel> billsList;
////////////////////////////////////////////////////////////////////////////////数据库billsList
  setBillsFromDB() async {
    print("Entered setBills");
    var fetchedBills = await BillsDatabaseService.db.getBillsFromDB();
    setState(() {
      billsList = fetchedBills;
    });
  }

////////////////////////////////////////////////////////////////////////////////像数据库添加值
  addBill() async {
    BillsModel billsModel = BillsModel.random();
    await BillsDatabaseService.db.addBillInDB(billsModel);
  }

  ///////////////////////////////////////////////////////////////////////////////确定账户个数，构造accountName[]
  List accountName = ['现金'];
  int maxAcCount() {
    accountName.clear();
    for (var i = 0; i < billsList.length; i++) {
      accountName.add(billsList[i].accountIn);
      accountName.add(billsList[i].accountOut);
    }
    var s = new Set();
    s.addAll(accountName);
    accountName = s.toList();
    for (var i = 0; i < accountName.length; i++) {
      if (accountName[i] == '未选择') {
        accountName.remove('未选择');
      }
    }
    accountName.add('净资产');
    ///////////////////////////////////////////确定账户个数
    ///////////////////////////////////////////账户1，账户2......
    return accountName.length;
  }

////////////////////////////////////////////////////////////////////////////////定义totalList
  List inittotalList() {
    //print("开始执行");
    ///////////////////////////////////////////定义totalList
    ///////////////////////////////////////////totalList[last]存净资产
    totalList.clear();
    //totalList.add({'账户': '净资产', '金额100': 0, '金额': '0'});
    for (var i = 0; i < maxAc; i++) {
      String tempaccountName = accountName[i];
      totalList.add({'账户': tempaccountName, '金额100': 0, '金额': '0'});
      ///////////////////////////////////////////////////////////////////////
      //print("totallist $i $totalList");
    }
    return totalList;
  }

////////////////////////////////////////////////////////////////////////////////计算totalList
  List countT() {
//清零
    for (var j = 0; j < maxAc; j++) {
      totalList[j]['金额100'] = 0;
      totalList[j]['金额'] = '0';
    }
//计算
    for (var i = 0; i < billsList.length; i++) {
      if (billsList[i].type == 0) {
        for (var j = 0; j < maxAc - 1; j++) {
          if (billsList[i].accountOut == totalList[j]['账户']) {
            totalList[j]['金额100'] += billsList[i].value100;
            totalList[maxAc - 1]['金额100'] += billsList[i].value100;
          }
        }
      } else if (billsList[i].type == 1) {
        for (var j = 0; j < maxAc - 1; j++) {
          if (billsList[i].accountOut == totalList[j]['账户']) {
            totalList[j]['金额100'] -= billsList[i].value100;
            totalList[maxAc - 1]['金额100'] -= billsList[i].value100;
          }
        }
      } else if (billsList[i].type == 2) {
        for (var j = 0; j < maxAc - 1; j++) {
          if (billsList[i].accountOut == totalList[j]['账户']) {
            totalList[j]['金额100'] -= billsList[i].value100;
            totalList[maxAc - 1]['金额100'] -= billsList[i].value100;
          }
          if (billsList[i].accountIn == totalList[j]['账户']) {
            totalList[j]['金额100'] += billsList[i].value100;
            totalList[maxAc - 1]['金额100'] += billsList[i].value100;
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
    String addString = await getPicker("maccountPicker");
    addList = JsonDecoder().convert(addString);
    //print(addList);
    billsList.sort((a, b) => (b.date).compareTo(a.date));
    maxAc = maxAcCount();
    print(maxAc);
    totalList = inittotalList();
    totalList = countT();
    addList0 = getDiffrent1(addList, accountName);
    print(addList0);
    if (addList0 != null) {
      for (var i = 0; i < addList0.length; i++) {
        totalList.add({'账户': addList0[i], '金额100': 0, '金额': '0.00'});
      }
    }
  }

  List getDiffrent1(List list1, List list2) {
    // diff 存放不同的元素
    List diff = new List();
    list1.forEach((element) {
      if (!list2.contains(element.toString())) {
        diff.add(element.toString());
      }
    });
    //print(diff);
    return diff;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initall();

  }
//
////////////////////////////////////////////////////////////////////////////////配置Card
  List<Widget> _totalListData() {
    // print('///////////////////////////////////////////////////////');
    // print(totalList);
    var tempList = totalList.map((value) {
      return Card(
        elevation: 2.0, //设置阴影
        margin: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))), //设置圆角
        child: new Column(
          // card只能有一个widget，但这个widget内容可以包含其他的widget
          children: [
            SizedBox(
              height: 70,
              child: MaterialTapWidget(
                onTap: () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TimePage(index: 0)));
                    index_current = accountName.length - 1;
                    for (var i = 0; i < accountName.length - 1; i++) {
                      if (accountName[i] == value['账户']) {
                        index_current = i;
                      }
                    }
                  });
                },
                child: Stack(children: <Widget>[
                  Align(
                    //alignment: Alignment(-0.7, -0.6),
                    alignment: Alignment(-0.7, 0.0),
                    child: Text('  ' + value['账户'],
                        style: TextStyle(fontSize: 23, color: Colors.blueGrey)),
                  ),
                  Align(
                    alignment: Alignment(0.6, 0),
                    child: Text(value['金额'] + '元',
                        style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).primaryColor)),
                  ),
                  /*Align(
                    alignment: Alignment(-0.7, 0.6),
                    child: Text('统计', style: TextStyle(fontSize: 18)),
                  ),*/
                  Align(
                    alignment: Alignment(-0.95, 0),
                    child: Icon(Icons.account_balance_wallet,
                        color: Theme.of(context).primaryColor, size: 22),
                  ),
                  Align(
                    alignment: Alignment(0.9, 0),
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.grey[300], size: 25),
                  ),
                ]),
              ),
            )
          ],
        ),
      );
    });
    return tempList.toList();
  }

// Widget _buildCard(Card name) {
//     return SizedBox(
//       height: 200.0,
//       key: ObjectKey(name),
//       child: Card(
//         color: Colors.red.withOpacity(0.5),
//         child: Center(
//           child: Text(
//             '$name',
//             style: TextStyle(
//               fontSize: 35.0,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      width: 600,
      color: Colors.white,
      child: ListView(
        //ReorderableListView(
        children: this._totalListData(),
        //children: totalList.map(_buildCard).toList(),
        //onReorder: _onReorder,
      ),
    );
  }
  //

  // void _onReorder(int oldIndex, newIndex) {
  //   if (oldIndex < newIndex) newIndex = newIndex - 1;
  //   var name = totalList.removeAt(oldIndex);
  //   totalList.insert(newIndex, name);
  //   setState(() {});
  // }
}

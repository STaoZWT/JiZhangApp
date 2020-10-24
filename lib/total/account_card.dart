import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../service/database.dart';
import '../service/shared_pref.dart';
import '../const/common_color.dart';

class AccountCardPage extends StatefulWidget {
  AccountCardPage({Key key, this.title}): super(key: key);

  final String title;

  @override
  _AccountCardPageState createState() => new _AccountCardPageState();
}

class _AccountCardPageState extends State<AccountCardPage> {

  List accountList;
  List accountBalance;
  int accountIndex;

  bool flag;


  @override
  void initState() {
    super.initState();
    flag = false;
    initAccountData();
  }

  String toInsert(int value100) {
    if (value100 < 0) {
      value100 = -value100;
    }
    return (value100 == null) ? '0.00' :
    (value100 > 99)?
    value100.toString().substring(0, value100.toString().length-2)
        + '.'
        + value100.toString().substring(value100.toString().length-2, value100.toString().length):
    (value100 > 9) ? '0.' + value100.toString() :'0.0' + value100.toString();
  }

  initAccountData() async {
    accountList = JsonDecoder().convert(await getPicker('maccountPicker'));
    print(accountList);
    accountIndex = accountList.length;
    print(accountIndex);
    accountBalance = [];
    for (int i = 0; i < accountList.length; i++) {
      int netAsset = await BillsDatabaseService.db.getAccountNetAsset(accountList[i]);
      accountBalance.add((netAsset < 0 ? '-' : '') + toInsert(netAsset));
      print(accountBalance);
    }
    flag = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(flag == false) {
      return CircularProgressIndicator();
    }
    else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle:true,
          title: Text(
            "账户卡片",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
                height: 24
            ),
            Swiper(
                layout: SwiperLayout.STACK,
                //indicatorLayout: ,
                itemWidth: (MediaQuery.of(context).size.width)*0.96,
                itemHeight: (MediaQuery.of(context).size.width)*0.96*0.618,
                pagination: SwiperPagination(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.all(20),
                    builder: FractionPaginationBuilder(
                        color: Colors.white,
                        activeColor: Colors.white
                    )
                ),
                itemBuilder: (context, index) {
                  return Card(
                    borderOnForeground: true,
                    elevation: 2.0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    color: themeColorList[index % 14].withOpacity(0.98),
                    child: new Container(
                      margin: EdgeInsets.all(16),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '''${accountList[index]}\n\n\n\n\n\n''',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.8,
                              ),
                            ),
                            TextSpan(
                              text: '''余额\n''',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(
                              text: '''￥${accountBalance[index]}''',
                              style: TextStyle(
                                fontSize: 40,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                  );
                },
                itemCount: accountIndex),
          ],
        ),
      );
    }
  }

}
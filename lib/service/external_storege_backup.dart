import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'database.dart';
import 'package:toast/toast.dart';
import '../data/model.dart';
import '../service/shared_pref.dart';

class BackupToFile extends StatefulWidget {
  @override
  _BackupToFileState
  createState() => new _BackupToFileState();

}

class _BackupToFileState extends State<BackupToFile> {

  String testString;
  String inputString;
  bool isInit;

  String currentClass;
  String currentAccount;
  String currentMember;

  String backupClass;
  String backupAccount;
  String backupMember;

  String currentBillsString;
  String backupBillsString;

  @override
  void initState() {
    super.initState();

  }

  void writeToFile() async {
    final fileDirectory = await getApplicationDocumentsDirectory();
    final filePath = fileDirectory.path;
    //Directory documentsDir = await getExternalStorageDirectory();
    //String documentsPath = documentsDir.path;
    //print(documentsPath);
    File maccountPickerFile = new File('$filePath/maccountPicker');
    File mOutClassPickerFile = new File('$filePath/mOutClassPicker');
    File mInClassPickerFile = new File('$filePath/mInClassPicker');
    File mmemberPickerFile = new File('$filePath/mmemberPicker');
    File billsFile = new File('$filePath/bills');
    if (!billsFile.existsSync()) {
      billsFile.createSync();
    }
    //读数据库
    List<BillsModel> billsModel = await BillsDatabaseService.db.getBillsFromDB();
    billsFile.writeAsStringSync("begin");
    for (BillsModel onebillsModel in billsModel){
      String onebills = JsonEncoder().convert(onebillsModel.toMap());
      print("onebills is $onebills");
      billsFile.writeAsStringSync(onebills,mode: FileMode.append);
    }
    billsFile.writeAsStringSync("end",mode: FileMode.append);
    //读sp
    getPicker("maccountPicker").then((String maccountPicker){
      maccountPickerFile.writeAsString(maccountPicker);
    });
    getPicker("mOutClassPicker").then((String mOutClassPicker){
      mOutClassPickerFile.writeAsString(mOutClassPicker);
    });
    getPicker("mInClassPicker").then((String mInClassPicker){
      mInClassPickerFile.writeAsString(mInClassPicker);
    });
    getPicker("mmemberPicker").then((String mmemberPicker){
      mmemberPickerFile.writeAsString(mmemberPicker);
    });

    // String maccountPicker = await getPicker("maccountPicker");
    // String mOutClassPicker = await getPicker("mOutClassPicker");
    // String mInClassPicker = await getPicker("mInClassPicker");
    // String mmemberPicker = await getPicker("mmemberPicker");
    // maccountPickerFile.writeAsString(maccountPicker);
    // mOutClassPickerFile.writeAsString(mOutClassPicker);
    // mInClassPickerFile.writeAsString(mInClassPicker);
    // mmemberPickerFile.writeAsString(mmemberPicker);
    if (billsFile.existsSync()) {
      Toast.show("成功备份到$filePath/bills", context);
    }
  }

  void getNotesFromCache() async {
    final fileDirectory = await getApplicationDocumentsDirectory();
    final filePath = fileDirectory.path;
    // Directory documentsDir = await getExternalStorageDirectory();
    // String documentsPath = documentsDir.path;
    File maccountPickerFile = new File('$filePath/maccountPicker');
    File mOutClassPickerFile = new File('$filePath/mOutClassPicker');
    File mInClassPickerFile = new File('$filePath/mInClassPicker');
    File mmemberPickerFile = new File('$filePath/mmemberPicker');
    File billsFile = new File("$filePath/bills");

    if (!billsFile.existsSync()) {
      return;
    }
    //取数据库
    maccountPickerFile.readAsString().then((String maccountPicker) {
      setPicker("maccountPicker", maccountPicker);
    });
    mOutClassPickerFile.readAsString().then((String mOutClassPicker) {
      setPicker("mOutClassPicker", mOutClassPicker);
    });
    mInClassPickerFile.readAsString().then((String mInClassPicker) {
      setPicker("mInClassPicker", mInClassPicker);
    });
    mmemberPickerFile.readAsString().then((String mmemberPicker) {
      setPicker("mmemberPicker", mmemberPicker);
    });
    String bills = await billsFile.readAsString();
    BillsDatabaseService.db.deleteBillAllInDB();
    int beginIndex = -1;
    int endIndex = -1;
    while(bills.indexOf("{",beginIndex+1)!=-1){
      beginIndex = bills.indexOf("{",beginIndex+1);
      endIndex = bills.indexOf("}",endIndex+1);
      String onebillsget = bills.substring(beginIndex,endIndex+1);
      print("get string : $onebillsget");
      BillsModel onebillsmodel = BillsModel.fromMap(JsonDecoder().convert(onebillsget));
      BillsDatabaseService.db.addBillInDB(onebillsmodel);
    }
    print("bills is :$bills");

    // for(String onebillsget in ){
    //   BillsModel onebillsmodel = BillsModel.fromMap(JsonDecoder().convert(onebillsget));
    //   BillsDatabaseService.db.addBillInDB(onebillsmodel);
    // }
    print('the bills get');
    print(bills);
    setState(() {
      Toast.show("成功还原上次备份", context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "数据备份和还原",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        centerTitle:true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.all(8.0),
            elevation: 2.0,
            shape: const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(14.0))),
            child: Container(
              margin: EdgeInsets.all(15),
              child: RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      // TextSpan(
                      //   text: '''数据备份：''',
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //     color:Theme.of(context).primaryColor,
                      //     height: 1.8,
                      //   ),
                      // ),
                      TextSpan(
                        text: '''按下备份按键可以将最新的用户数据备份到本地文件中，本地文件的路径为：''',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          height: 1.8,
                        ),
                      ),
                      TextSpan(
                        text: '''Android/data/com.jizhangapp.flutter_jizhangapp/files''',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          height: 1.8,
                        ),
                      ),
                      TextSpan(
                        text: '''，您可以在本地的文件夹中找到。\n按下还原上次备份按键，系统将把上次备份存储路径中的文件覆盖目前用户的数据信息。并且APP自动重启\n''',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          height: 1.8,
                        ),
                      ),
                      TextSpan(
                        text: '''涉及到用户隐私的密码不会备份和还原''',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.8,
                        ),
                      ),
                    ]
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async{
                    await writeToFile();
                    setState(() {});
                  },
                  child: Text(
                    "备份",
                    style: TextStyle(
                      fontFamily: "SFUIText",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                RaisedButton(
                  onPressed: () async{
                    await getNotesFromCache();
                    setState(() {});
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('splash');
                  },
                  child: Text(
                    "还原上次备份",
                    style: TextStyle(
                      fontFamily: "SFUIText",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


}
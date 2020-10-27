import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'database.dart';
import 'package:toast/toast.dart';
import '../data/model.dart';

class BackupToFile extends StatefulWidget {

  @override
  _BackupToFileState createState() => new _BackupToFileState();

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
    Directory documentsDir = await getExternalStorageDirectory();
    String documentsPath = documentsDir.path;
    print(documentsPath);

    File billsFile = new File('$documentsPath/bills');
    if (!billsFile.existsSync()) {
      billsFile.createSync();
    }

    BillsModel billsModel = await BillsDatabaseService.db.LatestBill();
    String bills =JsonEncoder().convert(billsModel.toMap());
    print(bills);
    File billsFile1 = await billsFile.writeAsString(bills);
    if (billsFile1.existsSync()) {
      Toast.show("successful", context);
    }

  }

  void getNotesFromCache() async {
    Directory documentsDir = await getExternalStorageDirectory();
    String documentsPath = documentsDir.path;

    File billsFile = new File("$documentsPath/bills");
    if (!billsFile.existsSync()) {
      return;
    }

    String bills = await billsFile.readAsString();
    setState(() {
      testString = bills;
    });
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(

        ),
        body: ListView(
          children: <Widget>[
            Card(
              child: Text("上次备份时间"),
            ),
            Card(
              child: Text("Stored "),
            ),
            // TextField(
            //   onChanged: (value) {
            //     inputString = value;
            //   },
            //   decoration: InputDecoration(
            //     suffixIcon: IconButton(
            //         icon: Icon(Icons.save),
            //         onPressed: () async {
            //           await writeToFile(inputString);
            //         })
            //   ),
            // ),
            RaisedButton(
              onPressed: ()  async {
                await writeToFile();
                setState(() {});
              },
              child: Text("Write Files"),
            ),
            RaisedButton(
              onPressed: ()  async {
                await getNotesFromCache();
                setState(() {});
              },
              child: Text("Get Files"),
            ),
          ],
        ),
      );
  }


}
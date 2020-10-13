import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/shared_pref.dart';
import 'package:toast/toast.dart';

class editAccountPicker extends StatefulWidget{
  @override
  _editAccountPicker createState() => _editAccountPicker();
}

class editAccountPickerArguments {  //上一个页面传入的所有参数
  final String legacyAccountPickerData;

  editAccountPickerArguments(this.legacyAccountPickerData);
}

class _editAccountPicker extends State<editAccountPicker>{

  List accountList;  //account所有选项的list形式
  bool isChange;





  @override
  Future<void> initState() {
    super.initState();
    isChange = false;
  }

  @override
  Widget build(BuildContext context){
    final editAccountPickerArguments args = ModalRoute.of(context).settings.arguments;
    accountList = (isChange == false)?JsonDecoder().convert(args.legacyAccountPickerData): accountList; //判断
    return Scaffold(
      appBar: AppBar(
        title: Text("editAccountPicker"),
      ),
      body: new ListView.separated(
        itemCount: accountList.length,
        scrollDirection: Axis.vertical, //方向：垂直滑动
        itemBuilder: (context, index){
          return Container(
            margin: EdgeInsets.only(top: 50.0, left: 120.0), //容器外填充
            constraints: BoxConstraints.tightFor(width: 200.0, height: 50.0), //卡片大小
            alignment: Alignment.centerLeft, //卡片内文字居中
            child: Text("${accountList[index]}"),
          );
        },
        separatorBuilder: (context, index) {
          return new Divider(
            height: 1,
          );
        },
      ),
      floatingActionButton: FloatingActionButton( //添加新的account
        child: Icon(Icons.add),
        onPressed:() async {
          //print(accountList.last);
          String newAccount =  await inputNewAccount(); //等待输入框返回字符串
          if(newAccount != null){
            bool isExist = false;
            accountList.forEach((element) {  //检查新建账户是否和已有账户重复
              if(element == newAccount) {
                isExist = true;
              }
            });
            if(isExist == true) {
              Toast.show("该账户已存在", context);
            }
            else {
              setState(() {
                accountList.add(newAccount); //新account加入list
                //print("add");
                isChange = true;
                setPicker('maccountPicker',
                    JsonEncoder().convert(accountList)); //新list存入文件
              });
            }
          }
        },
      ),

    );
  }

  Future<String> inputNewAccount(){
    String input;
    return showDialog<String> (
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("input new account"),
            content: TextField(
              autofocus: true,
              maxLines: 1, //最大行数
              keyboardType: TextInputType.name,
              onChanged: (val){
                input = val;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text("确认"),
                  onPressed: () {
                    if(input != null) {
                      Navigator.of(context).pop(input);
                    }
                    else {
                      Toast.show("请输入账户", context, gravity: Toast.CENTER);
                    }
                  }
              ),
            ],
          );
        }
    );
  }

}
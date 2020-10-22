import 'dart:convert';

import '../service/database.dart';
import 'package:flutter/material.dart';
import '../service/shared_pref.dart';
import 'package:toast/toast.dart';

class editAccountPicker extends StatefulWidget {
  @override
  _editAccountPicker createState() => _editAccountPicker();
}

class editAccountPickerArguments {
  //上一个页面传入的所有参数
  final String legacyAccountPickerData;

  editAccountPickerArguments(this.legacyAccountPickerData);
}

class _editAccountPicker extends State<editAccountPicker> {
  List accountList; //account所有选项的list形式
  bool isChange;

  List<Widget> accountListCard;



  @override
  Future<void> initState() {
    super.initState();
    isChange = false;
  }

  @override
  Widget build(BuildContext context) {
    final editAccountPickerArguments args =
        ModalRoute.of(context).settings.arguments;
    accountList = (isChange == false)
        ? JsonDecoder().convert(args.legacyAccountPickerData)
        : accountList; //判断
    //print(accountList as Map);
    accountListCard = [];
    for(var index = 0;index < accountList.length;index++) {
      accountListCard.add(
          // Dismissible(
          //   key: Key(accountList[index].toString()),
          //   onDismissed: (direction) {
          //
          //     setState(() {
          //       accountList.removeAt(index);
          //       print("$index ${accountList.toString()}");
          //       accountListCard.removeAt(index);
          //       print("$index ${accountList.toString()}");
          //       isChange = true;
          //     });
          //   },
          //   child:
            Card(
              margin: EdgeInsets.all(5.0),
              elevation: 15.0,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(14.0))),
              child: InkWell(
                onTap: () async {
                  String changeAccount = await inputNewAccount();
                  if (changeAccount != null) {
                    bool isExist = false;
                    accountList.forEach((element) {
                      if (element == changeAccount) {
                        isExist = true;
                      }
                    });
                    if (isExist == true) {
                      Toast.show('该账户已存在', context);
                    } else {
                      setState(() {
                        updateAccount(accountList[index], changeAccount);
                        accountList[index] = changeAccount;
                        isChange = true;
                        setPicker('maccountPicker',
                            JsonEncoder().convert(accountList));
                      });
                    }
                  }

                },
                child: ListTile(
                  title: Text(accountList[index], style: TextStyle(color: Colors.black45),),
                  leading: Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Visibility(
                    visible: (accountList.length > 1),
                    maintainInteractivity: false,
                    maintainSize: false,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_outline
                      ),
                      onPressed: () async {
                        bool isDelete = await deleteConfirm();
                        if (isDelete) {
                          isChange = true;
                          print(accountList);
                          removeAccount(accountList[index]);
                          accountList.removeAt(index);
                          print(accountList);
                          setPicker('maccountPicker',
                              JsonEncoder().convert(accountList));
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),

          // )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("editAccountPicker"),
      ),
      body: new ListView.builder(
        itemCount: accountListCard.length,
        scrollDirection: Axis.vertical, //方向：垂直滑动
        itemBuilder: (context, index) {
          return accountListCard[index];
          // return Container(
          //   margin: EdgeInsets.only(top: 50.0, left: 120.0), //容器外填充
          //   constraints:
          //       BoxConstraints.tightFor(width: 200.0, height: 50.0), //卡片大小
          //   alignment: Alignment.centerLeft, //卡片内文字居中
          //   child: Text("${accountList[index]}"),
          // );
        },
      ),
      floatingActionButton: FloatingActionButton(
        //添加新的account
        child: Icon(Icons.add),
        onPressed: () async {
          //print(accountList.last);
          String newAccount = await inputNewAccount(); //等待输入框返回字符串
          if (newAccount != null) {
            bool isExist = false;
            accountList.forEach((element) {
              //检查新建账户是否和已有账户重复
              if (element == newAccount) {
                isExist = true;
              }
            });
            if (isExist == true) {
              Toast.show("该账户已存在", context);
            } else {
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

  Future<String> inputNewAccount() {  //新建账户弹窗
    String input;
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("请输入账户名称"),
            content: TextField(
             decoration: InputDecoration(
               hintText: "不大于6个字符",
             ),
              autofocus: true,
              maxLines: 1, //最大行数
              keyboardType: TextInputType.name,
              onChanged: (val) {
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
                    if (input == "未选择") {Toast.show("名称不可用", context, gravity: Toast.CENTER);}
                    else if (input.length > 0 && input.length <7) {
                      Navigator.of(context).pop(input);
                    } else if(input.length == 0){
                      Toast.show("请输入账户", context, gravity: Toast.CENTER);
                    }
                    else if(input.length > 7){
                      Toast.show("名称长度过长", context, gravity: Toast.CENTER);
                    }
                  }),
            ],
          );
        });
  }

  Future<bool> deleteConfirm() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示"),
            content:Text(
              "删除账户后，账户关联的所有流水都将被删除，您确定要删除所选账户吗？",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: Text("确认"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        }
    );
  }

  removeAccount(String accountToBeDeleted) async {
    // await BillsDatabaseService.db.updateAccountInDB(accountToBeDeleted, '现金账户');
    await BillsDatabaseService.db.deleteAccountInDB(accountToBeDeleted);
  }

  updateAccount(String accountToBeUpdated, String accountNewName) async {
    await BillsDatabaseService.db.updateAccountInDB(accountToBeUpdated, accountNewName);
  }
}
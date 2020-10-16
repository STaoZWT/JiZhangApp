import 'dart:convert';

import 'package:flutter/material.dart';
import '../service/shared_pref.dart';
import 'package:toast/toast.dart';

class editMemberPicker extends StatefulWidget {
  @override
  _editMemberPicker createState() => _editMemberPicker();
}

class editMemberPickerArguments {
  //上一个页面传入的所有参数
  final String legacyMemberPickerData;

  editMemberPickerArguments(this.legacyMemberPickerData);
}

class _editMemberPicker extends State<editMemberPicker> {
  List memberList;
  bool isChange;

  List<Widget> memberListCard;

  @override
  Future<void> initState() {
    super.initState();
    isChange = false;
  }

  @override
  Widget build(BuildContext context) {
    final editMemberPickerArguments args =
        ModalRoute.of(context).settings.arguments;
    memberList = (isChange == false)
        ? JsonDecoder().convert(args.legacyMemberPickerData)
        : memberList;

    memberListCard = [];
    for (var index = 0; index < memberList.length; index++) {
      memberListCard.add(
          Dismissible(
            key: Key(memberList[index].toString()),
            onDismissed: (direction) {

              setState(() {
                memberList.removeAt(index);
                print("$index ${memberList.toString()}");
                memberListCard.removeAt(index);
                print("$index ${memberList.toString()}");
                isChange = true;
              });
            },
            child: Card(
              margin: EdgeInsets.all(5.0),
              elevation: 15.0,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(14.0))),
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text(memberList[index], style: TextStyle(color: Colors.black45),),
                  leading: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),

          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("editMemberPicker"),
      ),
      body: new ListView.builder(
        itemCount: memberList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return memberListCard[index];
          // return Container(
          //   margin: EdgeInsets.only(top: 50.0, left: 120.0), //容器外填充
          //   constraints:
          //       BoxConstraints.tightFor(width: 200.0, height: 50.0), //卡片大小
          //   alignment: Alignment.centerLeft, //卡片内文字位置
          //   child: Text("${memberList[index]}"),
          // );
        },
        // separatorBuilder: (context, index) {
        //   return new Divider(
        //     height: 1,
        //   );
        // },
      ),
      floatingActionButton: FloatingActionButton(
        //添加新的account
        child: Icon(Icons.add),
        onPressed: () async {
          //print(memberList.last);
          String newMember = await inputNewMember(); //等待输入框返回字符串
          if (newMember != null) {
            bool isExist = false;
            memberList.forEach((element) {
              //检查新建账户是否和已有账户重复
              if (element == newMember) {
                isExist = true;
              }
            });
            if (isExist == true) {
              Toast.show("该成员已存在", context);
            } else {
              setState(() {
                memberList.add(newMember); //新account加入list
                isChange = true;
                setPicker('mmemberPicker',
                    JsonEncoder().convert(memberList)); //新list存入文件
              });
            }
          }
        },
      ),
    );
  }

  Future<String> inputNewMember() {
    String input;
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("input new member"),
            content: TextField(
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
                  if (input != null) {
                    Navigator.of(context).pop(input);
                  } else {
                    Toast.show("请输入成员", context, gravity: Toast.CENTER);
                  }
                },
              ),
            ],
          );
        });
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import '../service/shared_pref.dart';
import '../service/database.dart';
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
          Card(
              margin: EdgeInsets.all(5.0),
              elevation: 15.0,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(14.0))),
              child: InkWell(
                onTap: () async {
                  if(memberList[index]=='无成员') {
                    Toast.show('该项不可修改', context);
                  }
                  else {
                    String changeMember = await inputNewMember();
                    if (changeMember != null) {
                      bool isExist = false;
                      memberList.forEach((element) {
                        //检查修改账户是否和已有账户重复
                        if (element == changeMember) {
                          isExist = true;
                        }
                      });
                      if (isExist == true) {
                        Toast.show("该成员已存在", context);
                      } else {
                        setState(() {
                          updateMember(memberList[index], changeMember); //对数据库内相应的成员名进行修改
                          memberList[index] = changeMember; //新account加入list
                          isChange = true;
                          setPicker('mmemberPicker',
                              JsonEncoder().convert(memberList)); //新list存入文件
                        });
                      }
                    }
                  }

                },
                child: ListTile(
                  title: Text(memberList[index], style: TextStyle(color: Colors.black45),),
                  leading: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.blue,
                  ),
                  trailing: Visibility(
                      visible: (memberList[index]!='无成员'), //只有选择“收入”“支出”才会显示
                      maintainInteractivity: false,
                      maintainSize: false,
                      child:IconButton( //删除按钮
                        icon: Icon(
                          Icons.delete_outline,  //删除按钮
                        ),
                        onPressed: () async {
                          bool isDelete = await deleteConfirm();
                          if(isDelete) {
                            isChange = true;
                            print(memberList);
                            removeMember(memberList[index]);  //数据库内相应流水改为“无成员”
                            memberList.removeAt(index); //从list中删除
                            print(memberList);
                            setPicker('mmemberPicker',
                                JsonEncoder().convert(memberList));
                            setState(() {

                            });

                          }

                        },
                      ),
                  )

                ),
              ),
            ),


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
            title: Text("请输入新的成员名称"),
            content: TextField(
              autofocus: true,
              maxLines: 1, //最大行数
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: "不大于6个字符",
              ),
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
                  if (input.length > 0 && input.length <7) {
                    Navigator.of(context).pop(input);
                  } else if(input.length == 0){
                    Toast.show("请输入成员", context, gravity: Toast.CENTER);
                  }
                  else if(input.length > 7){
                    Toast.show("名称长度过长", context, gravity: Toast.CENTER);
                  }
                },
              ),
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
                "删除成员后，成员关联的账单同时也会变为“无成员”，您确定要删除所选成员吗？",
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


  removeMember(String memberToBeDeleted) async {
    await BillsDatabaseService.db.updateMemberInDB(memberToBeDeleted, '无成员');
  }

  updateMember(String memberToBeUpdated, String memberNewName) async {
    await BillsDatabaseService.db.updateMemberInDB(memberToBeUpdated, memberNewName);
  }

}

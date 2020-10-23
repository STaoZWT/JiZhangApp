import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/login/register.dart';
import '../service/shared_pref.dart';
import '../service/database.dart';
import '../service/app_info.dart';
import 'package:provider/provider.dart';

class RemoveUserDataPage extends StatefulWidget {
  @override
  _RemoveUserDataPageState createState() => _RemoveUserDataPageState();
}

class _RemoveUserDataPageState extends State<RemoveUserDataPage> {

  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  clearAll() async {
    await BillsDatabaseService.db.deleteBillAllInDB();
    await removePassword();
    await removeColorKey();
    await setGraphicalPassWord(null);
    Provider.of<AppInfoProvider>(context, listen: false).setTheme('blue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            isPasswordValid(passwordController.value.text.toString()).then((value) {
              print("value is $value");

            // getPassWord().then((password) {
              if (value == true) {
                showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context)
                {
                  return new AlertDialog(
                    title: Text(
                        "警告",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                        "您确定要清空所有数据吗？",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () async {
                            await clearAll();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => RegisterPage()));
                          },
                          child: Text("确定")
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("取消")
                      ),
                    ],
                  );
                }
                );
              } else {
                showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      title: Text("提醒"),
                      content: Text("密码错误，请重新输入"),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Text("确定")
                        )
                      ],
                    );
                  }
                );
              }
            });
          },
          label:
            Text(
                "确认清空数据",
              style: TextStyle(
                fontSize: 20
              ),
            ),
            icon: Icon(
              Icons.warning,
              size: 30,
            ),
            backgroundColor: Colors.red,
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(
          "清空所有数据确认页面",
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.all(8.0),
            elevation: 15.0,
            shape: const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(14.0))),
            child: Container(
              margin: EdgeInsets.all(15),
              child: RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '''注意：''',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.8,
                        ),
                      ),
                      TextSpan(
                        text: '''本操作将删除您的''',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          height: 1.8,
                        ),
                      ),
                      TextSpan(
                        text: '''所有''',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.8,
                        ),
                      ),
                      TextSpan(
                        text: '''数据，包括所有记账记录和登录密码等，并使应用初始化。如果您确认进行此操作，请在下方输入您的登录密码，并点击''',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          height: 1.8,
                        ),
                      ),
                      TextSpan(
                        text: '''“确认清空数据”''',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.8,
                        ),
                      ),
                      TextSpan(
                        text: '''进行确认。
''',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          height: 1.8,
                        ),
                      ),
                      TextSpan(
                        text: '''警告！本操作是不可挽回的！''',
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
          Card(
            margin: EdgeInsets.all(8.0),
            elevation: 15.0,
            shape: const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(14.0))),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                // labelText: "金额",
                // labelStyle: TextStyle(
                //   fontWeight: FontWeight.w300
                // ),
                hintText: "请输入登录密码 ",
                hintStyle:
                TextStyle(color: Colors.black12, fontSize: 20.0),
                //prefixIcon: Icon(Icons.attach_money),
                prefixIcon: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                //wordSpacing: 1.5,
                height: 1.5,
              ),
              maxLines: 1,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onChanged: (password) {
                print(password);
              },
              textAlign: TextAlign.left,
              controller: passwordController,
            ),
          ),
        ],
      ),
    );
  }
}
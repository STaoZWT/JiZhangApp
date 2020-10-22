import 'package:flutter/material.dart';
import '../homepage.dart';
import 'graphical_password_login.dart';
import '../service/shared_pref.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = TextStyle(fontSize: 15.0, color: Colors.black26);
  var _PassWordController = TextEditingController();

  void IsHaveGraphicalPw() async {
    print('GraphicalPwInsp');
    getGraphicalPassWord().then((GraphicalPasswordInSp) {
      print('GraphicalPwInsp is');
      print(GraphicalPasswordInSp);
      if (GraphicalPasswordInSp != null) {
        //Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => GraphicalPasswordLoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var localAuth = LocalAuthentication();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "login",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.blue),
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  leftRightPadding, 50.0, leftRightPadding, 10.0),
              child: Text("Welcome to Back!",
                  style: TextStyle(color: Colors.black, fontSize: 35.0)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  leftRightPadding, 50.0, leftRightPadding, topBottomPadding),
              child: TextField(
                style: hintTips,
                controller: _PassWordController,
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
              ),
            ),
            Container(
              width: 250.0,
              margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
              padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding,
                  leftRightPadding, topBottomPadding),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 6.0,
                child: FlatButton(
                  onPressed: () async {
                    // var passwordInSp;
                    // passwordInSp = await getPassWord();
                    // print('passwordSp');
                    // print(passwordInSp);
                    // print('passwordinput');
                    // print(_PassWordController.value.text.toString());
                    isPasswordValid(_PassWordController.value.text.toString()).then((value) {
                      if (value == true) {
                        // if (await isPasswordValid(_PassWordController.value.text.toString())) {
                        // if (passwordInSp ==
                        //     _PassWordController.value.text.toString()) {
                        showDialog<Null>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Congradulation!"),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("You have login successfully"),
                                      Text("Now use it happily"),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('confirm'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  NavigationHomeScreen()));
                                    },
                                  )
                                ],
                              );
                            });
                      } else {
                        showDialog<Null>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error!!"),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text("passWordError!"),
                                      Text("Please input again"),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text('confirm'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      })
                                ],
                              );
                            });
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 250.0,
              margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
              padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding,
                  leftRightPadding, topBottomPadding),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 6.0,
                child: FlatButton(
                  onPressed: () {
                    IsHaveGraphicalPw();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Graphic login",
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 250.0,

              margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
              padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding, leftRightPadding, topBottomPadding),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 6.0,
                child: FlatButton(
                  onPressed: () async {
                    //下面是汉化
                    const andStrings = const AndroidAuthMessages(
                      cancelButton: '取消',
                      goToSettingsButton: '去设置',
                      fingerprintNotRecognized: '指纹识别失败',
                      goToSettingsDescription: '请设置指纹.',
                      fingerprintHint: '指纹',
                      fingerprintSuccess: '指纹识别成功',
                      signInTitle: '指纹验证',
                      fingerprintRequiredTitle: '请先录入指纹!',
                    );

                    try {
                      bool didAuthenticate;
                      await localAuth.authenticateWithBiometrics(
                          localizedReason:
                          '扫描指纹进行身份识别',
                          useErrorDialogs: true,
                          stickyAuth: true,
                          androidAuthStrings: andStrings
                      ).then((didAuthenticate){
                        didAuthenticate==true? Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
                                (route) => route==null
                        ):print("false");
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Fingerprint login",style: TextStyle(color: Colors.black,fontSize: 20.0),),
                  ),
                ),
              ),
            )
          ],
        ));
    //throw UnimplementedError();
  }
}

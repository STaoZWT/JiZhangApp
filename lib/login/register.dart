import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../homepage.dart';
import './login.dart';
import '../service/shared_pref.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var registerPassWordController = TextEditingController();
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = TextStyle(fontSize: 15.0, color: Colors.black26);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "register",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
                leftRightPadding, 50.0, leftRightPadding, 10.0),
            child: Text("Welcome to JiZhangApp!",
                style: TextStyle(color: Colors.black, fontSize: 30.0)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                leftRightPadding, 50.0, leftRightPadding, topBottomPadding),
            child: TextField(
              style: hintTips,
              controller: registerPassWordController,
              decoration:
                  InputDecoration(hintText: "Please Set Your Password Here"),
              obscureText: true,
            ),
          ),
          Container(
            width: 250.0,
            margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
            padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding,
                leftRightPadding, topBottomPadding),
            child: Card(
              color: Theme.of(context).primaryColor,
              elevation: 6.0,
              child: FlatButton(
                onPressed: () async {
                  if (registerPassWordController.value.text.toString().length >=
                          8 &&
                      registerPassWordController.value.text.toString().length <=
                          18) {
                    await setEncryptedPassword(
                        registerPassWordController.value.text.toString());
                    showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Congradulation!"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text("You have register successfully"),
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
                                  Text(
                                      "Please input the password in 8~18 length"),
                                  Text("Please input again"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('confirm'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

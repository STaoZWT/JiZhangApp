import 'package:flutter/material.dart';
import 'password_reset.dart';
import '../service/shared_pref.dart';

class PasswordConfirmPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PasswordConfirmPage();
  }
}

class _PasswordConfirmPage extends State<PasswordConfirmPage> {
  var confirmPassWordController = TextEditingController();
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
          "password confirm",
          //style: TextStyle(color: Colors.black),
        ),
        iconTheme: Theme.of(context).iconTheme,
        //backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
                leftRightPadding, 50.0, leftRightPadding, 10.0),
            child: Text("Password test",
                style: TextStyle(color: Colors.black, fontSize: 35.0)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                leftRightPadding, 50.0, leftRightPadding, topBottomPadding),
            child: TextField(
              style: hintTips,
              controller: confirmPassWordController,
              decoration:
                  InputDecoration(hintText: "Please input Your Password Here"),
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
                  // var passwordInSp;
                  // passwordInSp = await getPassWord();
                  isPasswordValid(confirmPassWordController.value.text.toString()).then((value) {
                  if (value == true) {
                  // if (passwordInSp ==
                  //     confirmPassWordController.value.text.toString()) {
                    showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Congradulation!"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text("Your passWord successfully"),
                                  Text("Now change your passWord"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('confirm'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PasswordResetPage()));
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
                                },
                              )
                            ],
                          );
                        });
                  }
                });},
                /*{

                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => PasswordResetPage()));
                  /*if(registerPassWordController.value.text.toString().length>=8&&registerPassWordController.value.text.toString().length<=18){
                    save(); //保存密码为mpassWord
                    get().then((value) => passWordGet=value??000);
                    print('1'+passWordGet.toString());
                    showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Congradulation!"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children:<Widget> [
                                  Text("You have register successfully"),
                                  Text("Now use it happily"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('confirm'),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => HomePage()));
                                },
                              )
                            ],
                          );
                        }
                    );
                  }else{
                    get().then((value) => passWordGet=value??000);
                    print('2'+passWordGet.toString());
                    showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Error!!"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children:<Widget> [
                                  Text("Please input the password in 8~18 length"),
                                  Text("Please input again"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('confirm'),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        }
                    );
                  }*/
                },*/
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Sure",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

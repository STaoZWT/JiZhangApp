import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/ui/comman_dialog.dart';
import '../homepage.dart';
import '../service/shared_pref.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PasswordResetPage();
  }
}

class _PasswordResetPage extends State<PasswordResetPage> {
  var resetPassWordController = TextEditingController();
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = TextStyle(fontSize: 15.0, color: Colors.black26);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("image/tupian.jpg"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "重置你的密码",
                    style: TextStyle(
                        fontFamily: "SFUIText",
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(
                    height: 250,
                  ),
                  Card(
                    elevation: 10,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 100,
                          ),
                          TextFormField(
                            controller: resetPassWordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                fillColor: Color(0xfff5f9f6),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.transparent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.transparent),
                                ),
                                hintText: "输入你的新密码",
                                hintStyle: TextStyle(
                                  fontFamily: "SFUIText",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black26,
                                )),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 56,
                          width: 120,
                          child: RaisedButton(
                            onPressed: () async{
                              if(isLoginPassword(resetPassWordController.value.text.toString())){
                                await setEncryptedPassword(resetPassWordController.value.text.toString());
                                Navigator.of(context).pushReplacementNamed('home');
                              }else{
                                CommonDialog.show(context, Text('注册密码不合法！\n密码必须由8-18位的数字或者字母组成'));
                              }
                            },
                            child: Text(
                              "确定",
                              style: TextStyle(
                                fontFamily: "SFUIText",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        IconButton(
                          iconSize: 50,
                          onPressed: (){
                            Navigator.of(context).pushReplacementNamed('home');
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Padding(padding: EdgeInsets.only(top: 290),
                  child: CircleAvatar(
                    //child: Image.asset("image/tupian.jpg"),
                    backgroundImage: AssetImage("image/tupian.jpg"),
                    radius: 60,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       "password reset",
    //       style: TextStyle(color: Colors.black),
    //     ),
    //     iconTheme: IconThemeData(color: Colors.blue),
    //     backgroundColor: Colors.blue,
    //     automaticallyImplyLeading: false,
    //   ),
    //   body: Column(
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: <Widget>[
    //       Padding(
    //         padding: EdgeInsets.fromLTRB(
    //             leftRightPadding, 50.0, leftRightPadding, 10.0),
    //         child: Text("Reset your password",
    //             style: TextStyle(color: Colors.black, fontSize: 30.0)),
    //       ),
    //       Padding(
    //         padding: EdgeInsets.fromLTRB(
    //             leftRightPadding, 50.0, leftRightPadding, topBottomPadding),
    //         child: TextField(
    //           style: hintTips,
    //           controller: resetPassWordController,
    //           decoration: InputDecoration(
    //               hintText: "Please input Your New Password Here"),
    //           obscureText: true,
    //         ),
    //       ),
    //       Container(
    //         width: 250.0,
    //         margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
    //         padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding,
    //             leftRightPadding, topBottomPadding),
    //         child: Card(
    //           color: Colors.lightBlueAccent,
    //           elevation: 6.0,
    //           child: FlatButton(
    //             onPressed: () async {
    //               if (resetPassWordController.value.text.toString().length >=
    //                       8 &&
    //                   resetPassWordController.value.text.toString().length <=
    //                       18) {
    //                 await setEncryptedPassword(
    //                     resetPassWordController.value.text.toString());
    //                 showDialog<Null>(
    //                     context: context,
    //                     barrierDismissible: false,
    //                     builder: (BuildContext context) {
    //                       return AlertDialog(
    //                         title: Text("Congradulation!"),
    //                         content: SingleChildScrollView(
    //                           child: ListBody(
    //                             children: <Widget>[
    //                               Text("You have change password successfully"),
    //                               //Text("Now use it happily"),
    //                             ],
    //                           ),
    //                         ),
    //                         actions: <Widget>[
    //                           FlatButton(
    //                             child: Text('confirm'),
    //                             onPressed: () {
    //                               Navigator.of(context).pop();
    //                               Navigator.of(context).pop();
    //                               // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //                               //     builder: (BuildContext context) =>
    //                               //         HomePage()));
    //                             },
    //                           )
    //                         ],
    //                       );
    //                     });
    //               } else {
    //                 showDialog<Null>(
    //                     context: context,
    //                     barrierDismissible: false,
    //                     builder: (BuildContext context) {
    //                       return AlertDialog(
    //                         title: Text("Error!!"),
    //                         content: SingleChildScrollView(
    //                           child: ListBody(
    //                             children: <Widget>[
    //                               Text(
    //                                   "Please input the password in 8~18 length"),
    //                               Text("Please input again"),
    //                             ],
    //                           ),
    //                         ),
    //                         actions: <Widget>[
    //                           FlatButton(
    //                             child: Text('confirm'),
    //                             onPressed: () {
    //                               Navigator.of(context).pop();
    //                             },
    //                           )
    //                         ],
    //                       );
    //                     });
    //               }
    //             },
    //             /*onPressed: () {
    //               Navigator.of(context).pop();
    //               Navigator.of(context).push(MaterialPageRoute(
    //                   builder: (BuildContext context) => HomePage()));
    //               /*if(registerPassWordController.value.text.toString().length>=8&&registerPassWordController.value.text.toString().length<=18){
    //                 save(); //保存密码为mpassWord
    //                 get().then((value) => passWordGet=value??000);
    //                 print('1'+passWordGet.toString());
    //                 showDialog<Null>(
    //                     context: context,
    //                     barrierDismissible: false,
    //                     builder: (BuildContext context){
    //                       return AlertDialog(
    //                         title: Text("Congradulation!"),
    //                         content: SingleChildScrollView(
    //                           child: ListBody(
    //                             children:<Widget> [
    //                               Text("You have register successfully"),
    //                               Text("Now use it happily"),
    //                             ],
    //                           ),
    //                         ),
    //                         actions: <Widget>[
    //                           FlatButton(
    //                             child: Text('confirm'),
    //                             onPressed: (){
    //                               Navigator.of(context).pop();
    //                               Navigator.of(context).push(MaterialPageRoute(
    //                                   builder: (BuildContext context) => HomePage()));
    //                             },
    //                           )
    //                         ],
    //                       );
    //                     }
    //                 );
    //               }else{
    //                 get().then((value) => passWordGet=value??000);
    //                 print('2'+passWordGet.toString());
    //                 showDialog<Null>(
    //                     context: context,
    //                     barrierDismissible: false,
    //                     builder: (BuildContext context){
    //                       return AlertDialog(
    //                         title: Text("Error!!"),
    //                         content: SingleChildScrollView(
    //                           child: ListBody(
    //                             children:<Widget> [
    //                               Text("Please input the password in 8~18 length"),
    //                               Text("Please input again"),
    //                             ],
    //                           ),
    //                         ),
    //                         actions: <Widget>[
    //                           FlatButton(
    //                             child: Text('confirm'),
    //                             onPressed: (){
    //                               Navigator.of(context).pop();
    //                             },
    //                           )
    //                         ],
    //                       );
    //                     }
    //                 );
    //               }*/
    //             },*/
    //             child: Padding(
    //               padding: EdgeInsets.all(10.0),
    //               child: Text(
    //                 "Sure",
    //                 style: TextStyle(color: Colors.black, fontSize: 20.0),
    //               ),
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}

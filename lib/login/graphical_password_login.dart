import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/ui/comman_dialog.dart';
import 'login.dart';
import '../service/shared_pref.dart';
import 'package:gesture_recognition/gesture_view.dart';

import '../homepage.dart';

class GraphicalPasswordLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GraphicalPasswordLoginPageState();
  }
}

class _GraphicalPasswordLoginPageState
    extends State<GraphicalPasswordLoginPage> {
  List<int> resultNow;
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = TextStyle(fontSize: 15.0, color: Colors.black26);
  void confirmGraphicalPw(List<int> items) async{
    resultNow = items;
    print('result is $resultNow');
    String resultNowOfString = resultNow.join("");
    print("The resultNowOfString is ");
    print(resultNow);
    var grahicalPasswordInSp;
    await getGraphicalPassWord().then((grahicalPasswordInSp){
      if(resultNowOfString==grahicalPasswordInSp){
        Navigator.of(context).pushReplacementNamed('home');
      }else{
        CommonDialog.show(context, Text('密码错误'));
      }
    });

  }
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
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "  输入你的图形密码",
                    style: TextStyle(
                        fontFamily: "SFUIText",
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  GestureView(
                    showUnSelectRing: false,
                    immediatelyClear: true,
                    size: MediaQuery
                        .of(context)
                        .size
                        .width,
                    onPanUp: (List<int> items) {
                      setState(() {
                        confirmGraphicalPw(items);
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          iconSize: 50,
                          onPressed: (){
                            Navigator.of(context).pushReplacementNamed('graphical_register');
                          },
                          icon: Icon(
                            Icons.keyboard_backspace,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       "Graphic PassWord Login",
    //       style: TextStyle(color: Colors.black),
    //     ),
    //     iconTheme: IconThemeData(color: Colors.blue),
    //     backgroundColor: Colors.blue,
    //     automaticallyImplyLeading: false,
    //   ),
    //   body: ListView(
    //       children: <Widget>[
    //         GestureView(
    //           immediatelyClear: false,
    //           size: MediaQuery.of(context).size.width,
    //           onPanUp: (List<int> items) {
    //             setState(() {
    //               resultNow = items;
    //               print("resultNow is down");
    //               print(resultNow);
    //             });
    //           },
    //         ),
    //         Container(
    //           width: 250.0,
    //           margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
    //           padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding,
    //               leftRightPadding, topBottomPadding),
    //           child: Card(
    //             color: Colors.lightBlueAccent,
    //             elevation: 6.0,
    //             child: FlatButton(
    //               onPressed: () async {
    //                 print('into dianji');
    //                 //List <String> resultToSp ;
    //                 String resultNowOfString = resultNow.join("");
    //                 print("The resultNowOfString is ");
    //                 print(resultNow);
    //                 var grahicalPasswordInSp;
    //                 grahicalPasswordInSp = await getGraphicalPassWord();
    //                 if (grahicalPasswordInSp == resultNowOfString) {
    //                   showDialog<Null>(
    //                       context: context,
    //                       barrierDismissible: false,
    //                       builder: (BuildContext context) {
    //                         return AlertDialog(
    //                           title: Text("Congradulation!"),
    //                           content: SingleChildScrollView(
    //                             child: ListBody(
    //                               children: <Widget>[
    //                                 Text("You have login successfully"),
    //                                 Text("Now use it happily"),
    //                               ],
    //                             ),
    //                           ),
    //                           actions: <Widget>[
    //                             FlatButton(
    //                               child: Text('confirm'),
    //                               onPressed: () {
    //                                 Navigator.of(context).pop();
    //                                 Navigator.of(context).pop();
    //                                 Navigator.of(context).pushReplacement(
    //                                     MaterialPageRoute(
    //                                         builder: (BuildContext context) =>
    //                                             HomePage()));
    //                               },
    //                             )
    //                           ],
    //                         );
    //                       });
    //                 } else {
    //                   showDialog<Null>(
    //                       context: context,
    //                       barrierDismissible: false,
    //                       builder: (BuildContext context) {
    //                         return AlertDialog(
    //                           title: Text("Error!!"),
    //                           content: SingleChildScrollView(
    //                             child: ListBody(
    //                               children: <Widget>[
    //                                 Text("passWordError!"),
    //                                 Text("Please input again"),
    //                               ],
    //                             ),
    //                           ),
    //                           actions: <Widget>[
    //                             FlatButton(
    //                                 child: Text('confirm'),
    //                                 onPressed: () {
    //                                   Navigator.of(context).pop();
    //                                 })
    //                           ],
    //                         );
    //                       });
    //                 }
    //               },
    //               child: Padding(
    //                 padding: EdgeInsets.all(10.0),
    //                 child: Text(
    //                   "Set",
    //                   style: TextStyle(color: Colors.black, fontSize: 20.0),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           width: 250.0,
    //           margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
    //           padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding,
    //               leftRightPadding, topBottomPadding),
    //           child: Card(
    //             color: Colors.lightBlueAccent,
    //             elevation: 6.0,
    //             child: FlatButton(
    //               onPressed: () {
    //                 //Navigator.of(context).pop();
    //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
    //                     builder: (BuildContext context) => LoginPage()));
    //               },
    //               child: Padding(
    //                 padding: EdgeInsets.all(10.0),
    //                 child: Text(
    //                   "Back to text password",
    //                   style: TextStyle(color: Colors.black, fontSize: 20.0),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         )
    //       ]
    //       ),
    // );
  }
}

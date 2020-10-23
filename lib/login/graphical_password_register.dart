import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_jizhangapp/service/shared_pref.dart';
import 'package:flutter_jizhangapp/ui/comman_dialog.dart';
import 'package:gesture_recognition/gesture_view.dart';

class GraphicalPasswordRegisterPage extends StatefulWidget {
  @override
  _GraphicalPasswordRegisterPageState createState() => new _GraphicalPasswordRegisterPageState();
}

class _GraphicalPasswordRegisterPageState extends State<GraphicalPasswordRegisterPage> {
  bool showflag;
  int setCount;
  List<int> result;
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = TextStyle(fontSize: 15.0, color: Colors.black26);

  void setGraphicalPw(List<int> items) async{
    result = items;
    print('result is $result');
    if(result.length>2){
      String resultToSp = result.join("");
      print("The graphc password ");
      print(resultToSp);
      await setGraphicalPassWord(resultToSp);
      Navigator.of(context).pushReplacementNamed('graphical_login');
    }else{
      CommonDialog.show(context, Text('图形密码长度应该不小于3位'));
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCount = 0;
    showflag = false;
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
                    "  设置你的图形密码",
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
                        setGraphicalPw(items);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(
  //         "Setting Gesture",
  //         style: TextStyle(color: Colors.black),
  //       ),
  //       iconTheme: IconThemeData(color: Colors.blue),
  //       backgroundColor: Colors.blue,
  //       automaticallyImplyLeading: false,
  //     ),
  //     body: Column(
  //         mainAxisSize: MainAxisSize.max,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: <Widget>[
  //           GestureView(
  //             immediatelyClear: false,
  //             size: MediaQuery.of(context).size.width,
  //             onPanUp: (List<int> items) {
  //               setState(() {
  //                 result = items;
  //                 print("result is down");
  //                 print(result);
  //               });
  //             },
  //           ),
  //           Container(
  //             width: 250.0,
  //             margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
  //             padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding,
  //                 leftRightPadding, topBottomPadding),
  //             child: Card(
  //               color: Colors.lightBlueAccent,
  //               elevation: 6.0,
  //               child: FlatButton(
  //                 onPressed: () async {
  //                   print('into dianji');
  //                   //List <String> resultToSp ;
  //                   String resultToSp = result.join("");
  //                   print("The graphc password ");
  //                   print(resultToSp);
  //                   //await setPassWord(null);
  //                   await setGraphicalPassWord(resultToSp);
  //                   showDialog<Null>(
  //                       context: context,
  //                       barrierDismissible: false,
  //                       builder: (BuildContext context) {
  //                         return AlertDialog(
  //                           title: Text("Congradulation!"),
  //                           content: SingleChildScrollView(
  //                             child: ListBody(
  //                               children: <Widget>[
  //                                 Text(
  //                                     "You have set graphic password successfully"),
  //                                 Text("Now use it to login happily"),
  //                               ],
  //                             ),
  //                           ),
  //                           actions: <Widget>[
  //                             FlatButton(
  //                               child: Text('confirm'),
  //                               onPressed: () {
  //                                 Navigator.of(context).pop();
  //                                 Navigator.of(context).pop();
  //                                 // Navigator.of(context).pushReplacement(
  //                                 //     MaterialPageRoute(
  //                                 //         builder: (BuildContext context) =>
  //                                 //             HomePage()));
  //                               },
  //                             )
  //                           ],
  //                         );
  //                       });
  //                 },
  //                 child: Padding(
  //                   padding: EdgeInsets.all(10.0),
  //                   child: Text(
  //                     "Set",
  //                     style: TextStyle(color: Colors.black, fontSize: 20.0),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           )
  //         ]),
  //   );
  // }
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_jizhangapp/service/shared_pref.dart';
import '../ui/common_dialog.dart';
import 'package:gesture_recognition/gesture_view.dart';

class GraphicalPasswordRegisterPage extends StatefulWidget {
  @override
  _GraphicalPasswordRegisterPageState createState() => new _GraphicalPasswordRegisterPageState();
}

class _GraphicalPasswordRegisterPageState extends State<GraphicalPasswordRegisterPage> {
  bool showflag;
  List<int> result;

  void setGraphicalPw(List<int> items) async{
    result = items;
    print('result is $result');
    if(result.length>2){
      String resultToSp = result.join("");
      print("The graphc password ");
      print(resultToSp);
      await setGraphicalPassWord(resultToSp);
      Navigator.of(context).pop();
    }else{
      CommonDialog.show(context, Text('图形密码长度应该不小于3位'));
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showflag = false;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("image/cat.jpg"),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          iconSize: 50,
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.keyboard_backspace,
                            color: Theme.of(context).primaryColor,
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
  }
}
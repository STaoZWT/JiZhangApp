import 'package:flutter/material.dart';
import '../ui/common_dialog.dart';
import '../service/shared_pref.dart';
import 'package:gesture_recognition/gesture_view.dart';

class GraphicalPasswordLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GraphicalPasswordLoginPageState();
  }
}

class _GraphicalPasswordLoginPageState extends State<GraphicalPasswordLoginPage> {
  List<int> resultNow;
  void confirmGraphicalPw(List<int> items) async{
    resultNow = items;
    print('result is $resultNow');
    String resultNowOfString = resultNow.join("");
    print("The resultNowOfString is ");
    print(resultNow);
    await getGraphicalPassWord().then((grahicalPasswordInSp){
      if(resultNowOfString==grahicalPasswordInSp){
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('home_screen');
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
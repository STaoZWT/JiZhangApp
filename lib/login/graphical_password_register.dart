import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/shared_pref.dart';
import 'package:gesture_recognition/gesture_view.dart';

import '../homepage.dart';

class GraphicalPasswordRegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GraphicalPasswordRegisterPageState();
  }
}

class _GraphicalPasswordRegisterPageState
    extends State<GraphicalPasswordRegisterPage> {
  List<int> result;
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = TextStyle(fontSize: 15.0, color: Colors.black26);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting Gesture",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.blue),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureView(
              immediatelyClear: false,
              size: MediaQuery.of(context).size.width,
              onPanUp: (List<int> items) {
                setState(() {
                  result = items;
                  print("result is down");
                  print(result);
                });
              },
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
                    print('into dianji');
                    //List <String> resultToSp ;
                    String resultToSp = result.join("");
                    print("The graphc password ");
                    print(resultToSp);
                    //await setPassWord(null);
                    await setGraphicalPassWord(resultToSp);
                    showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Congradulation!"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                      "You have set graphic password successfully"),
                                  Text("Now use it to login happily"),
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
                                              HomePage()));
                                },
                              )
                            ],
                          );
                        });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Set",
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            )
          ]),
    );
  }
}

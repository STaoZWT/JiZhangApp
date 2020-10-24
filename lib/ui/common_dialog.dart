import 'package:flutter/material.dart';

class CommonDialog {
  static void show(BuildContext context, Widget content,
      {Widget title = const Text("提示"), VoidCallback onYes}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title,
            content: content,
            actions: <Widget>[
              // FlatButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: Text("取消")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("确定"))
            ],
          );
        });
  }
}

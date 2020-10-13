import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../const/picker_data.dart';
import '../service/shared_pref.dart';
import 'package:toast/toast.dart';

class editClassPicker extends StatefulWidget{

  // final String legacyClassPickerData;
  //
  // const editClassPicker({
  //   Key key,
  //   @required this.legacyClassPickerData,
  //
  // }): super(key:key);

  //print(legacyClassPickerData);



  @override
  _editClassPicker createState() => _editClassPicker();
}

class editClassPickerArguments {  //上一个页面传入的所有参数
  final String legacyClassPickerData;

  editClassPickerArguments(this.legacyClassPickerData);
}




class _editClassPicker extends State<editClassPicker>{

  List classList;
  bool isChange;


  @override
  Future<void> initState() {
    super.initState();
    isChange = false;
  }

  @override
  Widget build(BuildContext context){
    final editClassPickerArguments args = ModalRoute.of(context).settings.arguments;
    classList = (isChange == false)?JsonDecoder().convert(args.legacyClassPickerData): classList;
    ///print(classList[0]);
    // Map map = JsonDecoder().convert(mapClassPickerData);
    // var shipinList = map['食品酒水'] as List;
    // print(shipinList);
    // print(map['食品酒水']);
    // List<String> category1List = [];
    // String tempString;
    // for (var i = 0; i < classList.length; i++) {
    //   tempString = (classList[i] as Map).keys.toString();
    //
    // }
    //print((classList[0] as Map).keys); //第1个一级分类名
    Map map1 = classList[0] as Map;
    //print(map1['食品酒水']);
    List list2 = map1['食品酒水'] as List; //第1个一级分类下的所有二级分类
    //print(list2[0]);
    //print(JsonEncoder().convert(list2));


    //print(JsonDecoder().convert(classList.elementAt(0)));
    // classPickerData=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("editClassPicker"),
      ),
      body: new ListView.separated(  //列举一级分类的list
        itemCount: classList.length,
        scrollDirection: Axis.vertical, //方向：垂直滑动
        itemBuilder: (context, index) {
          Map category1 = classList[index] as Map; //第index个一级分类和他的二级分类们
          String category1name = removeBrackets(category1.keys.toString()); //该一级分类的名字，去除括号！！！
          List category2 = category1[category1name]; //该一级分类下所有二级分类的list
          //print(category2[1]);
          return Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ExpansionTile(  //一级分类的可收缩组件
              backgroundColor: Colors.white,
              title:Text("$category1name"),
              initiallyExpanded: false,
              children: <Widget>[
                new ListView.separated(  //二级分类的list
                  shrinkWrap: true, //无限高度
                  itemCount: category2.length,
                  scrollDirection: Axis.vertical, //方向：垂直滑动
                  itemBuilder: (context, index){
                    return Container(
                      margin: EdgeInsets.only(top: 50.0, left: 120.0), //容器外填充
                      constraints: BoxConstraints.tightFor(width: 200.0, height: 20.0), //卡片大小
                      alignment: Alignment.topLeft, //卡片内文字居中
                      child: Text("${category2[index]}"),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return new Divider(
                      height: 1,
                    );
                  },

                ),
                new Padding(  //二级分类添加按钮
                  padding: new EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  child: new Row(
                    children: <Widget>[
                      new OutlineButton.icon(
                        icon: Icon(Icons.add),
                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //圆角矩形
                        label: Text("add"),
                        onPressed: () async {
                          String newCategory2 =  await inputNewCategory2();
                          if(newCategory2 != null) {
                            //print(category1[category1name]);
                            bool isExist = false;
                            category2.forEach((element) {
                              if(element == newCategory2) { //二级分类查重
                                isExist = true;
                              }
                            });
                            if(isExist == true) {
                              Toast.show("该二级分类已存在", context);
                            }
                            else {
                              setState(() {
                                category2.add(newCategory2);
                                category1[category1name] = category2;
                                print(category1);
                                print(classList[index]);
                                print(JsonEncoder().convert(classList));
                                isChange = true;
                                setPicker('mclassPicker', JsonEncoder().convert(classList));
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return new Divider(
            height: 1,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(  //添加一级分类
          child: Icon(Icons.add),
          onPressed:() async {
            Map newCategory1 =  await inputNewCategory1();
            //print(newCategory1);
            if(newCategory1 != null) {
              bool isExist = false;
              classList.forEach((element) {
                //print("${newCategory1.keys}   ${(element as Map).keys}");
                if((element as Map).keys.toString() == newCategory1.keys.toString()) {
                  isExist = true; //判断新增一级分类是否重复
                }
              });
              if(isExist == true) {
                Toast.show("该一级分类已存在", context);
              }
              else {
                setState(() {
                  classList.add(newCategory1);
                  print(classList.last);
                  isChange = true;
                  setPicker('mclassPicker', JsonEncoder().convert(classList));
                });
              }
            }
          }
      ),
    );
  }



  Future<String> inputNewCategory2() { //添加二级分类的输入框
    String input;
    return showDialog<String> (
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("input new category2"),  //输入框标题
            content: TextField(
              autofocus: true,
              maxLines: 1, //最大行数
              decoration: InputDecoration(
                  labelText: "二级分类",  //输入框标题
                  prefixIcon: Icon(Icons.add_box)  //输入框图标样式
              ),
              keyboardType: TextInputType.name,
              onChanged: (val){
                input = val;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("确认"),
                onPressed: () {
                  if(input != null) {
                    Navigator.of(context).pop(input);
                  }
                  else {
                    Toast.show("请输入二级分类", context, gravity: Toast.CENTER);
                  }
                },
              ),
            ],
          );
        }
    );

  }

  Future<Map> inputNewCategory1() { //添加一级分类的输入框
    Map input;
    String input1;
    String input2;
    return showDialog<Map> (
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("input new category1"),  //输入框标题
          content:Column(
            children: <Widget>[
              TextField(
                autofocus: true,
                maxLines: 1, //最大行数
                decoration: InputDecoration(
                    labelText: "一级分类",  //输入框标题
                    prefixIcon: Icon(Icons.add_box)  //输入框图标样式
                ),
                keyboardType: TextInputType.name,
                onChanged: (val){
                  input1 = val;
                  input2 = val;  //二级分类初始值为一级分类
                },
              ),
              TextField(
                autofocus: false,
                maxLines: 1, //最大行数
                decoration: InputDecoration(
                    labelText: "二级分类",  //输入框标题
                    prefixIcon: Icon(Icons.add_box)  //输入框图标样式
                ),
                keyboardType: TextInputType.name,
                onChanged: (val){
                  input2 = val;
                },
              ),

            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text("确认"),
              onPressed: () {
                if(input1 != null) {
                  input = {"$input1":["$input2"]};
                  Navigator.of(context).pop(input);
                }
                else {
                  Toast.show("请输入一级分类", context, gravity: Toast.CENTER);
                }

              },
            ),
          ],
        );
      },

    );
  }

  String removeBrackets(String value) {  //去除字符串两端的括号
    value = value.substring(1,value.length-1);
    return value;
  }

  String addBrackets(String value) {
    value = '(' + value + ')';
    return value;
  }


}
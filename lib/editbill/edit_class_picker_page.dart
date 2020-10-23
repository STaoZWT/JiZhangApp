import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/shared_pref.dart';
import 'package:toast/toast.dart';
import '../service/database.dart';

class editClassPicker extends StatefulWidget {
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

class editClassPickerArguments {
  //上一个页面传入的所有参数
  final String legacyClassPickerData;
  final String type;  //区分收入和支出的分类
  editClassPickerArguments(this.legacyClassPickerData, this.type);
}

class _editClassPicker extends State<editClassPicker> {
  List classList;
  String type;
  bool isChange;

  @override
  Future<void> initState() {
    super.initState();
    isChange = false;
  }

  @override
  Widget build(BuildContext context) {
    final editClassPickerArguments args =
        ModalRoute.of(context).settings.arguments;
    classList = (isChange == false)
        ? JsonDecoder().convert(args.legacyClassPickerData)
        : classList;
    type = args.type;
    String fileName = (type=="支出")?'mOutClassPicker':'mInClassPicker';

    return Scaffold(
      appBar: AppBar(
        title: Text("自定义分类"),
      ),
      body: new ListView.separated(
        //列举一级分类的list
        itemCount: classList.length,
        scrollDirection: Axis.vertical, //方向：垂直滑动
        itemBuilder: (context, index) {
          int category1Index = index;
          Map category1 = classList[index] as Map; //第index个一级分类和他的二级分类们
          String category1name =
              removeBrackets(category1.keys.toString()); //该一级分类的名字，去除括号！！！
          List category2 = category1[category1name]; //该一级分类下所有二级分类的list
          //print(category2[1]);
          return Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ExpansionTile(
              //一级分类的可收缩组件
              backgroundColor: Colors.white,
              //以下是一级分类的card
              title: Card(
                margin: EdgeInsets.all(5.0),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(14.0))),
                child:InkWell(
                    onTap: () async { //修改一级分类的操作
                      String newCategory1 = await inputNewCategory("一");
                      if (newCategory1 != null) {
                        bool isExist = false;
                        classList.forEach((element) {
                          //print("${newCategory1.keys}   ${(element as Map).keys}");
                          if (removeBrackets((element as Map).keys.toString()) == newCategory1) {
                            isExist = true; //判断修改的一级分类是否重复
                          }
                        });
                        if (isExist == true) {
                          Toast.show("该一级分类已存在", context);
                        }
                        else {
                          if(newCategory1 != category1name) {
                            isChange = true;
                            updateCategory1(category1name, newCategory1);  //数据库操作
                            //print(newCategory1);
                            var value = category1[category1name];
                            category1.putIfAbsent(newCategory1, () => value);
                            category1.remove(category1name);
                            classList[index] =category1;
                            //print(classList[index]);
                            setPicker(fileName, JsonEncoder().convert(classList));  //文件操作
                            setState(() { });
                          }
                        }
                      }



                    },
                    child: ListTile(
                      title: Text(
                        "$category1name",
                        style: TextStyle(color: Colors.black45, fontSize: 20), //一级分类字体颜色和大小
                      ),
                      leading: Icon(
                        Icons.apps,
                        color: Theme.of(context).primaryColor,
                      ),
                      trailing: Visibility(
                        visible: classList.length > 1, //
                        maintainInteractivity: false,
                        maintainSize: false,
                        child:IconButton( //删除一级分类按钮
                          icon: Icon(
                            Icons.delete_outline,  //删除按钮
                          ),
                          onPressed: () async {
                            bool isDelete = await deleteConfirm();
                            if(isDelete) {
                              isChange = true;
                              removeCategory1(category1name);
                              classList.removeAt(index);
                              setPicker(fileName, JsonEncoder().convert(classList));
                              setState(() { });
                            }

                          },
                        ),

                      ),
                ),
              ),
              ),

              initiallyExpanded: false,
              children: <Widget>[
                new ListView.builder(
                  //二级分类的list
                  shrinkWrap: true, //无限高度
                  itemCount: category2.length,
                  scrollDirection: Axis.vertical, //方向：垂直滑动
                  itemBuilder: (context, index) {
                    //以下是二级分类的card
                    return Card(
                      margin: EdgeInsets.all(5.0),
                      elevation: 5.0,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(14.0))),
                      child: InkWell(
                        onTap: () async { //修改二级分类的操作
                          String newCategory2 = await inputNewCategory("二");
                          if (newCategory2 != null) {
                            //print(category1[category1name]);
                            bool isExist = false;
                            category2.forEach((element) {
                              if (element == newCategory2) {
                                //二级分类查重
                                isExist = true;
                              }
                            });
                            if (isExist == true) {
                              Toast.show("该二级分类已存在", context);
                            } else {
                              isChange = true;
                              updateCategory2(category1name, category2[index], newCategory2); //数据库操作
                              category2[index] = newCategory2;//修改二级分类list
                              category1[category1name] = category2; //修改一级分类map
                              setPicker(fileName,
                                  JsonEncoder().convert(classList)); //文件操作
                              setState(() {});
                            }
                          }
                        },
                        child: ListTile(
                          title: Text("${category2[index]}"),
                          leading: Icon(
                            Icons.category,
                            color: Theme.of(context).primaryColor,
                          ),
                            trailing: Visibility(
                              visible: !(classList.length==1 && category2.length==1),
                              maintainInteractivity: false,
                              maintainSize: false,
                              child:IconButton( //删除二级分类按钮
                                icon: Icon(
                                  Icons.delete,
                                ),
                                onPressed: () async {
                                  bool isDelete = await deleteConfirm();
                                  print(category2[index]);
                                  if(isDelete) {
                                    isChange = true;
                                    print("($category1name)");
                                    print("(${category2[index]})");
                                    removeCategory2(category1name, category2[index] );
                                    category2.removeAt(index);
                                    if(category2.length==0) {  //如果某一级分类下没有二级分类，就会被删除
                                      removeCategory1(category1name);
                                      classList.removeAt(category1Index);
                                    }
                                    setPicker(fileName, JsonEncoder().convert(classList));
                                    setState(() { });
                                  }
                                },
                              ),
                            )
                        ),
                      ),
                    );

                  },
                ),
                new Padding(
                  //二级分类添加按钮
                  padding: new EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                  child: new Row(
                    children: <Widget>[
                      new OutlineButton.icon(
                        icon: Icon(Icons.add),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)), //圆角矩形
                        label: Text("添加二级分类",
                            style: TextStyle(color: Colors.black45, fontSize: 15),
                        ),
                        onPressed: () async {
                          String newCategory2 = await inputNewCategory("二");
                          if (newCategory2 != null) {
                            //print(category1[category1name]);
                            bool isExist = false;
                            category2.forEach((element) {
                              if (element == newCategory2) {
                                //二级分类查重
                                isExist = true;
                              }
                            });
                            if (isExist == true) {
                              Toast.show("该二级分类已存在", context);
                            } else {
                              setState(() {
                                category2.add(newCategory2);
                                category1[category1name] = category2;
                                print(category1);
                                print(classList[index]);
                                print(JsonEncoder().convert(classList));
                                isChange = true;
                                setPicker(fileName,
                                    JsonEncoder().convert(classList));
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
      floatingActionButton: FloatingActionButton(
          //添加一级分类
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            Map newCategory1 = await inputNewCategory1();
            //print(newCategory1);
            if (newCategory1 != null) {
              bool isExist = false;
              classList.forEach((element) {
                //print("${newCategory1.keys}   ${(element as Map).keys}");
                if ((element as Map).keys.toString() ==
                    newCategory1.keys.toString()) {
                  isExist = true; //判断新增一级分类是否重复
                }
              });
              if (isExist == true) {
                Toast.show("该一级分类已存在", context);
              } else {
                setState(() {
                  classList.add(newCategory1);
                  print(classList.last);
                  isChange = true;
                  setPicker(fileName, JsonEncoder().convert(classList));
                });
              }
            }
          }),
    );
  }

  Future<String> inputNewCategory(String text) {
    //添加/修改一/二级分类的输入框
    String input;
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("输入$text级分类"), //输入框标题
            content: TextField(
              autofocus: true,
              maxLines: 1, //最大行数
              decoration: InputDecoration(
                  labelText: "$text级分类", //输入框标题
                  prefixIcon: Icon(Icons.add_box), //输入框图标样式
                  hintText: "不大于6个字符",
                  ),
              keyboardType: TextInputType.name,
              onChanged: (val) {
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
                  if (input == "未选择") {Toast.show("名称不可用", context, gravity: Toast.CENTER);}
                  else if (input.length > 0 && input.length < 7) {
                    Navigator.of(context).pop(input);
                  } else if(input.length == 0) {
                    Toast.show("请输入$text级分类", context, gravity: Toast.CENTER);
                  }
                  else {
                    Toast.show("名称长度过长", context, gravity: Toast.CENTER);
                  }
                },
              ),
            ],
          );
        });
  }

  Future<Map> inputNewCategory1() {
    //添加一级分类的输入框
    Map input;
    String input1;
    String input2;
    return showDialog<Map>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("输入一级分类"), //输入框标题
          content: Column(
            children: <Widget>[
              TextField(
                autofocus: true,
                maxLines: 1, //最大行数
                decoration: InputDecoration(
                    labelText: "一级分类", //输入框标题
                    prefixIcon: Icon(Icons.add_box),  //输入框图标样式
                    hintText: "不大于6个字符",
                    ),
                keyboardType: TextInputType.name,
                onChanged: (val) {
                  input1 = val;
                  input2 = val; //二级分类初始值为一级分类
                },
              ),
              TextField(
                autofocus: false,
                maxLines: 1, //最大行数
                decoration: InputDecoration(
                    labelText: "二级分类", //输入框标题
                    prefixIcon: Icon(Icons.add_box), //输入框图标样式
                    hintText: "不大于6个字符",
                    ),
                keyboardType: TextInputType.name,
                onChanged: (val) {
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
                if (input1 == "未选择" || input2 == "未选择") {Toast.show("名称不可用", context, gravity: Toast.CENTER);}
                if (input1.length > 0 && input1.length < 7 && input2.length < 7) {
                  input = {
                    "$input1": ["$input2"]
                  };
                  Navigator.of(context).pop(input);
                } else if(input1.length == 0){
                  Toast.show("请输入一级分类", context, gravity: Toast.CENTER);
                }
                else {
                  Toast.show("名称长度过长", context, gravity: Toast.CENTER);
                }
              },
            ),
          ],
        );
      },
    );
  }


  Future<bool> deleteConfirm() {  //删除确认框
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示"),
            content:Text(
              "删除分类会删除其下的流水，且删除后将无法恢复，您确定删除所选分类？",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: Text("确认"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
    );
  }
  //从数据库中删除一级分类相关的流水
  removeCategory1 (String category1) async {
    await BillsDatabaseService.db.deleteCategory1InDB(category1);
  }
  //从数据库中删除二级分类相关的流水
  removeCategory2 (String category1, String category2) async {
    await BillsDatabaseService.db.deleteCategory2InDB(category2, category1);
  }
  //修改一级分类
  updateCategory1(String category1old, String category1new) async {
    await BillsDatabaseService.db.updateCategory1InDB(category1old, category1new);
  }
  //修改二级分类
  updateCategory2(String category1, String category2old, String category2new) async {
    await BillsDatabaseService.db.updateCategory2InDB(category2old, category2new, category1);
  }

  String removeBrackets(String value) {
    //去除字符串两端的括号
    value = value.substring(1, value.length - 1);
    return value;
  }

  String addBrackets(String value) {
    value = '(' + value + ')';
    return value;
  }
}

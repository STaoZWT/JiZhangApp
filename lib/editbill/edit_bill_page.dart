import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';
import '../const/picker_data.dart';
import '../service/shared_pref.dart';
import 'edit_account_picker_page.dart';
import 'edit_class_picker_page.dart';
import 'edit_member_picker_page.dart';
import 'package:date_format/date_format.dart';
import '../service/database.dart';
import '../data/model.dart';
import 'package:toast/toast.dart';
import '../homepage.dart';

class CardAddBill extends StatefulWidget {
  @override
  _CardAddBill createState() => _CardAddBill();
}

class _CardAddBill extends State<CardAddBill>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Tab> tabs = [
    Tab(text: "收入"),
    Tab(text: "支出"),
    Tab(text: "转账"),
  ];

  int moneyInput;
  DateTime dateSelect;
  String classPickerData; //分类picker的所有选项
  List classSelect; //用户选择的分类
  String classSelectText;

  String accountPickerData; //账户picker的所有选项
  List accountSelectIn; //用户选择的账户
  List accountSelectOut;
  String accountInSelectText;
  String accountOutSelectText;

  String memberPickerData; //成员picker的所有选项
  List memberSelect; //用户选择的成员
  String memberSelectText;

  String remark; //备注
  int type;

  BillsModel currentbill;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    moneyInput = 0;
    dateSelect = DateTime.now();
    classSelect = [0, 0];
    accountSelectOut = [0];
    accountSelectIn = [0];
    memberSelect = [0];
    classSelectText = "未选择";
    accountInSelectText = "未选择";
    accountOutSelectText = "未选择";
    memberSelectText = "未选择";
    remark = " ";
    type = 0;
    currentbill = BillsModel(
      title: "",
      date: DateTime.now(),
      type: 0,
      accountIn: "现金",
      accountOut: "现金",
      category1: "食品酒水",
      category2: "早午晚餐",
      member: "本人"
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          billConfirm();
        },
        label:
            //   Text(
            //     "完成",
            //   style: TextStyle(
            //     fontSize: 22
            //   ),
            // ),
            //   icon:
            Icon(
          Icons.check,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("新建记账"),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: tabs.map((Tab tab) {
            //final String tabType = tab.text.toString();
            String accountTitle = accountTitleController(tab.text);
            //type = (tab.text=="收入")?0:(tab.text=="支出")?1:2;  //1:收入 2：支出 3：转账
            _tabController.addListener(() {

              if (!_tabController.indexIsChanging) {
                setState(() {
                  var index = _tabController.index;
                  print("index : $index");
                  currentbill.type = index;
                  print("cu.type: ${currentbill.type}");
                  type = index;
                  print("type: $type");
                });
              }
            });
            return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    //以下输入金钱
                    Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 15.0,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.0))),
                      child: TextField(
                        autofocus: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // labelText: "金额",
                          // labelStyle: TextStyle(
                          //   fontWeight: FontWeight.w300
                          // ),
                          hintText: "请输入金额 ",
                          hintStyle:
                              TextStyle(color: Colors.black12, fontSize: 24.0),
                          //prefixIcon: Icon(Icons.attach_money),
                          suffixText: " 元   ",
                          suffixStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: Colors.blue,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 42.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          //wordSpacing: 1.5,
                          height: 1.5,
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          MoneyInputFormatter(),
                          LengthLimitingTextInputFormatter(11)
                          //WhitelistingTextInputFormatter(),
                          //FilteringTextInputFormatter.allow(RegExp("\^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,2})?\$"))
                        ],
                        onChanged: (money) {
                          print("$money");
                          moneyInput = (double.parse(money) * 100).round();
                          print("input money is: $moneyInput RMB fen");
                        },
                        textAlign: TextAlign.right,
                      ),
                    ),
                    //以下选择时间
                    Card(
                        margin: EdgeInsets.all(8.0),
                        elevation: 15.0,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.0))),
                        child: InkWell(
                          onTap: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2020, 5, 5, 20, 50),
                                maxTime: DateTime.now(), onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              setState(() {
                                dateSelect = date;
                              });
                              print('confirm $date');
                            }, locale: LocaleType.zh);
                          },
                          child: ListTile(
                            title: Text(
                              "日期",
                              style: TextStyle(color: Colors.black45),
                            ),
                            subtitle: Text(
                              formatDate(dateSelect,
                                  [yyyy, "年", m, "月", d, "日  ", H, ":", nn]),
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            leading: Icon(
                              Icons.date_range,
                              color: Colors.blue,
                            ),
                          ),
                        )),
                    //以下选择分类，账户，成员
                    Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 15.0,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.0))),
                      child: Column(
                        children: <Widget>[
                          //以下选择分类
                          InkWell(
                            onTap: () async {
                              classPickerData = await getPicker("mclassPicker");
                              if (classPickerData == null) {
                                await setPicker(
                                    "mclassPicker", ClassPickerData);
                                classPickerData =
                                    await getPicker("mclassPicker");
                              }
                              classPicker(context);
                            },
                            child: ListTile(
                              title: Text(
                                "分类",
                                style: TextStyle(color: Colors.black45),
                              ),
                              subtitle: Text(
                                "$classSelectText",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                ),
                              ),
                              leading: Icon(
                                Icons.apps,
                                color: Colors.blue,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                ),
                                onPressed: () async {
                                  classPickerData =
                                      await getPicker("mclassPicker");
                                  if (classPickerData == null) {
                                    await setPicker(
                                        "mclassPicker", ClassPickerData);
                                    classPickerData =
                                        await getPicker("mclassPicker");
                                  }
                                  Navigator.pushNamed(
                                      context, "/editClassPicker",
                                      arguments: editClassPickerArguments(
                                          classPickerData));
                                },
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.black26,
                          ),
                          //以下选择账户(转出账户)
                          InkWell(
                            onTap: () async {
                              accountPickerData =
                                  await getPicker("maccountPicker");
                              if (accountPickerData == null) {
                                await setPicker(
                                    "maccountPicker", AccountPickerData);
                                accountPickerData =
                                    await getPicker("maccountPicker");
                              }
                              accountPickerOut(context); //点击按钮弹出滚动选择框
                            },
                            child: ListTile(
                              title: Text(
                                accountTitle,
                                style: TextStyle(color: Colors.black45),
                              ),
                              subtitle: Text(
                                "$accountOutSelectText",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                ),
                              ),
                              leading: Icon(
                                Icons.account_balance_wallet,
                                color: Colors.blue,
                              ),
                              trailing: IconButton(
                                //这是对account picker进行编辑的按钮
                                icon: Icon(
                                  Icons.edit,
                                ),
                                onPressed: () async {
                                  accountPickerData =
                                      await getPicker("maccountPicker");
                                  if (accountPickerData == null) {
                                    await setPicker(
                                        "maccountPicker", AccountPickerData);
                                    accountPickerData =
                                        await getPicker("maccountPicker");
                                  }
                                  Navigator.pushNamed(
                                      context, "/editAccountPicker",
                                      arguments: editAccountPickerArguments(
                                          accountPickerData));
                                },
                              ),
                            ),
                          ),
                          //以下选择转入账户
                          Visibility(
                            visible: (tab.text == "转账"), //只有选择“转账”才会显示
                            maintainInteractivity: false,
                            maintainSize: false,
                            child: InkWell(
                              onTap: () async {
                                accountPickerData =
                                    await getPicker("maccountPicker");
                                if (accountPickerData == null) {
                                  await setPicker(
                                      "maccountPicker", AccountPickerData);
                                  accountPickerData =
                                      await getPicker("maccountPicker");
                                }
                                accountPickerIn(context); //点击按钮弹出滚动选择框
                              },
                              child: ListTile(
                                title: Text(
                                  "转入账户",
                                  style: TextStyle(color: Colors.black45),
                                ),
                                subtitle: Text(
                                  "$accountInSelectText",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.black26,
                          ),
                          //以下选择成员
                          InkWell(
                            onTap: () async {
                              memberPickerData =
                                  await getPicker("mmemberPicker");
                              if (memberPickerData == null) {
                                await setPicker(
                                    "mmemberPicker", MemberPickerData);
                                memberPickerData =
                                    await getPicker("mmemberPicker");
                              }
                              memberPicker(context);
                            },
                            child: ListTile(
                              title: Text(
                                "成员",
                                style: TextStyle(color: Colors.black45),
                              ),
                              subtitle: Text(
                                "$memberSelectText",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                ),
                              ),
                              leading: Icon(
                                Icons.account_circle,
                                color: Colors.blue,
                              ),
                              trailing: IconButton(
                                //这是对account picker进行编辑的按钮
                                icon: Icon(
                                  Icons.edit,
                                ),
                                onPressed: () async {
                                  memberPickerData =
                                      await getPicker("mmemberPicker");
                                  if (memberPickerData == null) {
                                    await setPicker(
                                        "mmemberPicker", MemberPickerData);
                                    memberPickerData =
                                        await getPicker("mmemberPicker");
                                  }
                                  Navigator.pushNamed(
                                      context, "/editMemberPicker",
                                      arguments: editMemberPickerArguments(
                                          memberPickerData));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //以下输入备注
                    Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 15.0,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.0))),
                      child: TextField(
                        autofocus: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "备注",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                          ),
                          hintText: "请输入备注 ",
                          hintStyle:
                              TextStyle(color: Colors.black12, fontSize: 15.0),
                          //prefixIcon: Icon(Icons.attach_money),
                          //suffixText: " 元   ",
                          suffixStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          prefixIcon: Icon(
                            Icons.border_color,
                            color: Colors.blue,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          //wordSpacing: 1.5,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        onChanged: (input) {
                          //print("$money");
                          remark = input;
                          //print("input money is: $moneyInput RMB fen");
                        },
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ));
          }).toList()),
    );
  }

  classPicker(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata:
                JsonDecoder().convert(classPickerData)), //json:string to list
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            //页面刷新，显示出用户的选项
            classSelect = value;
            classSelectText = removeBrackets(picker.adapter.text);//用户选中的分类
            print(classSelectText.split(",")[0]);
          });
          //print(JsonDecoder().convert(ClassPickerData));
          //print(picker.adapter.text);
        }).showModal(this.context); //_scaffoldKey.currentState);
  }

  accountPickerOut(BuildContext context) {
    List accountPickerDataTemp = JsonDecoder()
        .convert(accountPickerData);
    accountPickerDataTemp.remove(accountInSelectText);
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: accountPickerDataTemp), //传入可选项，json:string to list
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            accountSelectOut = value;
            accountOutSelectText = removeBrackets(picker.adapter.text) ;//用户选中的账户
          });
          print(value.toString());
          print(picker.adapter.text);
        }).showModal(this.context); //_scaffoldKey.currentState);
  }

  //选择转入账户
  accountPickerIn(BuildContext context) {
    List accountPickerDataTemp = JsonDecoder()
        .convert(accountPickerData);
    accountPickerDataTemp.remove(accountOutSelectText);
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: accountPickerDataTemp), //传入可选项，json:string to list
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            accountSelectIn = value;
            accountInSelectText = removeBrackets(picker.adapter.text);//用户选中的账户
          });
          print(value.toString());
          print(picker.adapter.text);
        }).showModal(this.context); //_scaffoldKey.currentState);
  }

  //选择成员
  memberPicker(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: JsonDecoder()
                .convert(memberPickerData)), //传入可选项，json:string to list
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            memberSelect = value;
            memberSelectText = removeBrackets(picker.adapter.text);//用户选中的成员
          });
          print(value.toString());
          print(picker.adapter.text);
        }).showModal(this.context);
  }

  String accountTitleController(String type) {
    if (type == "转账") {
      return "转出账户";
    } else {
      return "账户";
    }
  }

  void billConfirm () async {  //点击确认键的逻辑（数据合法性和写入数据库）
    print("金额：$moneyInput   分类：${classSelectText.split(",")[0]} ${classSelectText.split(",")[1]}");
    print("账户：$accountOutSelectText $accountInSelectText    成员：$memberSelectText");
    print("日期：$dateSelect   备注：$remark   记账类型：$type");
    if (moneyInput > 0 && classSelect!=null && accountSelectOut!=null){
      Toast.show("合法！ $moneyInput", context);
      currentbill.title = remark;
      currentbill.date = dateSelect;
      currentbill.type = type;
      currentbill.accountIn = accountInSelectText;
      currentbill.accountOut = accountOutSelectText;
      currentbill.category1 = classSelectText.split(",")[0];
      currentbill.category2 = classSelectText.split(",")[1];
      currentbill.member = memberSelectText;
      currentbill.value100 = moneyInput;
      //var bill =
      await BillsDatabaseService.db.addBillInDB(currentbill);
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      Toast.show("不合法！", context);
    }
  }

  String removeBrackets(String value) {  //去除字符串两端的括号
    value = value.substring(1,value.length-1);
    return value;
  }
}

//限制金额只能输入符合规格的格式
class MoneyInputFormatter extends TextInputFormatter {
  static final RegExp regExp =
      RegExp("\^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,2})?\$");
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // TODO: implement formatEditUpdate
    return oldValue.text.length > newValue.text.length ||
            regExp.hasMatch(newValue.text.toString())
        ? newValue
        : oldValue;
    //
  }
}

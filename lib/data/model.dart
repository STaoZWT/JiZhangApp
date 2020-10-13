
import 'dart:math';

//账单模板类
class BillsModel {
  int id; //id
  String title; //标题
  DateTime date; //日期
  int type; //类型（收入: 1/支出: 2/转账: 3）
  int accountIn; //账户,待改
  int accountOut;
  int category1; //一级分类
  int category2; //二级分类
  //bool hasMember; //是否有成员
  int member; //成员，待改
  int value100; //金额


  BillsModel({this.id, this.title, this.date, this.type, this.accountIn, this.accountOut, this.category1, this.category2, this.member, this.value100});


  //从Map读入
  BillsModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.title = map['title'];
    this.date = DateTime.parse(map['date']);
    this.type = map['type'];
    this.accountIn = map['accountIn'];
    this.accountOut = map['accountOut'];
    this.category1 = map['category1'];
    this.category2 = map['category2'];
    //this.hasMember = map['hasMember'] == 1 ? true : false;
    this.member = map['member'];
    this.value100 = map['value100'];

  }


  //输出为Map
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      '_id': this.id,
      'title': this.title,
      'date': this.date.toIso8601String(),
      'type': this.type,
      'accountIn': this.accountIn,
      'accountOut': this.accountOut,
      'catogory1': this.category1,
      'catogory2': this.category2,
      //'hasMember': this.hasMember == true ? 1 : 0,
      'member': this.member,
      'value100': this.value100

    };
  }

  //生成随机数据
  BillsModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
    this.title = 'Bills Test ' * (Random().nextInt(4) + 1);
    this.date = DateTime.now().add(Duration(hours: Random().nextInt(100)));
    this.type = Random().nextInt(3);
    this.accountIn = Random().nextInt(3);
    this.accountOut = Random().nextInt(3);
    this.category1 = Random().nextInt(3);
    this.category2 = Random().nextInt(3);
    //this.hasMember = Random().nextBool();
    this.member =  Random().nextInt(4)-1;
    this.value100 = Random().nextInt(10000);
  }
}

import 'dart:math';

//账单模板类
class BillsModel {
  int id; //id
  String title; //标题
  DateTime date; //日期
  int type; //类型（收入: 0/支出: 1/转账: 2）
  String accountIn; //账户,待改
  String accountOut;
  String category1; //一级分类
  String category2; //二级分类
  //bool hasMember; //是否有成员
  String member; //成员，待改
  int value100; //金额
  String merchant1; ///商家
  String merchant2;
  String project1; ///项目
  String project2;

  BillsModel(
      {this.id,
      this.title,
      this.date,
      this.type,
      this.accountIn,
      this.accountOut,
      this.category1,
      this.category2,
      this.member,
      this.value100,
      this.merchant1, ///
      this.merchant2,
      this.project1, ///
      this.project2,
      });

  //从Map读入
  BillsModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.title = map['title'];
    this.date = DateTime.fromMillisecondsSinceEpoch(map['date']);
    this.type = map['type'];
    this.accountIn = map['accountIn'];
    this.accountOut = map['accountOut'];
    this.category1 = map['category1'];
    this.category2 = map['category2'];
    //this.hasMember = map['hasMember'] == 1 ? true : false;
    this.member = map['member'];
    this.value100 = map['value100'];
    this.merchant1 = map['merchant1']; ///
    this.merchant2 = map['merchant2'];
    this.project1 = map['project1']; ///
    this.project2 = map['project2'];
  }

  //输出为Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'title': this.title,
      'date': this.date.millisecondsSinceEpoch,
      'type': this.type,
      'accountIn': this.accountIn,
      'accountOut': this.accountOut,
      'category1': this.category1,
      'category2': this.category2,
      //'hasMember': this.hasMember == true ? 1 : 0,
      'member': this.member,
      'value100': this.value100,
      'merchant1': this.merchant1, ///
      'merchant2': this.merchant2,
      'project1': this.project1,
      'project2': this.project2 ///
    };
  }

  //生成随机数据
  BillsModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
    this.title = 'Bills Test ' + (Random().nextInt(10000) + 1).toString();
    this.date = DateTime.now().subtract(Duration(hours: Random().nextInt(100)));
    this.type = Random().nextInt(3);
    this.accountIn = 'accountIn ' + (Random().nextInt(3)).toString();
    this.accountOut = 'accountOut ' + (Random().nextInt(3)).toString();
    this.category1 = 'Category1 ' + (Random().nextInt(3)).toString();
    this.category2 = 'Category2 ' + (Random().nextInt(3)).toString();
    //this.hasMember = Random().nextBool();
    this.member =  'Member ' + (Random().nextInt(3)).toString();
    this.value100 = Random().nextInt(10000);
    this.merchant1 = 'merchant1 ' + (Random().nextInt(3)).toString(); ///
    this.merchant2 = 'merchant2 ' + (Random().nextInt(3)).toString();
    this.project1 = 'project1 ' + (Random().nextInt(3)).toString();
    this.project2 = 'project2 ' + (Random().nextInt(3)).toString();
  }
}

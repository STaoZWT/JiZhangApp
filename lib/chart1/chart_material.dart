import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/data/model.dart';


///处理后的数据
///按类别（账户、二级类别、成员）（收入、支出）查询

class PieData{
  String name;// 名称
  Color color;// 颜色
  num percentage;//百分比
  double price;//成交额

  PieData(this.color,this.percentage,this.name,this.price);
}

class LiushuiData{
  int id;//id
  String c1c2mc;//类别
  DateTime date; //日期
  int value; //金额
  bool show;
  int type; //1收入，2支出
  String category2;
  LiushuiData(this.id, this.c1c2mc,this.date,this.type,this.value,this.show,this.category2);
}

class LsdataTime{
  DateTime time;
  List<LiushuiData> data;
  String c1c2mc;//类别

  LsdataTime(this.time, this.data, this.c1c2mc);
}

timeEqual(DateTime time1, DateTime time2){
  if(time1.year==time2.year &&  // 同一天
     time1.month==time2.month &&
     time1.day==time2.day){
    return true;
  }else{
    return false;
  }
}


//checked选择查看哪一部分
//typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
//type 0:收入， 1：支出
List getLiuData(List<BillsModel> data, String checked, String typeSelect, int type){
  List<LiushuiData> liuData = [];
  LiushuiData dataNow;
  if(data.length<=0 || data.length==null){
    return null;
  }
  for(int i=0;i<data.length;i++){
    if(data[i].type==type){
        if(typeSelect=='一级分类'){
          if((checked)==data[i].category1){
            dataNow = new LiushuiData(data[i].id, data[i].category1, data[i].date, data[i].type,
                data[i].value100, false, data[i].category2);
            print(dataNow);
            liuData.add(dataNow);
          }
        }else if(typeSelect=='二级分类'){
          if((checked)==data[i].category2){
            dataNow = new LiushuiData(data[i].id, data[i].category2, data[i].date, data[i].type,
                data[i].value100, false, data[i].category2);
            liuData.add(dataNow);
          }
        }else if(typeSelect=='成员分类'){
          if((checked)==data[i].member){
            dataNow = new LiushuiData(data[i].id, data[i].member, data[i].date, data[i].type,
                data[i].value100, false, data[i].category2);
            liuData.add(dataNow);
          }
        }else if(typeSelect=='账户分类'){
          if((checked)==data[i].accountOut){
            dataNow = new LiushuiData(data[i].id, data[i].accountOut, data[i].date, data[i].type,
                data[i].value100, false, data[i].category2);
            liuData.add(dataNow);
          }
        }
      }
  }
  //print(liuData);
  /*List<LsdataTime> dataTime;
  dataTime = dataSortTime(liuData);*/
  return liuData;
}

  List<Color> colorListPie = [
    Color(0xffffcdd2),
    Color(0xffbbdefb),
    Color(0xffcb9ca1),
    Color(0xff80cbc4),
    Color(0xff4f9a94),///5
    Color(0xff8aacc8),
    Color(0xff009faf),
    Color(0xffdce775),
    Color(0xff7c8500),
    Color(0xffa7c0cd),///10
    Color(0xff8d6e63),
    Color(0xffe57373),
    Color(0xffe2f1f8),
    Color(0xffffd0b0),
    Color(0xffffa06d),///15
    Color(0xffffecb3),
    Color(0xffc5e1a5),
    Color(0xff4ba3c7),
    Colors.blueGrey,
    Color(0xffa7c0ff),///20
  ];

double formatNum(double num,int postion){
  if((num.toString().length-num.toString().lastIndexOf(".")-1)<postion){
    //小数点后有几位小数
    String str = num.toStringAsFixed(postion).substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    return double.parse(str);
  }else{
    String str = num.toString().substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    return double.parse(str);
  }
}


  //按一级分类统计
    //收入
    //支出
  //按二级分类统计
    //收入
    //支出
  //按成员分类统计
    //收入
    //支出
  //按账户分类统计（选做）
    //收入
    //支出

  //typeSelect 1:一级分类，2：二级分类，3：成员，4：账户
  //type 0:收入， 1：支出
  List<PieData> statisticsPie(List<BillsModel> data, String typeSelect, int type){
    double allPrice = 0;
    var dataPie = new List<PieData>();
    var dataPieFull = new List<PieData>();
    var datanow;
    int flag = 0; //是否已经记录

    for(int i=0;i<data.length;i++){
      if(typeSelect=='一级分类'){ //category1: 1~n
        if(type==data[i].type){
          for(int j=0;j<dataPie.length;j++){ //遍历
            if(dataPie[j].name==data[i].category1){ //已经添加该名字
              dataPie[j].price = dataPie[j].price + data[i].value100/100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new PieData(colorListPie[i], 0.00, data[i].category1, data[i].value100 /100);
            dataPie.add(datanow);
          }
          flag = 0;
          allPrice = allPrice + (data[i].value100)/100;
        }
      }else if(typeSelect=='二级分类'){ //category2: 1~n
        if(type==data[i].type){
          for(int j=0;j<dataPie.length;j++){ //遍历
            if(dataPie[j].name==data[i].category2){ //已经添加该名字
              dataPie[j].price = dataPie[j].price + data[i].value100/100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new PieData(colorListPie[i], 0.00, data[i].category2, data[i].value100 /100);
            print(data[i].category2);
            dataPie.add(datanow);
            flag = 0;
          }
          flag = 0;
          allPrice = allPrice + (data[i].value100)/100;
        }
      }else if(typeSelect=='成员分类'){ //member: 1~n
        if(type==data[i].type){
          for(int j=0;j<dataPie.length;j++){ //遍历
            if(dataPie[j].name==data[i].member){ //已经添加该名字
              dataPie[j].price = dataPie[j].price + data[i].value100/100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new PieData(colorListPie[i], 0.00, data[i].member, data[i].value100 /100);
            dataPie.add(datanow);
            flag = 0;
          }
          flag = 0;
          allPrice = allPrice + (data[i].value100)/100;
        }
      }else if(typeSelect=='账户分类'){ //账户
        if(type==data[i].type){
          for(int j=0;j<dataPie.length;j++){ //遍历
            if(dataPie[j].name==data[i].accountOut){ //已经添加该名字
              dataPie[j].price = dataPie[j].price + data[i].value100/100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new PieData(colorListPie[i], 0.00, data[i].accountOut, data[i].value100 /100);
            dataPie.add(datanow);
            flag = 0;
          }
          flag = 0;
          allPrice = allPrice + (data[i].value100)/100;
        }
      }
    }
    print(allPrice);
    if(allPrice!=0){ //不能除0
      for(int i=0;i<dataPie.length;i++)
      {
        dataPie[i].percentage = (dataPie[i].price) / allPrice;
      }
      for(int i=0;i<dataPie.length;i++){
        if(dataPie[i].percentage!=0){
          dataPieFull.add(dataPie[i]);
        }
      }
    }
    print(dataPieFull);
    //print(n);
    return dataPieFull; // 总数据
  }


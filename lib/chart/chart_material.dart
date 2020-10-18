import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/data/model.dart';


///处理后的数据
///按类别（账户、二级类别、成员）（收入、支出）查询
class BarData {
  String category; //类别（账户、二级类别、成员）（收入、支出）
  int sales; //对应金额
  charts.Color color; //对应颜色

  BarData(this.category, this.sales, this.color);
}

class PieData{
  String name;// 名称
  Color color;// 颜色
  num percentage;//百分比
  var price;//成交额

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
  return liuData;
}

  List<Color> colorListPie = [
    Colors.blue,
    Colors.green,
    Colors.indigo,
    Colors.redAccent,
    Colors.cyan,
    Colors.purple,
    Colors.yellowAccent
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

  /*List<String> colorListBar = ['0xFF00FF00','0xFFFF7F00','0xFFFFFF00','0xFFD26699','0xFF7F7F7F',
    '0xFF0000FF','0xffCD00CD'];*/

  /*List colorListBar = [
      Color(0xFF00FF00),
      Color(0xFFFF7F00),
      Color(0xFFFFFF00),
      Color(0xFFD26699),
      Color(0xFF7F7F7F),
      Color(0xFF0000FF),
      Color(0xffCD00CD)
  ];*/

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
  List<PieData> statisticsPie(List<BillsModel> data, String typeSelect, int type){//, List<String> member, List<String> account){ //饼状图
    int n = 0; ///n<8
    int allPrice = 0;
    var dataPie = new List<PieData>();
    var dataPieFull = new List<PieData>();
    var datanow;
    int flag = 0; //是否已经记录
    //print("传入数据为：");
    //print(data);
    if(data.length<=0 || data.length==null){ //总的数据集为空
      return null;
    }
    print(data.length);
    for(int i=0; i<data.length; i++) {
      print('next');
      print(data[i].type);
      print(data[i].category2);
      print(data[i].value100);
      print(data[i].category1);
    }//print(data[i]);
    //初始化
    /*if(typeSelect=='一级分类'){ //category1: 1~n
      datanow = new PieData(colorListPie[0], 0.0, data[0].category1, data[0].value100);
    }else if(typeSelect=='二级分类'){ //category2: 1~n
      datanow = new PieData(colorListPie[0], 0.0, data[0].category2, data[0].value100);
    }else if(typeSelect=='成员分类'){ //member: 1~n
      datanow = new PieData(colorListPie[0], 0.0, data[0].member, data[0].value100);
    }else if(typeSelect=='账户分类'){ //账户
      datanow = new PieData(colorListPie[0], 0.0, data[0].accountOut, data[0].value100);
    }
    allPrice = allPrice + data[0].value100;
    dataPie.add(datanow);*/
    for(int i=0;i<data.length;i++){
      if(typeSelect=='一级分类'){ //category1: 1~n
        if(type==data[i].type){
          for(int j=0;j<dataPie.length;j++){ //遍历
            if(dataPie[j].name==data[i].category1){ //已经添加该名字
              dataPie[j].price = dataPie[j].price + data[i].value100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new PieData(colorListPie[i], 0.0, data[i].category1, data[i].value100);
            dataPie.add(datanow);
            flag = 0;
          }
          allPrice = allPrice + data[i].value100;
        }
      }else if(typeSelect=='二级分类'){ //category2: 1~n
        if(type==data[i].type){
          for(int j=0;j<dataPie.length;j++){ //遍历
            if(dataPie[j].name==data[i].category2){ //已经添加该名字
              dataPie[j].price = dataPie[j].price + data[i].value100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new PieData(colorListPie[i], 0.0, data[i].category2, data[i].value100);
            print(data[i].category2);
            dataPie.add(datanow);
            flag = 0;
          }
          allPrice = allPrice + data[i].value100;
        }
      }else if(typeSelect=='成员分类'){ //member: 1~n
        if(type==data[i].type){
          for(int j=0;j<dataPie.length;j++){ //遍历
            if(dataPie[j].name==data[i].member){ //已经添加该名字
              dataPie[j].price = dataPie[j].price + data[i].value100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new PieData(colorListPie[i], 0.0, data[i].member, data[i].value100);
            dataPie.add(datanow);
            flag = 0;
          }
          allPrice = allPrice + data[i].value100;
        }
      }else if(typeSelect=='账户分类'){ //账户
        if(type==data[i].type){
          for(int j=0;j<dataPie.length;j++){ //遍历
            if(dataPie[j].name==data[i].accountOut){ //已经添加该名字
              dataPie[j].price = dataPie[j].price + data[i].value100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new PieData(colorListPie[i], 0.0, data[i].accountOut, data[i].value100);
            dataPie.add(datanow);
            flag = 0;
          }
          allPrice = allPrice + data[i].value100;
        }
      }
    }
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

  //条形图
  ///bug如果sales整数？？？？？
  List<BarData> statisticsBar(List<BillsModel> data, String typeSelect, int type){ //条形图
    var dataBar = new List<BarData>();
    var dataBarFull = new List<BarData>();
    BarData datanow;
    int flag = 0; //是否已经记录
    if(data.length<=0 || data.length==null){ //总的数据集为空
      return null;
    }
    print('data');
    print(data);
    for(int i=0;i<data.length;i++){
      if(type==data[i].type){
        if(typeSelect=='一级分类'){ //category1
          for(int j=0;j<dataBar.length;j++){ //遍历
            if(dataBar[j].category==data[i].category1){ //已经添加该名字
              dataBar[j].sales = dataBar[j].sales + data[i].value100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new BarData(data[i].category1, data[i].value100, charts.ColorUtil.fromDartColor(colorListPie[i]));
            dataBar.add(datanow);
            flag = 0;
          }
          //allPrice = allPrice + data[i].value100;
        }else if(typeSelect=='二级分类'){ //category2: 1~n
          for(int j=0;j<dataBar.length;j++){ //遍历
            if(dataBar[j].category==data[i].category2){ //已经添加该名字
              dataBar[j].sales = dataBar[j].sales + data[i].value100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new BarData(data[i].category2, data[i].value100, charts.ColorUtil.fromDartColor(colorListPie[i]));
            dataBar.add(datanow);
            flag = 0;
          }
          //allPrice = allPrice + data[i].value100;
        }else if(typeSelect=='成员分类'){ //member: 1~n
          for(int j=0;j<dataBar.length;j++){ //遍历
            if(dataBar[j].category==data[i].member){ //已经添加该名字
              dataBar[j].sales = dataBar[j].sales + data[i].value100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new BarData(data[i].member, data[i].value100, charts.ColorUtil.fromDartColor(colorListPie[i]));
            dataBar.add(datanow);
            flag = 0;
          }
          //allPrice = allPrice + data[i].value100;
        }else if(typeSelect=='账户分类'){ //账户
          for(int j=0;j<dataBar.length;j++){ //遍历
            if(dataBar[j].category==data[i].accountOut){ //已经添加该名字
              dataBar[j].sales = dataBar[j].sales + data[i].value100;
              flag = 1;
              break;
            }
          }
          if(flag==0){//不存在
            datanow = new BarData(data[i].accountOut, data[i].value100, charts.ColorUtil.fromDartColor(colorListPie[i]));
            dataBar.add(datanow);
            flag = 0;
          }
          //allPrice = allPrice + data[i].value100;
        }
      }
    }
    if(dataBar.length<=0 || dataBar.length==null){
      return null;
    }
    for(int i=0;i<dataBar.length;i++){
      dataBar[i].sales = ((dataBar[i].sales)/100).round(); ///只能整数
      if(dataBar[i].sales!=0){
        dataBarFull.add(dataBar[i]);
      }
    }
    print("结果为：");
    print(dataBarFull);
    return dataBarFull;
  }



/*
PieData p3 = new PieData();
    p3.name = 'C';
    p3.price = 'c';
    p3.percentage = 0.1132;
    p3.color = Color(0xffCD00CD);
    mData.add(p3);

    PieData p4 = new PieData();
    p4.name = 'D';
    p4.price = 'd';
    p4.percentage = 0.0868;
    p4.color = Color(0xffFFA500);
    mData.add(p4);

    PieData p5 = new PieData();
    p5.name = 'E';
    p5.price = 'e';
    p5.percentage = 0.18023;
    p5.color = Color(0xff40E0D0);
    mData.add(p5);

    PieData p6 = new PieData();
    p6.name = 'F';
    p6.price = 'f';
    p6.percentage = 0.12888;
    p6.color = Color(0xffFFFF00);
    mData.add(p6);

    PieData p7 = new PieData();
    p7.name = 'G';
    p7.price = 'g';
    p7.percentage = 0.0888;
    p7.color = Color(0xff00ff66);
    mData.add(p7);

    PieData p8 = new PieData();
    p8.name = 'H';
    p8.price = 'h';
    p8.percentage = 0.06;
    p8.color = Color(0xffD9D9D9);
    mData.add(p8);
 */
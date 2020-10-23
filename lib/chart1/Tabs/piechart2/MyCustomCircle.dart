import 'package:flutter/cupertino.dart';
import 'package:flutter_jizhangapp/chart1/Tabs/piechart2/myview.dart';
import 'package:flutter_jizhangapp/chart1/chart_material.dart';

///自定义  饼状图

class MyCustomCircle extends StatelessWidget{
  //数据源
  List<PieData> datas;

  //当前数据对象
  PieData data;
  var dataSize;

  //当前选中
  var currentSelect;

  MyCustomCircle(this.datas,this.data,this.currentSelect);

  choose(){
    if(datas==null){
      return CustomPaint(
          painter: MyView(null,null,null,true)
      );
    }
    if(datas.length<=0){
      return CustomPaint(
          painter: MyView(null,null,null,true)
      );
    }
    return CustomPaint(
        painter: MyView(datas,data,currentSelect,true)
    );
  }

  @override
  Widget build(BuildContext context) {
    return choose();
    /*CustomPaint(
        painter: MyView(datas,data,currentSelect,true)
    );*/
  }

}


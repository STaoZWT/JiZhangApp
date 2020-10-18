import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../chart_material.dart';


class MyView extends CustomPainter{

  //中间文字
  var text='Null';
  bool isChange=false;
  //当前选中的扇形
  var currentSelect=0;
  //画笔
  Paint _mPaint;
  Paint TextPaint;

  // 扇形大小
  int mWidth, mHeight;

  // 圆半径
  num mRadius, mInnerRadius,mBigRadius;

  // 扇形起始弧度（Andorid中是角度）
  num mStartAngle = 0;

  // 矩形（扇形绘制的区域）
  Rect mOval,mBigOval;

  // 扇形 数据
  List<PieData> mData;
  PieData pieData;

  // 构造函数，接受需要的参数值
  MyView(this.mData,this.pieData,this.currentSelect,this.isChange);

  /**
   * 重写 paint方法，在其中写绘制饼状图的逻辑
   */

  @override
  void paint(Canvas canvas, Size size) {
    // 初始化各类工具等
    _mPaint = new Paint();
    TextPaint = new Paint();
    mHeight=100;
    mWidth=100;

    /// 生成纵轴文字的TextPainter
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    // 文字画笔 风格定义
    TextPainter _newVerticalAxisTextPainter(String text) {
      return textPainter
        ..text = TextSpan(
          text: text,
          style: new TextStyle(
            color: Colors.black,
            fontSize: 24.0,
          ),
        );
    }

    // 正常半径
    mRadius = 100.0;

    //加大半径  用来绘制被选中的扇形区域
    mBigRadius=108.0;

    //內园半径
    mInnerRadius = mRadius * 0.41;

    // 未选中的扇形绘制的矩形区域
    mOval = Rect.fromLTRB(-mRadius, -mRadius, mRadius, mRadius);

    // 选中的扇形绘制的矩形区域
    mBigOval = Rect.fromLTRB(-mBigRadius, -mBigRadius, mBigRadius,
        mBigRadius);

    //当没有数据时 直接返回
    if (mData==null) {
      canvas.save();
      ///绘制逻辑与Android差不多
      // 将坐标点移动到View的中心
      canvas.translate(0.0, 0.0);
      double hudu = 1.0;
      //计算当前偏移量（单位为弧度）
      double sweepAngle = 2*pi*hudu;
      //画笔的颜色
      _mPaint..color = Colors.grey;
      // 绘制没被选中的扇形  正常半径
      canvas.drawArc(mOval, 0.0, sweepAngle, true, _mPaint);
      _mPaint..color = Colors.white;
      canvas.drawCircle(Offset.zero, mInnerRadius, _mPaint);
      canvas.restore();

      // NULL
      var texts1 ='NULL';
      var tp1 = _newVerticalAxisTextPainter(texts1)..layout();
      // Text的绘制起始点 = 可用宽度 - 文字宽度 - 左边距
      tp1.paint(canvas,  Offset(-(62.0 - tp1.width / 2), -11.0));
    }
    else{ //有数据
      ///绘制逻辑与Android差不多
      canvas.save();

      // 将坐标点移动到View的中心
      //canvas.translate(50.0, 50.0);
      canvas.translate(0.0, 0.0);

      // 1. 画扇形
      num startAngle = 0.0;

      for (int i = 0; i < mData.length; i++) {
        PieData p = mData[i];
        double hudu = p.percentage;
        //计算当前偏移量（单位为弧度）
        double sweepAngle = 2*pi*hudu;
        //画笔的颜色
        _mPaint..color = p.color;
        if(currentSelect>=0 && i==currentSelect){
          //如果当前为所选中的扇形 则将其半径加大  突出显示
          canvas.drawArc(mBigOval, startAngle, sweepAngle, true, _mPaint);
        }else{
          // 绘制没被选中的扇形  正常半径
          canvas.drawArc(mOval, startAngle, sweepAngle, true, _mPaint);
        }

        //计算每次开始绘制的弧度
        startAngle += sweepAngle;
      }

//    canvas.drawRect(mOval, _mPaint);  // 矩形区域

      // 2.画内圆

      _mPaint..color = Colors.white;
      canvas.drawCircle(Offset.zero, mInnerRadius, _mPaint);
      canvas.restore();

      //当前百分比值
      double percentage = pieData.percentage * 100;
      percentage = formatNum(percentage, 2);
      //print("percentage");
      //print(percentage);
      String name = pieData.name;
      /*// 绘制文字内容
    var texts ='$name: $percentage%';
    var tp = _newVerticalAxisTextPainter(texts)..layout();
    // Text的绘制起始点 = 可用宽度 - 文字宽度 - 左边距
    var textLeft = 35.0;
    //tp.paint(canvas, Offset(textLeft, 50.0 - tp.height / 2));
    tp.paint(canvas, Offset(-40.0, 40.0));*/

      // 百分比
      var texts1 ='$percentage%';
      var tp1 = _newVerticalAxisTextPainter(texts1)..layout();
      // Text的绘制起始点 = 可用宽度 - 文字宽度 - 左边距
      tp1.paint(canvas, Offset(-(75.0 - tp1.width / 2), -11.0));

      /*// 类别
      var texts2 ='$name';
      var tp2 = _newVerticalAxisTextPainter(texts2)..layout();
      // Text的绘制起始点 = 可用宽度 - 文字宽度 - 左边距
      //tp.paint(canvas, Offset(textLeft, 50.0 - tp.height / 2));
      tp2.paint(canvas, Offset((0.0 - tp2.width / 2), 120));*/
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}


/*int i = 0;
    while(i<mData.length)
    {
      PieData p = mData[i];
      double hudu=p.percentage;
      //计算当前偏移量（单位为弧度）
      double sweepAngle = 2*pi*hudu;
      //画笔的颜色
      _mPaint..color = p.color;
      if(currentSelect>=0 && i==currentSelect){
        //如果当前为所选中的扇形 则将其半径加大  突出显示
        canvas.drawArc(mBigOval, startAngle, sweepAngle, true, _mPaint);
      }else{
        // 绘制没被选中的扇形  正常半径
        canvas.drawArc(mOval, startAngle, sweepAngle, true, _mPaint);
      }

      //计算每次开始绘制的弧度
      startAngle += sweepAngle;

      i++;
      if(i==mData.length){i=0;}
    }*/

////toast: ^0.1.5
import 'package:flutter/material.dart';

class MaterialTapWidget extends StatelessWidget {
  final double radius; //圆角
  final Function onTap; //点击回调
  final Widget child; // 内部的控件
  final double elevation; //阴影"高度"
  final Color backgroundColor; //背景颜色
  final Color splashColor; // 点击的水波纹颜色
  final Function onLongTap; //长按提醒

  const MaterialTapWidget({
    Key key,
    this.radius = 10.0,
    this.onTap,
    this.onLongTap,
    @required this.child,
    this.splashColor,
    this.elevation = 0.0,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget w = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Material(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
        elevation: 0.0,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongTap,
          child: child,
        ),
      ),
    );

    if (this.splashColor != null) {
      return Theme(
        data: Theme.of(context).copyWith(splashColor: this.splashColor),
        child: w,
      );
    }

    return w;
  }
}

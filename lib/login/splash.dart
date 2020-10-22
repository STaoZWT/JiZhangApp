import 'package:flutter/material.dart';

import '../service/shared_pref.dart';
import 'login.dart';
import 'register.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;

  void IsNewUser() async {
    //String passwordInSp;
    // print('passwordInsp');
    print("set user flag");
    isPasswordSet().then((value) {
      value == false
          ? Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => RegisterPage()))
          : Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => LoginPage()));
    });
    // getPassWord().then((passwordInSp) {
    //   print('passwordInsp is');
    //   print(passwordInSp);
    //   passwordInSp == null
    //       ? null
    //       : Navigator.of(context).pushReplacement(MaterialPageRoute(
    //           builder: (BuildContext context) => LoginPage()));
    // });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 5000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    /* 动画事件监听器
    监听动画的执行状态，这里监听动画结束的状态，如果结束则执行页面跳转
     */
    _animation.addStatusListener((status){
      if (status == AnimationStatus.completed) {
        IsNewUser();
      }
    });
    // 播放动画
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition( // 透明动画组件
      opacity: _animation, // 执行动画
      child: Image.asset(
        'image/tupian.jpg',
        scale: 2.0, // 缩放
        fit: BoxFit.cover,  // 充满容器
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../homepage.dart';

class IntroductionScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _IntroductionScreenPageState();
  }
}

class _IntroductionScreenPageState extends State<IntroductionScreenPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacementNamed('home_screen');
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('image/$assetName.jpg', width: 10000.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 12.0);
    const pageDecoration =const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.transparent,
      imagePadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 30.0),
      imageFlex: 5,
      bodyFlex: 2
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "主页面",
          body:
          "在主页中可以查看本月记账情况和最近记账",
          image: _buildImage('homepage1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "记账页面",
          body:
          "在记账页面中可以分账户、记账类型、记账类别、记账成员进行个性化记账，还可以自定义记账类别。方便快捷",
          image: _buildImage('jizhang2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "统计页面",
          body:
          "在统计页面可以查看账户的具体信息，按年、月、季度查看统计信息。并且可以方便地查看流水",
          image: _buildImage('tongji3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "图表分析界面",
          body:
          "在图表分析页面可以查看不同类别的图标可视化统计信息",
          image: _buildImage('tubiao4'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "修改主题页面",
          body:
          "在修改主题页面可以选择喜欢的主题",
          image: _buildImage('theme6'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "清空数据页面",
          body:
          "在清空数据页面可以清空本地所有的数据，并且重启。使用这个功能需要谨慎哦！",
          image: _buildImage('qingkong7'),
          decoration: pageDecoration,
        ),

      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      curve: Curves.easeInCubic,
      skip: const Text('跳过'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('结束', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

}
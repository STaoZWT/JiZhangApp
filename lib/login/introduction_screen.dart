
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
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.lightBlueAccent,
      imagePadding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 30.0),
      imageFlex: 2,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "引导页1",
          body:
          "引导内容1",
          image: _buildImage('cat'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "引导页2",
          body:
          "引导内容2",
          image: _buildImage('cat'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "引导页3",
          body:
          "引导内容3",
          image: _buildImage('cat'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "引导页4",
          body:
          "引导内容4",
          image: _buildImage('cat'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          // title: "Title of last page",
          // bodyWidget: Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: const [
          //     Text("Click on ", style: bodyStyle),
          //     Icon(Icons.edit),
          //     Text(" to edit a post", style: bodyStyle),
          //   ],
          // ),
          // image: _buildImage('tupian'),
          // decoration: pageDecoration,
          title: "引导页1",
          body:
          "引导内容",
          image: _buildImage('tupian'),
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
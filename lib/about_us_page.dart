import 'package:flutter/material.dart';


class aboutUsPage extends StatefulWidget {
  const aboutUsPage({Key key}) : super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _aboutUsPage();
  }
}

class _aboutUsPage extends State<aboutUsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle:true,
        automaticallyImplyLeading:false,
        title: Text(
          "喵喵记(>^ω^<)",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("image/cat.jpg"),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.6), BlendMode.lighten))),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 16, bottom: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),  //卡片颜色
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(68.0)),
                    // boxShadow: <BoxShadow>[
                    //   BoxShadow(  //阴影参数
                    //       color: Colors.grey,
                    //       offset: Offset(1.1, 1.1),
                    //       blurRadius: 5.0),
                    // ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 24),
                        child:Text(
                          '欢迎使用喵喵记V1.0',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: -0.1,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                      Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 24),
                            child:Text(
                              '本项目GitHub地址：https://github.com/STaoZWT/JiZhangApp',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                //fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: Theme.of(context).accentColor.withOpacity(0.6)),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 24),
                            child:Text(
                              '项目组成员：\n'
                                  'STao: 数据库，记账功能，更换主题\n'
                                  '柴犬球: 记账功能，主页\n'
                                  'kangkang: 登录页，注册页，主页，新手指引\n'
                                  'Keyi Han: 图表统计，账户统计\n'
                                  'Xinyuan Zhao: 账户统计\n'
                              ,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                //fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: Theme.of(context).accentColor.withOpacity(0.6)),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 24),
                            child:Text(
                              '如果您有任何宝贵意见，可通过github反馈给我们\n'
                              '如果您喜欢我们的项目，请点亮star支持我们，非常感谢\n'
                              ,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                //fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: Theme.of(context).accentColor.withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),

                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

}
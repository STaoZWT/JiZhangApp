//import 'app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jizhangapp/service/shared_pref.dart';
import 'package:toast/toast.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key key, this.screenIndex, this.iconAnimationController, this.callBackIndex}) : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  String userName = 'User';
  
  int userProfileIndex;

  @override
  void initState() {
    userProfileIndex = 0;
    setDrawerListArray();
    super.initState();
  }

  //以下是侧边栏的选项卡内容
  void setDrawerListArray() async {
    print('1');
    userName = await getUserName();
    print('2');
    String tmp = await getPicker('mprofileIndex');
    if (tmp != null) {
      userProfileIndex = int.parse(tmp);
    }
    print('3');
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: '主页',  //名字
        icon: Icon(Icons.home), //图标
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: '修改文字密码',
        //isAssetsImage: true,
        icon: Icon(Icons.edit_attributes),
        //imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: '重置图形密码',
        icon: Icon(Icons.widgets),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: '修改主题',
        icon: Icon(Icons.color_lens),
      ),
      DrawerList(
        index: DrawerIndex.Share,
        labelName: '清空数据',
        icon: Icon(Icons.warning),
      ),
      DrawerList(
          index: DrawerIndex.About,
          labelName: '帮助',
          icon: Icon(Icons.warning),
      )
      // DrawerList(
      //   index: DrawerIndex.About,
      //   labelName: 'About Us',
      //   icon: Icon(Icons.info),
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
      //AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(begin: 0.0, end: 24.0)
                              .animate(CurvedAnimation(parent: widget.iconAnimationController, curve: Curves.fastOutSlowIn))
                              .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: Colors.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                              ],
                            ),
                            child: InkWell(
                              onTap: () async {
                                userProfileIndex = (userProfileIndex + 1) % 2;
                                setPicker('mprofileIndex', userProfileIndex.toString());
                                setState(() {

                                });
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                                child: userProfile[userProfileIndex],  //用户头像
                                //child: ,
                              ),
                            ),

                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: InkWell(
                      onTap: () {
                        String newName;
                        print("username: $userName");
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('更改用户名'),
                                content: Card(
                                  elevation: 0.0,
                                  child: TextField(
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      hintText: '请输入新用户名(10个字以内)',
                                      prefixIcon: Icon(Icons.keyboard),
                                    ),
                                    maxLines: 1,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                    onChanged: (inputName) {
                                      newName = inputName;
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('取消'),
                                  ),
                                  FlatButton(
                                    onPressed: ()  async {
                                      if (newName != null && newName.length != 0) {
                                        Toast.show("用户名修改成功！", context);
                                        userName = newName;
                                        await setUserName(newName);
                                        setState(() {});
                                        Navigator.pop(context);
                                      } else {
                                        Toast.show("新用户名不能为空！", context);
                                      }
                                    },
                                    child: Text('确定'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text(
                        '你好！$userName',  //填入用户名
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.6),
          ),
          // Column(
          //   children: <Widget>[
          //     ListTile(
          //       title: Text(
          //         'Sign Out',
          //         style: TextStyle(
          //           fontFamily: AppTheme.fontName,
          //           fontWeight: FontWeight.w600,
          //           fontSize: 16,
          //           color: AppTheme.darkText,
          //         ),
          //         textAlign: TextAlign.left,
          //       ),
          //       trailing: Icon(
          //         Icons.power_settings_new,
          //         color: Colors.red,
          //       ),
          //       onTap: () {},
          //     ),
          //     SizedBox(
          //       height: MediaQuery.of(context).padding.bottom,
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                    width: 24,
                    height: 24,
                    child: Image.asset(listData.imageName, color: widget.screenIndex == listData.index ? Theme.of(context).primaryColor : Color(0xFF213333)),
                  )
                      : Icon(listData.icon.icon, color: widget.screenIndex == listData.index ? Theme.of(context).primaryColor : Color(0xFF213333)),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index ? Theme.of(context).primaryColor : Color(0xFF213333),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
              animation: widget.iconAnimationController,
              builder: (BuildContext context, Widget child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      (MediaQuery.of(context).size.width * 0.75 - 64) * (1.0 - widget.iconAnimationController.value - 1.0), 0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75 - 64,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(28),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  FeedBack,
  Help,
  Share,
  About,
  Invite,
  Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}

List<Widget> userProfile = [
  Image.asset('assets/cat_user.png'),
  Image.asset('assets/cat_user1.png'),
];

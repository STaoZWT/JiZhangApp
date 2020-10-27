import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/service/shared_pref.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import '../ui/common_dialog.dart';

import '../homepage.dart';

class LoginPage extends StatefulWidget {
  final userNameGet;
  final theme;
  const LoginPage({
    Key key,
    @required this.userNameGet,
    this.theme,
  }):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var _PassWordController = TextEditingController();
  var registerPassWordController = TextEditingController();
  var registerUserNameController = TextEditingController();
  //用户名判断(10字以内，不为空)
  static bool isUserName(String input){
    if(input.length>0&&input.length<=10) return true;
    else {return false;}
  }
  //密码判断（8~18，数字和字符，正则判断式）
  static bool isLoginPassword(String input) {
    //RegExp mobile = new RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,18}$");
    RegExp mobile = new RegExp(r"[A-Za-z0-9]{8,18}$");
    return mobile.hasMatch(input);
  }

  //判断是否有设置图形密码
  void IsHaveGraphicalPw() async {
    print('GraphicalPwInsp');
    getGraphicalPassWord().then((GraphicalPasswordInSp) {
      print('GraphicalPwInsp is');
      print(GraphicalPasswordInSp);
      if (GraphicalPasswordInSp != null) {
        //Navigator.of(context).pop();
        Navigator.of(context).pushNamed('graphical_login');
      }else{
        CommonDialog.show(context, Text('没有设置图形密码'));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  FocusNode blankNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var localAuth = LocalAuthentication();
    return GestureDetector(
        onTap: () {
          print('tap here!');
      FocusScope.of(context).requestFocus(blankNode);
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                // image: AssetImage("image/cat.jpg"),
              image: AssetImage("assets/cat_user1.png"),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.darken))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "欢迎回来,",
                      style: TextStyle(
                          fontFamily: "SFUIText",
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),
                    ),
                    Text(
                      widget.userNameGet,
                      style: TextStyle(
                          fontFamily: "SFUIText",
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),
                    ),
                    SizedBox(
                      height: 250,
                    ),
                    Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                            ),
                            TextFormField(
                              controller: _PassWordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.lock),
                                  fillColor: Color(0xfff5f9f6),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    BorderSide(color: Colors.transparent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    BorderSide(color: Colors.transparent),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    BorderSide(color: Colors.transparent),
                                  ),
                                  hintText: "输入你的密码",
                                  hintStyle: TextStyle(
                                    fontFamily: "SFUIText",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black26,
                                  )),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            iconSize: 50,
                            onPressed: (){
                              IsHaveGraphicalPw();
                            },
                            icon: Icon(
                              Icons.apps,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 56,
                            width: 120,
                            child: RaisedButton(
                              onPressed: () async{
                                isPasswordValid(_PassWordController.value.text.toString()).then((value){
                                  if(value == true){
                                    Navigator.of(context).pushReplacementNamed('home_screen');
                                  }else{
                                    CommonDialog.show(context, Text('密码错误'));
                                  }
                                });
                              },
                              child: Text(
                                "登录",
                                style: TextStyle(
                                  fontFamily: "SFUIText",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          IconButton(
                            iconSize: 50,
                            onPressed: () async {
                              //下面是汉化
                              const andStrings = const AndroidAuthMessages(
                                cancelButton: '取消',
                                goToSettingsButton: '去设置',
                                fingerprintNotRecognized: '指纹识别失败',
                                goToSettingsDescription: '请设置指纹.',
                                fingerprintHint: '指纹',
                                fingerprintSuccess: '指纹识别成功',
                                signInTitle: '指纹验证',
                                fingerprintRequiredTitle: '请先录入指纹!',
                              );

                              try {
                                bool didAuthenticate;
                                await localAuth.authenticateWithBiometrics(
                                    localizedReason:
                                    '扫描指纹进行身份识别',
                                    useErrorDialogs: true,
                                    stickyAuth: true,
                                    androidAuthStrings: andStrings
                                ).then((didAuthenticate){
                                  didAuthenticate==true? Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
                                          (route) => route==null
                                  ):print("false");
                                });
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: Icon(
                              Icons.fingerprint,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Center(
                  child: Padding(padding: EdgeInsets.only(top: 290),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/cat_picture.png"),
                      radius: 60,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
}

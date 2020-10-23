import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/service/shared_pref.dart';
import 'package:flutter_jizhangapp/ui/comman_dialog.dart';

import '../homepage.dart';
import 'graphical_password_login.dart';

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
  //final _formkey = GlobalKey<FormState>();
  var _PassWordController = TextEditingController();
  var registerPassWordController = TextEditingController();
  var registerUserNameController = TextEditingController();
  //String userNameGet='set';
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
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => GraphicalPasswordLoginPage()));
      }else{
        CommonDialog.show(context, Text('没有设置图形密码'));
      }
    });
  }

  //获取用户名
  // void getName() async{
  //   userNameGet = await getUserName();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getName();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("image/tupian.jpg"),
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
                            // Center(
                            //     child: Text(
                            //       "Forgot Password?",
                            //       style: TextStyle(
                            //         fontFamily: "SFUIText",
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.bold,
                            //         color: Color(0xff1bbdc4),
                            //       ),
                            //     )
                            // ),
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
                        // SizedBox(
                        //   height: 56,
                        //   width: 120,
                        //   child: RaisedButton(
                        //     onPressed: () {},
                        //     child: Text(
                        //       "Sign up",
                        //       style: TextStyle(
                        //         fontFamily: "SFUIText",
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold,
                        //         color: Color(0xff293036),
                        //       ),
                        //     ),
                        //     color: Colors.white,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8)),
                        //   ),
                        // ),
                        IconButton(
                          iconSize: 50,
                          onPressed: (){
                            IsHaveGraphicalPw();
                          },
                          icon: Icon(
                            Icons.apps,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        SizedBox(
                          height: 56,
                          width: 120,
                          child: RaisedButton(
                            onPressed: () async{
                              isPasswordValid(_PassWordController.value.text.toString()).then((value){
                                if(value == true){
                                  Navigator.of(context).pushReplacementNamed('home');
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
                            color: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        IconButton(
                          iconSize: 50,
                          onPressed: (){
                          },
                          icon: Icon(
                            Icons.fingerprint,
                            color: Colors.lightBlueAccent,
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
                    //child: Image.asset("image/tupian.jpg"),
                    backgroundImage: AssetImage("image/tupian.jpg"),
                    radius: 60,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../homepage.dart';
// import 'graphical_password_login.dart';
// import '../service/shared_pref.dart';
// import 'package:local_auth/auth_strings.dart';
// import 'package:local_auth/local_auth.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _LoginPageState();
//   }
// }
//
// class _LoginPageState extends State<LoginPage> {
//   var leftRightPadding = 30.0;
//   var topBottomPadding = 4.0;
//   var textTips = TextStyle(fontSize: 16.0, color: Colors.black);
//   var hintTips = TextStyle(fontSize: 15.0, color: Colors.black26);
//   var _PassWordController = TextEditingController();
//
//   void IsHaveGraphicalPw() async {
//     print('GraphicalPwInsp');
//     getGraphicalPassWord().then((GraphicalPasswordInSp) {
//       print('GraphicalPwInsp is');
//       print(GraphicalPasswordInSp);
//       if (GraphicalPasswordInSp != null) {
//         //Navigator.of(context).pop();
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (BuildContext context) => GraphicalPasswordLoginPage()));
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     var localAuth = LocalAuthentication();
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "login",
//             style: TextStyle(color: Colors.black),
//           ),
//           iconTheme: IconThemeData(color: Colors.blue),
//           backgroundColor: Colors.blue,
//           automaticallyImplyLeading: false,
//         ),
//         body: ListView(
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.fromLTRB(
//                   leftRightPadding, 50.0, leftRightPadding, 10.0),
//               child: Text("Welcome to Back!",
//                   style: TextStyle(color: Colors.black, fontSize: 35.0)),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(
//                   leftRightPadding, 50.0, leftRightPadding, topBottomPadding),
//               child: TextField(
//                 style: hintTips,
//                 controller: _PassWordController,
//                 decoration: InputDecoration(hintText: "Password"),
//                 obscureText: true,
//               ),
//             ),
//             Container(
//               width: 250.0,
//               margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
//               padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding,
//                   leftRightPadding, topBottomPadding),
//               child: Card(
//                 color: Colors.lightBlueAccent,
//                 elevation: 6.0,
//                 child: FlatButton(
//                   onPressed: () async {
//                     // var passwordInSp;
//                     // passwordInSp = await getPassWord();
//                     // print('passwordSp');
//                     // print(passwordInSp);
//                     // print('passwordinput');
//                     // print(_PassWordController.value.text.toString());
//                     isPasswordValid(_PassWordController.value.text.toString()).then((value) {
//                       if (value == true) {
//                         // if (await isPasswordValid(_PassWordController.value.text.toString())) {
//                         // if (passwordInSp ==
//                         //     _PassWordController.value.text.toString()) {
//                         showDialog<Null>(
//                             context: context,
//                             barrierDismissible: false,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: Text("Congradulation!"),
//                                 content: SingleChildScrollView(
//                                   child: ListBody(
//                                     children: <Widget>[
//                                       Text("You have login successfully"),
//                                       Text("Now use it happily"),
//                                     ],
//                                   ),
//                                 ),
//                                 actions: <Widget>[
//                                   FlatButton(
//                                     child: Text('confirm'),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                       Navigator.of(context).pushReplacement(
//                                           MaterialPageRoute(
//                                               builder: (BuildContext context) =>
//                                                   HomePage()));
//                                     },
//                                   )
//                                 ],
//                               );
//                             });
//                       } else {
//                         showDialog<Null>(
//                             context: context,
//                             barrierDismissible: false,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: Text("Error!!"),
//                                 content: SingleChildScrollView(
//                                   child: ListBody(
//                                     children: <Widget>[
//                                       Text("passWordError!"),
//                                       Text("Please input again"),
//                                     ],
//                                   ),
//                                 ),
//                                 actions: <Widget>[
//                                   FlatButton(
//                                       child: Text('confirm'),
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       })
//                                 ],
//                               );
//                             });
//                       }
//                     });
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: Text(
//                       "LOGIN",
//                       style: TextStyle(color: Colors.black, fontSize: 20.0),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               width: 250.0,
//               margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
//               padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding,
//                   leftRightPadding, topBottomPadding),
//               child: Card(
//                 color: Colors.lightBlueAccent,
//                 elevation: 6.0,
//                 child: FlatButton(
//                   onPressed: () {
//                     IsHaveGraphicalPw();
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: Text(
//                       "Graphic login",
//                       style: TextStyle(color: Colors.black, fontSize: 20.0),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               width: 250.0,
//
//               margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
//               padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding, leftRightPadding, topBottomPadding),
//               child: Card(
//                 color: Colors.lightBlueAccent,
//                 elevation: 6.0,
//                 child: FlatButton(
//                   onPressed: () async {
//                     //下面是汉化
//                     const andStrings = const AndroidAuthMessages(
//                       cancelButton: '取消',
//                       goToSettingsButton: '去设置',
//                       fingerprintNotRecognized: '指纹识别失败',
//                       goToSettingsDescription: '请设置指纹.',
//                       fingerprintHint: '指纹',
//                       fingerprintSuccess: '指纹识别成功',
//                       signInTitle: '指纹验证',
//                       fingerprintRequiredTitle: '请先录入指纹!',
//                     );
//
//                     try {
//                       bool didAuthenticate;
//                       await localAuth.authenticateWithBiometrics(
//                           localizedReason:
//                           '扫描指纹进行身份识别',
//                           useErrorDialogs: true,
//                           stickyAuth: true,
//                           androidAuthStrings: andStrings
//                       ).then((didAuthenticate){
//                         didAuthenticate==true? Navigator.of(context).pushAndRemoveUntil(
//                             MaterialPageRoute(builder: (context) => HomePage()),
//                                 (route) => route==null
//                         ):print("false");
//                       });
//                     } catch (e) {
//                       print(e);
//                     }
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: Text("Fingerprint login",style: TextStyle(color: Colors.black,fontSize: 20.0),),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ));
//     //throw UnimplementedError();
//   }
// }

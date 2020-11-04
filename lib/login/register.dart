// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../homepage.dart';
// import './login.dart';
// import '../service/shared_pref.dart';
//
// class RegisterPage extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   var registerPassWordController = TextEditingController();
//   var leftRightPadding = 30.0;
//   var topBottomPadding = 4.0;
//   var textTips = TextStyle(fontSize: 16.0, color: Colors.black);
//   var hintTips = TextStyle(fontSize: 15.0, color: Colors.black26);
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "register",
//           style: TextStyle(color: Colors.black),
//         ),
//         iconTheme: Theme.of(context).iconTheme,
//         backgroundColor: Theme.of(context).primaryColor,
//         automaticallyImplyLeading: false,
//       ),
//       body: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.fromLTRB(
//                 leftRightPadding, 50.0, leftRightPadding, 10.0),
//             child: Text("Welcome to JiZhangApp!",
//                 style: TextStyle(color: Colors.black, fontSize: 30.0)),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(
//                 leftRightPadding, 50.0, leftRightPadding, topBottomPadding),
//             child: TextField(
//               style: hintTips,
//               controller: registerPassWordController,
//               decoration:
//                   InputDecoration(hintText: "Please Set Your Password Here"),
//               obscureText: true,
//             ),
//           ),
//           Container(
//             width: 250.0,
//             margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
//             padding: EdgeInsets.fromLTRB(leftRightPadding, topBottomPadding,
//                 leftRightPadding, topBottomPadding),
//             child: Card(
//               color: Theme.of(context).primaryColor,
//               elevation: 6.0,
//               child: FlatButton(
//                 onPressed: () async {
//                   if (registerPassWordController.value.text.toString().length >=
//                           8 &&
//                       registerPassWordController.value.text.toString().length <=
//                           18) {
//                     await setEncryptedPassword(
//                         registerPassWordController.value.text.toString());
//                     showDialog<Null>(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text("Congradulation!"),
//                             content: SingleChildScrollView(
//                               child: ListBody(
//                                 children: <Widget>[
//                                   Text("You have register successfully"),
//                                   Text("Now use it happily"),
//                                 ],
//                               ),
//                             ),
//                             actions: <Widget>[
//                               FlatButton(
//                                 child: Text('confirm'),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                   Navigator.of(context).pushReplacement(
//                                       MaterialPageRoute(
//                                           builder: (BuildContext context) =>
//                                               NavigationHomeScreen()));
//                                 },
//                               )
//                             ],
//                           );
//                         });
//                   } else {
//                     showDialog<Null>(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text("Error!!"),
//                             content: SingleChildScrollView(
//                               child: ListBody(
//                                 children: <Widget>[
//                                   Text(
//                                       "Please input the password in 8~18 length"),
//                                   Text("Please input again"),
//                                 ],
//                               ),
//                             ),
//                             actions: <Widget>[
//                               FlatButton(
//                                 child: Text('confirm'),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                               )
//                             ],
//                           );
//                         });
//                   }
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: Text(
//                     "Register",
//                     style: TextStyle(color: Colors.black, fontSize: 20.0),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//version 2
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jizhangapp/login/introduction_screen.dart';
import 'package:flutter_jizhangapp/login/login.dart';
import 'package:flutter_jizhangapp/routes.dart';
import 'package:flutter_jizhangapp/service/shared_pref.dart';
import '../ui/common_dialog.dart';

import '../homepage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var registerPassWordController = TextEditingController();
  var registerUserNameController = TextEditingController();
  //用户名判断(10字以内，不为空)
  static bool isUserName(String input){
    if(input.length>0&&input.length<=10) return true;
    else {return false;}
  }
  //密码判断（8~18，数字和字符，正则判断式）
  static bool isLoginPassword(String input) {
    RegExp mobile = new RegExp(r"[A-Za-z0-9]{8,18}$");
    if(input.length>18)
      return false;
    return mobile.hasMatch(input);
  }

  FocusNode blankNode = FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();
  FocusNode _userNameFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('tap here!');
        FocusScope.of(context).requestFocus(blankNode);
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("image/cat.jpg"),
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
                      "欢迎使用喵喵记",
                      style: TextStyle(
                          fontFamily: "SFUIText",
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),
                    ),
                    SizedBox(
                      height: 275,
                    ),
                    Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        //key: _formkey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 70,
                              ),
                              TextFormField(
                                //keyboardType: TextInputType.name,
                                //obscureText: true,
                                autofocus: true,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                focusNode: _userNameFocusNode,
                                onEditingComplete: () {
                                  print('finish input 1');
                                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                                },
                                controller: registerUserNameController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.account_circle),
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
                                    hintText: "设置你的用户名(10字以内)",
                                    hintStyle: TextStyle(
                                      fontFamily: "SFUIText",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black26,
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: registerPassWordController,
                                obscureText: true,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                focusNode: _passwordFocusNode,
                                onEditingComplete: () {
                                  FocusScope.of(context).requestFocus(blankNode);
                                },
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
                                    hintText: "设置你的密码(8~18位数字、字母的组合)",
                                    hintStyle: TextStyle(
                                      fontFamily: "SFUIText",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black26,
                                    )),
                              ),
                              SizedBox(
                                height: 33,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 56,
                            width: 120,
                            child: RaisedButton(
                              onPressed: () async{
                                if(isLoginPassword(registerPassWordController.value.text.toString())&&
                                    isUserName(registerUserNameController.value.text.toString())){
                                  //密码和用户名符合格式
                                  await setEncryptedPassword(registerPassWordController.value.text.toString());
                                  await setUserName(registerUserNameController.value.text.toString());
                                  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context){
                                    return IntroductionScreenPage();
                                  }));
                                }else if(!isUserName(registerUserNameController.value.text.toString())&&
                                    isLoginPassword(registerPassWordController.value.text.toString())){
                                  //用户名不符合格式
                                  print('username error');
                                  CommonDialog.show(context, Text('用户名不合法！\n用户名长度必须在1-10位之间'));
                                }else if(!isLoginPassword(registerPassWordController.value.text.toString())&&
                                    isUserName(registerUserNameController.value.text.toString())){
                                  //密码不符合格式
                                  print('loginpw error');
                                  CommonDialog.show(context, Text('注册密码不合法！\n密码必须由8-18位的数字或者字母组成'));
                                }else{
                                  //用户名和密码都不合法
                                  CommonDialog.show(context, Text('密码和用户名不合法！\n用户名长度必须在1-10位之间\n密码必须由8-18位的数字或者字母组成'));
                                }
                              },
                              child: Text(
                                "注册",
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
                        ],
                      ),
                    )
                  ],
                ),
                Center(
                  child: Padding(padding: EdgeInsets.only(top: 290),
                    child: CircleAvatar(
                      //child: Image.asset("image/tupian.jpg"),
                      backgroundImage: AssetImage("assets/cat_user.png"),
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

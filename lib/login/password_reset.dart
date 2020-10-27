import 'package:flutter/material.dart';
import '../ui/common_dialog.dart';
import '../homepage.dart';
import '../service/shared_pref.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PasswordResetPage();
  }
}

class _PasswordResetPage extends State<PasswordResetPage> {
  var resetPassWordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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
                    "重置你的密码",
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
                            controller: resetPassWordController,
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
                                hintText: "输入你的新密码",
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          iconSize: 50,
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 56,
                          width: 120,
                          child: RaisedButton(
                            onPressed: () async{
                              if(isLoginPassword(resetPassWordController.value.text.toString())){
                                await setEncryptedPassword(resetPassWordController.value.text.toString());
                                Navigator.of(context).pop();
                              }else{
                                CommonDialog.show(context, Text('注册密码不合法！\n密码必须由8-18位的数字或者字母组成'));
                              }
                            },
                            child: Text(
                              "确定",
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
    );
  }
}

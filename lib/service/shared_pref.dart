import 'package:shared_preferences/shared_preferences.dart';

//文本密码和shared preferences 的交互
Future<String> getPassWord() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  String pw = sharedPref.getString('mpassWord');
  print('password in Sp');
  print(pw);
  return sharedPref.getString('mpassWord');
}

Future<Null> setPassWord(String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('mpassWord', val);
}

//图形密码和shared preferences 的交互
Future<String> getGraphicalPassWord() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString('mGrapthicalPassWord');
}

Future<Null> setGraphicalPassWord(String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('mGrapthicalPassWord', val);
}

//判断是否是新用户的flag和shared preferences的交互
Future<String> getOldUserFlag() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString('OldUserFlag');
}

Future<Null> setOldUserFlag() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('OldUserFlag', 'Yes');
}

//all
Future<String> getPicker(String key) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString(key);
}

Future<Null> setPicker(String key, String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString(key, val);
}

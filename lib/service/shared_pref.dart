import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

//用户名与shared preferences的交互
Future<String> getUserName() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  String pw = sharedPref.getString('muserName');
  print('username in Sp');
  print(pw);
  return sharedPref.getString('muserName');
}
Future<Null> setUserName(String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('muserName', val);
}
//文本密码和shared preferences 的交互
Future<String> getPassWord() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  String pw = sharedPref.getString('mpassWord');
  print('password in Sp');
  print(pw);
  return sharedPref.getString('mpassWord');
}

//检测是否已经设置密码
Future<bool> isPasswordSet() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  bool flag = await sharedPref.containsKey('encrypted1');
  return flag;
}

//设置密码
Future<Null> setEncryptedPassword(String rawPassword) async {
  print(rawPassword);
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  final cryptor = new PlatformStringCryptor();
  String key = await cryptor.generateRandomKey();
  await sharedPref.setString('key1', key);
  print("key is $key");
  String encrypted = await cryptor.encrypt(rawPassword, key);
  print(encrypted);
  await sharedPref.setString('encrypted1', encrypted);
}

//校验密码
Future<bool> isPasswordValid(String rawPassword) async {
  print("input: $rawPassword");
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  final cryptor = new PlatformStringCryptor();
  String key = await sharedPref.getString('key1');
  print("key is: $key");
  String encrypted = await sharedPref.getString('encrypted1');
  print("encrypted is: $encrypted");
  String decrypted = await cryptor.decrypt(encrypted, key);
  // print(await cryptor.decrypt(encrypted, key));
  // cryptor.decrypt(encrypted, key).then((decrypted) {
  //   print(decrypted == rawPassword);
  //   return(true);
  // });
  print('the decrypted');
  print(decrypted);
  print("rawpassword is $rawPassword");
  print(decrypted ==rawPassword);
  return (decrypted == rawPassword);
}

Future<Null> removePassword() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  await sharedPref.remove('key1');
  await sharedPref.remove('encrypted1');
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

Future<Null> removeOldUserFlag() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.remove('OldUserFlag');
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


//判断是否是可用密码
bool isLoginPassword(String input) {
//RegExp mobile = new RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,18}$");
RegExp mobile = new RegExp(r"[A-Za-z0-9]{8,18}$");
return mobile.hasMatch(input);
}
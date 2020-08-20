import 'package:shared_preferences/shared_preferences.dart';

// ------------------------------------------------------
// author：魏工
// date  ：2020/8/20 10:44
// usage ：持久存储数据 如登录账号密码
// ------------------------------------------------------

class KV {
  static Future<bool> setStr(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(key, value);
    } catch (e) {
      print("***share_preference->setStr error:" + e.toString());
      return false;
    }
  }

  static Future<String> getStr(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String s = prefs.getString(key);
      print("---prefs---getString:$s");
      return s;
    } catch (e) {
      print("***share_preference->getStr:" + e.toString());
      return "";
    }
  }

//------------------------------------------------

}

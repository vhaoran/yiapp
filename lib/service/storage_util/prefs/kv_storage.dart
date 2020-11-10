import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiapp/complex/const/const_string.dart';

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

  static Future<bool> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(key);
      return true;
    } catch (e) {
      print(">>>share_preference 执行 remove 操作时出现异常");
      return false;
    }
  }

  /// 清空本地数据(慎用)
  static Future<bool> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      return true;
    } catch (e) {
      print(">>>share_preference 执行 clear 操作时出现异常");
      return false;
    }
  }

  /// 退出登录时清空本地登录相关的数据
  static Future<bool> clearLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(kv_jwt);
//      prefs.remove(kv_login);
//      prefs.remove(kv_pwd);
      return true;
    } catch (e) {
      print(">>>share_preference 执行 removeLogin 操作时出现异常");
      return false;
    }
  }

//------------------------------------------------

}

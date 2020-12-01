import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_login.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/7 15:34
// usage ：测试用户登录相关内容
// ------------------------------------------------------

void main() {
  // 01 ------------ 用户注册 ------------
  test("用户注册", () async {
    ApiBase.jwt = jwt_134;
    var m = {
      "user_code": "18066610000",
      "nick": "中国电信",
      "pwd": "10000",
    };
    try {
      bool ok = await ApiLogin.regUser(m);
      print(">>>测试---用户注册结果：$ok");
    } catch (e) {
      print("<<<测试---用户注册异常：$e");
    }
  });

  // 02 ------------ 用户登录 ------------
  test("用户登录", () async {
    ApiBase.jwt = jwt_134;
    var m = {"user_code": "18037779691", "pwd": "suxing"};
    try {
      var res = await ApiLogin.login(m);
      print(">>>测试---用户登录结果：${res.toJson()}");
    } catch (e) {
      print("<<<测试---用户登录异常：$e");
    }
  });

  // 03 ------------ 游客登录 ------------
  test("游客登录", () async {
    ApiBase.jwt = jwt_134;
    try {
      var res = await ApiLogin.guestLogin({});
      print(">>>测试---游客登录结果：${res.toJson()}");
    } catch (e) {
      print("<<<测试---游客登录异常：$e");
    }
  });
}

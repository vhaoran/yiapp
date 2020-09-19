import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_user.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/8 15:43
// usage ：用户相关的测试
// ------------------------------------------------------

void main() {
  // 01 ------------ 修改用户昵称 ------------
  test("修改用户昵称", () async {
    ApiBase.jwt = jwt_134;
    var m = {"nick": "苏醒"};
    try {
      bool ok = await ApiUser.ChUserInfo(m);
      print(">>>修改用户昵称结果：$ok");
    } catch (e) {
      print("<<<修改用户昵称出现异常：$e");
    }
  });

  // 02 ------------ 修改用户密码 ------------
  test("修改用户密码", () async {
    ApiBase.jwt = jwt_134;
    try {
      bool ok = await ApiUser.chUserPwd("suxinga", "suxing");
      print(">>>测试---修改用户密码结果：$ok");
    } catch (e) {
      // 提示操作错误，需要用户登录id值必须大于0，设置 enableJwt 为true
      print("<<<测试---修改用户密码异常：$e");
    }
  });

  // 03 ------------ 获取用户信息 ------------
  test("获取用户信息", () async {
    ApiBase.jwt = jwt_134;
    var m = {"uid": 131};
    try {
      var res = await ApiUser.getUser(m);
      print(">>>测试---获取用户信息结果：${res.toJson()}");
    } catch (e) {
      print("<<<测试---获取用户信息异常：$e");
    }
  });

  // 04 ------------ 获取用户公开信息 ------------
  test("获取用户公开信息", () async {
    ApiBase.jwt = jwt_134;
    var m = {"uid": 131};
    try {
      var res = await ApiUser.getUserPublic(m);
      print(">>>测试---获取用户公开信息结果：${res.toJson()}");
    } catch (e) {
      print("<<<测试---获取用户公开信息异常：$e");
    }
  });

  // 05 ------------ 添加收件地址 ------------
  test("添加收件地址", () async {
    ApiBase.jwt = jwt_134;
    var m = {
      "contact": "苏醒",
      "mobile": "18037779691",
      "address": "河南郑州中原区亿科新城",
    };
    try {
      var res = await ApiUser.userAddrAdd(m);
      print(">>>测试---添加收件地址结果：${res.toJson()}");
    } catch (e) {
      print("<<<测试---添加收件地址异常：$e");
    }
  });

  // 06 ------------ 修改收货地址 ------------
  test("修改收货地址", () async {
    ApiBase.jwt = jwt_134;
    var m = {
      "id": 27,
      "M": {
        "contact_person": "苏醒",
        "mobile": "18037779691",
        "detail": "河南省许昌市建安区",
        "province": "河南",
        "city": "郑州",
        "area": "高新区",
        "zip_code": "450000"
      },
    };
    try {
      bool ok = await ApiUser.userAddrCh(m);
      print(">>>测试---修改收货地址结果：$ok");
    } catch (e) {
      // 提示操作错误，需要用户登录id值必须大于0，设置 enableJwt 为true
      print("<<<测试---修改收货地址异常：$e");
    }
  });

  // 07 ------------ 获取地址列表 ------------
  test("获取地址列表", () async {
    ApiBase.jwt = jwt_134;
    try {
      var res = await ApiUser.userAddrList(131);
      print(">>>当前有几个地址：${res.length}");
      res.forEach((e) => print(">>>当前地址列表详情：${e.toJson()}"));
    } catch (e) {
      print("<<<测试---获取地址列表异常：$e");
    }
  });

  // 08 ------------ 获取默认收件地址------------
  test("获取默认收件地址", () async {
    ApiBase.jwt = jwt_134;
    try {
      var res = await ApiUser.userAddrGetDefault({});
      print(">>>测试---获取默认收件地址结果：${res.toJson()}");
    } catch (e) {
      print("<<<测试---获取默认收件地址异常：$e");
    }
  });

  // 09 ------------ 删除收件地址 ------------
  test("删除收件地址", () async {
    ApiBase.jwt = jwt_134;
    var m = {"id": 28};
    try {
      bool ok = await ApiUser.userAddrRm(m);
      print(">>>删除收件地址结果：$ok");
    } catch (e) {
      print("<<<测试---删除收件地址异常：$e");
    }
  });

  // 10 ------------ 设置默认收件地址 ------------
  test("设置默认收件地址", () async {
    ApiBase.jwt = jwt_134;
    var m = {"id": 29};
    try {
      bool ok = await ApiUser.userAddrSetDefault(m);
      print(">>>设置默认收件地址结果：$ok");
    } catch (e) {
      print("<<<测试--设置默认收件地址异常：$e");
    }
  });
}

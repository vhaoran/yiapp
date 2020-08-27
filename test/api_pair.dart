import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_pair.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 10:36
// usage ：星座、生肖等配对单元测试
// ------------------------------------------------------

void main() {
  // 01 ------------ 星座配对 ------------
  test("测试星座配对", () async {
    ApiBase.jwt = jwt_131;
    var m = {"male_con": 1, "female_con": 3}; // 白羊男+双子女
    try {
      var res = await ApiPair.conMatch(m);
      print(">>>测试---星座配对结果：${res.toJson()}");
    } catch (e) {
      print("<<<测试---星座配对出现异常：$e");
    }
  });

  // 02 ------------ 生肖配对 ------------
  test("测试生肖配对", () async {
    ApiBase.jwt = jwt_131;
    var m = {"male_ShengXiao": 1, "female_ShengXiao": 3}; // 鼠男+虎女
    try {
      var res = await ApiPair.shengXiaoMatch(m);
      print(">>>测试---生肖配对结果：${res.toJson()}");
    } catch (e) {
      print("<<<测试---生肖配对出现异常：$e");
    }
  });

  // 03 ------------ 血型配对 ------------
  test("测试血型配对", () async {
    ApiBase.jwt = jwt_131;
    var m = {"male_blood": "A", "female_blood": "B"}; // A型血男+B型血女
    try {
      var res = await ApiPair.bloodMatch(m);
      print(">>>测试---血型配对结果：${res.toJson()}");
    } catch (e) {
      print("<<<测试---血型配对出现异常：$e");
    }
  });
}

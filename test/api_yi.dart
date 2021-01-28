import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_pai_pan.dart';

void main() {
  // 1 ------------ 六爻排盘 ------------
  test("六爻排盘", () async {
    ApiBase.jwt = jwt_134;
    var m = {
      "year": 1996,
      "month": 7,
      "day": 21,
      "minute": 31,
      "code": "123210",
      "male": 1
    };
    try {
      var res = await ApiPaiPan.liuYaoQiGua(m);
      print(">>>测试---六爻排盘返回的结果：${res.toJson()}");
    } catch (e) {
      print("<<<测试---六爻排盘出现异常：$e");
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-product-order.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';

void main() {
  test("yiOrderPage", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = new Map<String, dynamic>();
    PageBean pb = await ApiYiOrder.yiOrderHisPage(m);

    //print("-----result---$r---------");
    //print("-----result---${pb.toJson}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("yiOrderAdd-test", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "master_id": 300,
      "comment": "需要测一下婚姻",
      "master_cate_id": 1,
      "liu_yao": {
        "yao_date": "2010-07-23 12:47:28",
        "yao_code": "123121",
      },
      "a_si_zhu": {
        "is_solar": true,
        "name": "江泽民",
        "is_male": true,
        "year": 1980,
        "month": 1,
        "day": 16,
        "hour": 4,
        "minutes": 50,
      },
      "a_he_hun": {
        "name_male": "江择民",
        "is_solar_male": true,
        "year_male": 1980,
        "month_male": 12,
        "day_male": 12,
        "hour_male": 12,
        "minute_male": 45,
        "name_female": "饭冰冰",
        "is_solar_female": true,
        "year_female": 1982,
        "month_female": 11,
        "day_female": 11,
        "hour_female": 11,
        "minute_female": 44
      },
      "comment_1": "is_solar: 传入日期是否是太阳历，yao_date：摇卦 的日期为阳历 ",
      "comment_2": " is_male:true:男性false:女性  ",
      "comment_3": "is_solar_male: 男性的生日是阳历，is_solar_female  女性的生日是阳历 ",
      "comment_4": " si_zhu/he_hu/liu_yao三个标签只需要传入一个即可 "
    };

    var r = await ApiYiOrder.yiOrderAdd(m);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    var r1 = await ApiYiOrder.yiOrderGet(r.id);
    print("-----result--get -${r1.toJson()}---------");

    ApiBase.jwt = "test/300";
    var r2 = await ApiYiOrder.yiOrderComplete(r.id);
    print("-----result complete---$r2---------");

    var r3 = await ApiYiOrder.yiOrderHisGet(r.id);
    print("-----result-his get--${r3.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });
}

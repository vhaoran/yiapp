import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/service/api/api_base.dart';

void main() {
  test("categoryList-test", () async {
    ApiBase.jwt = "jwt/1";

    Map<String, dynamic> m = {};

    var r = await ApiProduct.categoryList();
    print("-----result---$r---------");
    r.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("categoryGet-test", () async {
    ApiBase.jwt = "jwt/1";

    Map<String, dynamic> m = {};

    var id = 19;
    var r = await ApiProduct.categoryGet(id);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("categoryCh-test", () async {
    ApiBase.jwt = "jwt/1";

    Map<String, dynamic> m = {
      "id": 18,
      "M": {"name": "香蜡纸马", "icon": "3", "sort_no": "3"},
      "comment": "M中的内容可以根据分类的项选填",
      "comment2": "Jwt必须要有"
    };

    var r = await ApiProduct.categoryCh(m);
    print("-----result---$r---------");
    //print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("ProductPage-test", () async {
    ApiBase.jwt = "jwt/1";

    Map<String, dynamic> m = {};

    var r = await ApiProduct.productPage(m);
    print("-----result---$r---------");
    //print("-----result---${r.toJson()}---------");
    r.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("ProductPage-test", () async {
    ApiBase.jwt = "jwt/1";

    Map<String, dynamic> m = {};

    var id = "UHQDcXQBUEDNcUc8k4Sk";
    var r = await ApiProduct.bProductGet(id);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");
    // r.data.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("ProductCh-test", () async {
    ApiBase.jwt = "jwt/1";

    Map<String, dynamic> m = {
      "id_of_es": "TnT4cHQBUEDNcUc8Z4S9",
      "M": {
        "cate_name": "藏香",
        "name": "藏香",
        "remark": "西藏密宗制作",
        "key_word": "藏香 西藏 密宗",
        "images": [
          {"path": "pic14", "sort_no": 1}
        ],
        "colors": [
          {"code": "淡黄", "price": 100},
          {"code": "黄色", "price": 1000},
          {"code": "金色", "price": 10000}
        ]
      },
      "comment": "修改商品属性可以选填, 但是必须存在,大于0即可"
    };

    var r = await ApiProduct.productCh(m);
    print("-----result-ch--$r---------");
    //print("-----result---${r.toJson()}---------");
    // r.data.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("ProductRm-test", () async {
    ApiBase.jwt = "jwt/1";

    Map<String, dynamic> m = {};

    var id = "UHQDcXQBUEDNcUc8k4Sk";
    var r = await ApiProduct.productRm(id);
    print("-----result-ch--$r---------");
    //print("-----result---${r.toJson()}---------");
    // r.data.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("categoryAdd-test", () async {
    ApiBase.jwt = "jwt/1";

    Map<String, dynamic> m = {
      "name": "丹药a",
      "icon": "5",
      "sort_no": 5,
      "comment2": "Jwt必须要有"
    };

    var r = await ApiProduct.categoryAdd(m);
    print("-----result-ch--$r---------");
    //print("-----result---${r.toJson()}---------");
    // r.data.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("productAdd-test", () async {
    ApiBase.jwt = "jwt/1";

    Map<String, dynamic> m = {
      "cate_id": 16,
      // "cate_name": "藏香",
      "name": "西藏的香",
      "remark": "密宗制作",
      "key_word": "香 西藏",
      "enabled": true,
      "images": [
        {"path": "pic1", "sort_no": 1}
      ],
      "colors": [
        {"code": "绿色", "price": 100},
      ],
      "image_main": "pic-main",
      // "comment": "首次添加商品属性可以选填, 但是Jwt必须要有",
      // "comment2": "colors是颜色代码,分别代表不同颜色的不同价格,",
      // "comment3": "cate_id必须是已经存在的id, cate_name可以写任意值或者不传, cate_id的值后台会查询并赋值",
    };

    var r = await ApiProduct.productAdd(m);
    print("-----result-ch--$r---------");
    print("-----result---${r.toJson()}---------");
    // r.data.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });
}

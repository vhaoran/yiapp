import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-product-order.dart';
import 'package:yiapp/service/api/api_base.dart';

void main() {
  test("ApiProductOrder", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = new Map<String, dynamic>();
    PageBean pb = await ApiProductOrder.productOrderPage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("productOrderAdd", () async {
    Map<String, dynamic> m = {
      "items": [
        {
          "product_id": "WallXXQBWYJcLnnxyvRo",
          "name": "fu_zhu",
          "color_code": "a",
          "price": 32,
          "qty": 40,
          "amt": 50
        }
      ],
      "contact": "whr",
    };

    var r = await ApiProductOrder.productOrderAdd(m);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");
    //------------------------------------------------
    var r1 = await ApiProductOrder.productOrderGet(r.id);
    print("-----result---$r1---------");
    print("-----result---${r1.toJson()}---------");
    //------------------------------------------------

    var ret = await ApiProductOrder.productOrderDelivery(
        r.id, "dafasdfasdfadf-shufen");
    print("-----result---$ret---------");

    var ret3 = await ApiProductOrder.productOrderReceive(r.id);
    print("-----result---$ret3---------");

    var ret4 = await ApiProductOrder.productOrderHisGet(r.id);
    print("-----ret4---$ret4---------");
    print("-----result---${ret4.toJson()} ---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });
}

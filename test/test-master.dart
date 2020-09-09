import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';

void main() {
  test("masterInfoPage", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    PageBean pb = await ApiMaster.masterInfoPage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterInfoFullGet-test", () async {
    Map<String, dynamic> m = {};

    var r = await ApiMaster.masterInfoFullGet(14);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterInfoGet-test", () async {
    Map<String, dynamic> m = {};

    var r = await ApiMaster.masterInfoGet(14);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterInfoApplyAudit-test", () async {
    Map<String, dynamic> m = {};

    var r = await ApiMaster.masterInfoApplyAudit("5f55db118f3d745d542977b9", 1);
    print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterSetEnable-test", () async {
    Map<String, dynamic> m = {};

    var r = await ApiMaster.masterSetEnable(10, 1);
    print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterInfoCh-test", () async {
    ApiBase.jwt = "jwt/1";
    Map<String, dynamic> m = {
      "id": 6,
      "M": {
        "bad_rate": 121,
        "best_rate": 121,
        "user_code": "num11",
        "icon": "num11-2",
        "level": 2,
        "mid_rate": 22,
        "nick": "无尘居士",
        "order_total": 999,
        "rate": 0
      },
      // "coment": "修改大师信息时需要保持传入的id和jwt中的一致",
      // "coment2": "大师信息修改可以在以上选项中选择某一项或者某几项进行修该"
    };

    var r = await ApiMaster.masterInfoCh(m);
    print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterInfoApplyHandIn-test", () async {
    ApiBase.jwt = "test/15";

    Map<String, dynamic> m = {
      "info": {"uid": 15, "user_code": "14", "icon": "icon14"},
      "images": [
        {"image_path": "master13", "sort_no": 1}
      ],
      "item": [
        {
          "comment": "周文王所创",
          "price": 998,
          "sort_no": 0,
          "yi_cate_id": 2,
          "yi_cate_name": "文王八卦"
        }
      ],
      "comment": "对于Jwt中的数据,大于0即可",
      "comment1": "item和images是一个类型列表,而不是一个类型",
      "comment2": "item和images的内容可以不填"
    };

    var r = await ApiMaster.masterInfoApplyHandIn(m);
    print("-----result---$r---------");
    //print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterInfoApplyPage", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    PageBean pb = await ApiMaster.masterInfoApplyPage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterInfoApplyPage", () async {
    ApiBase.jwt = "test/1";

    int uid = 11;
    var l = await ApiMaster.masterImageList(uid);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    l.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterImageAdd-test", () async {
    ApiBase.jwt = "jwt/11";

    Map<String, dynamic> m = {"image_path": "master11-3", "sort_no": 3};

    var r = await ApiMaster.masterImageAdd(m);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterImageAdd-test", () async {
    ApiBase.jwt = "jwt/2";

    Map<String, dynamic> m = {
      "id": 2,
      "M": {"image_path": "2", "sort_no": 2},
      // "comment": "必须本人修改自己的图片"
    };

    var r = await ApiMaster.masterImageCh(m);
    print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("MasterImageRm-test", () async {
    ApiBase.jwt = "jwt/2";

    // Map<String, dynamic> m = {
    //   "id": 2,
    //   "M": {"image_path": "2", "sort_no": 2},
    //   // "comment": "必须本人修改自己的图片"
    // };

    var id = 2;
    var r = await ApiMaster.masterImageRm(id);
    print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterItemList-test", () async {
    ApiBase.jwt = "jwt/2";
    var uid = 2;
    var r = await ApiMaster.masterItemList(uid);
    print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------");
    r.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterItemAdd-test", () async {
    ApiBase.jwt = "jwt/2";
    var uid = 2;
    Map<String, dynamic> m = {
      "yi_cate_id": 8,
      "yi_cate_name": "测字",
      "comment": "看字解人生",
      "price": 999.99,
      "comment1": "注意:上面的comment是要传入的字段, 并不是注释",
      "comment3": "传入参数中的uid大于0即可,真正的uid需要通过jwt传入"
    };

    var r = await ApiMaster.masterItemAdd(m);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterItemCh-test", () async {
    ApiBase.jwt = "jwt/103";
    var uid = 3;
    Map<String, dynamic> m = {
      "id": 3,
      "M": {
        "yi_cate_id": 8,
        "yi_cate_name": "测字",
        "comment": "字里有乾坤",
        "price": 998.99
      },
      // "comment1": "必须是本人修改",
      // "comment2": "id对应的uid必须和JWT的id相同"
    };

    var r = await ApiMaster.masterItemCh(m);
    print("-----result--ch-$r---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("masterItemRm-test", () async {
    ApiBase.jwt = "jwt/103";
    Map<String, dynamic> m = {};

    var id = 4;
    var r = await ApiMaster.masterItemRm(id);
    print("-----result---$r---------");
    //print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });
}

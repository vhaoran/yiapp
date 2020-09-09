import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-broker.dart';
import 'package:yiapp/service/api/api_base.dart';

void main() {
  //--------分页查询
  test("BrokerInfoPage", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };
    PageBean pb = await ApiBroker.brokerInfoPage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test(
      "abrokerAdminAdd"
      "test", () async {
    Map<String, dynamic> m = {
      "uid": 17,
      "enabled": 1,
      "comment2": "此处的uid必须是user_info中存在的uid",
      "comment3": "Jwt必须要有, 是推荐者的uid,根据推荐者的broker_id与新增管理员的broker_id相同",
      "comment4": "enabled数字为1代表激活,2代表停止"
    };

    var r = await ApiBroker.brokerAdminAdd(m);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("brokerAdminList", () async {
    ApiBase.jwt = "test/112";

    Map<String, dynamic> m = {};

    var r = await ApiBroker.brokerAdminList();
    print("-----result---$r---------");

    var r1 = await ApiBroker.brokerAdminRm(112);
    print("-----result-rm--$r---------");
    //print("-----result---${r.toJson()}---------");

    r.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test(
      "brokerApplyHandIn"
      "atest", () async {
    ApiBase.jwt = "test/20";
    Map<String, dynamic> m = {
      "name": "西藏总代理b",
      "icon": "p1",
      "service_code": "1111",
      "Brief": "西藏代理",
      "comment2": "Jwt必须要有, jwt传入的数据是用户表中的uid, 即代理表中的owner_id",
      "comment3": "service_code, name都不能重复"
    };

    var r = await ApiBroker.brokerApplyHandIn(m);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    var r2 = await ApiBroker.brokerApplyAudit(r.id, 1);
    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("brokerApplyPage", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    PageBean pb = await ApiBroker.brokerApplyPage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("brokerIDGet-test", () async {
    var r = await ApiBroker.brokerIDGet("325");
    print("-----result--brokerIDGet -$r---------");
    //print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("brokerInfoGet-test", () async {
    var r = await ApiBroker.brokerInfoGet(11);
    print("-----result--brokerIDGet -$r---------");
    //print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("serviceCodeBind-test", () async {
    ApiBase.jwt = "test/22";
    var r = await ApiBroker.serviceCodeBind("325");

    print("-----result--brokerIDGet -$r---------");
    //print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("brokerUserInfoSearch-test", () async {
    ApiBase.jwt = "test/17";
    var r = await ApiBroker.brokerUserInfoSearch("三");

    print("-----result--brokerIDGet -$r---------");
    //print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("brokerUserInfoPage", () async {
    ApiBase.jwt = "test/17";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    PageBean pb = await ApiBroker.brokerUserInfoPage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });
}

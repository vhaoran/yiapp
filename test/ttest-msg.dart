import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_msg.dart';

void main() {
  test("YiOrderMsgHisPage", () async {
    ApiBase.jwt = "test/300";

    Map<String, dynamic> m = {
      //设置此变量，用于锁定到某个订单上
      //"id_of_order": "",
      "page_no": 1,
      "rows_per_page": 10,
    };

    PageBean pb = await ApiMsg.yiOrderMsgHisPage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("NotifyMsgPage", () async {
    ApiBase.jwt = "test/300";

    Map<String, dynamic> m = {
      //设置此变量，用于锁定到某个订单上
      //"id_of_order": "",
      "page_no": 1,
      "rows_per_page": 10,
    };

    PageBean pb = await ApiMsg.notifyMsgPage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("yiOrderMsgSend", () async {
    ApiBase.jwt = "test/154";

    Map<String, dynamic> m = {
      "id_of_order": "5f6d60c850f5f3dbed628d37",
      "msg_type": 0,
      "msg": "hello,world!!!!!!",
    };

    var r = await ApiMsg.yiOrderMsgSend(m);

    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("yiOrderMsgAck", () async {
    ApiBase.jwt = "test/4";

    var l = List<String>();
    l.add("5f6d4c63f54d38dfa2974f8e");
    var r = await ApiMsg.yiOrderMsgAck(l);

    print("-----result---$r---------");
    //print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("notifyMsgAck", () async {
    ApiBase.jwt = "test/4";

    var l = List<String>();
    l.add("5f6d4c63f54d38dfa2974f8e");
    var r = await ApiMsg.notifyMsgAck(l);

    print("-----result---$r---------");
    //print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });
}

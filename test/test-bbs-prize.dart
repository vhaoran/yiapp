import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';

void main() {
  test("bbsPrizePage", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    PageBean pb = await ApiBBSPrize.bbsPrizePage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsPrizeHisPage", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    PageBean pb = await ApiBBSPrize.bbsPrizeHisPage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsPrizeGet", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    var id = "5f59cf88506a5a960749eb77";
    var r = await ApiBBSPrize.bbsPrizeGet(id);

    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsPrizeHisGet", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    var id = "5f59cf88506a5a960749eb77";
    var r = await ApiBBSPrize.bbsPrizeHisGet(id);

    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsPrizeReplyList", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    var id = "5f59cf88506a5a960749eb77";
    var r = await ApiBBSPrize.bbsPrizeReplyList(id);

    print("-----result---$r---------");
    //print("-----result---${r.toJson()}---------");
    r.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsPrizeAdd", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "score": 50,
      "title": "什么时间买 车",
      "images": ["a", "b", "c"],
      "brief": "我想逄一下，我什么时间买 车，现在我没有钱",
      "content_type": 0,
      "content_liuyao": {
        "year": 2020,
        "month": 10,
        "day": 13,
        "hour": 20,
        "yao_code": "123121"
      },
      "content": {
        "is_solar": true,
        "name": "江泽民",
        "is_male": true,
        "year": 1980,
        "month": 1,
        "day": 16,
        "hour": 4,
        "minutes": 50
      },
      // "comment_1":"aa",
    };

    // var id = "5f59cf88506a5a960749eb77";
    var r = await ApiBBSPrize.bbsPrizeAdd(m);

    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");
    // r.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsPrizeCancel", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {};

    var id = "5f59f005173f142bbfa20380";
    var r = await ApiBBSPrize.bbsPrizeCancel(id);

    print("-----result--bbsPrizeCancel  -$r---------");
    //print("-----result---${r.toJson()}---------");
    // r.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsPrizeDue", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "id": "5f59ce83506a5a960749eb76",
      "score": 50,
      "master_id": 1,
      "comment_1": "aa"
    };

    var r = await ApiBBSPrize.bbsPrizeSetMasterReward(m);

    print("-----result--bbsPrizeCancel  -$r---------");
    //print("-----result---${r.toJson()}---------");
    // r.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsPrizeReply", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "id": "5f59cf88506a5a960749eb77",
      "text": ["aaa", "bbb", "cc"],
    };

    var r = await ApiBBSPrize.bbsPrizeReply(m);
    print("-----result--bbsPrizeReply  -$r---------");
    expect(1, equals(1));
    print(" ------------end------------  ");
  });
}

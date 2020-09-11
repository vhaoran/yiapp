import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-Vie.dart';
import 'package:yiapp/service/api/api_base.dart';

void main() {
  test("bbsViePage", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    PageBean pb = await ApiBBSVie.bbsViePage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsVieHisPage", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    PageBean pb = await ApiBBSVie.bbsVieHisPage(m);

    //print("-----result---$r---------");
    // print("-----result---${r.toJson()}---------"
    pb.data.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsVieGet", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    var id = "5f5a019406e9dd1990474379";
    var r = await ApiBBSVie.bbsVieGet(id);

    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsVieHisGet", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    var id = "5f5ad3b75b44304819156cef";
    var r = await ApiBBSVie.bbsVieHisGet(id);

    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsVieReplyList", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    var id = "5f5ae899e6e739ce598777f5";
    var r = await ApiBBSVie.bbsVieReplyList(id);

    print("-----result---$r---------");
    //print("-----result---${r.toJson()}---------");
    r.forEach((e) {
      print("-----result---${e.toJson()}---------");
    });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsVieAdd", () async {
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
    var r = await ApiBBSVie.bbsVieAdd(m);

    print("-----result---$r---------");
    print("-----result---${r.toJson()}---------");
    // r.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsVieAim", () async {
    ApiBase.jwt = "test/2";

    Map<String, dynamic> m = {};

    var id = "5f5b14c9b6ca59fb395d876b";
    var r = await ApiBBSVie.bbsVieAim(id);

    print("-----result--bbsVieAim  -$r---------");
    //print("-----result---${r.toJson()}---------");
    // r.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsVieCancel", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {};

    var id = "5f5b19cd807b383def8ba8e4";
    var r = await ApiBBSVie.bbsVieCancel(id);

    print("-----result--bbsVieCancel  -$r---------");
    //print("-----result---${r.toJson()}---------");
    // r.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsVieDue", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "id": "5f5b1f4214d8052a3dc80ec2",
      "comment_1": "aa"
    };

    var r = await ApiBBSVie.bbsVieDue(m);

    print("-----result--bbsVieCancel  -$r---------");
    //print("-----result---${r.toJson()}---------");
    // r.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });

  test("bbsVieReply", () async {
    ApiBase.jwt = "test/1";

    Map<String, dynamic> m = {
      "id": "5f5b200d14d8052a3dc80ec3",
      "text": ["aaa", "bbb", "cc"],
    };

    var r = await ApiBBSVie.bbsVieReply(m);

    print("-----result--bbsVieCancel  -$r---------");
    //print("-----result---${r.toJson()}---------");
    // r.forEach((e) {
    //   print("-----result---${e.toJson()}---------");
    // });

    expect(1, equals(1));
    print(" ------------end------------  ");
  });
}

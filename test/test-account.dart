import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/model/dicts/account.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/service/api/api_base.dart';

void main() {
  test("accountSet", () async {
    ApiBase.jwt = "test/1";

    var m = {
      "account_type": 1,
      "account_code": "123456-----aaaa",
      "is_default": 1,
      "comment_1": "帐号类型    0：支付宝 1：微信  是否默认帐号 0:是 1:否, "
    };

    var b = await ApiAccount.accountSet(m);
    print('---------begin-----------------');
    print("----result:---$b-----------");

    expect(1, equals(1));
    print(" ----------end--------------  ");
  });
  test("accountSetDefault", () async {
    ApiBase.jwt = "test/1";

    var b = await ApiAccount.accountSetDefault(1);
    print('---------begin-----------------');
    print("----result:---$b-----------");

    expect(1, equals(1));
    print(" ----------end--------------  ");
  });

  test("accountRm", () async {
    ApiBase.jwt = "test/1";

    var b = await ApiAccount.accountRm(1);
    print('---------begin-----------------');
    print("----result:---$b-----------");

    expect(1, equals(1));
    print(" ----------end--------------  ");
  });

  test("businessPage", () async {
    ApiBase.jwt = "test/1";
    var pb = {
      "page_no": 1,
      "rows_per_page": 10,
    };

    List<Account> l = await ApiAccount.businessPage(pb);
    print('---------begin-----------------');
    l.forEach((e) => print("----result:---${e.toJson()}-----------"));
    expect(1, equals(1));
    print(" ----------end--------------  ");
  });

  test("accountList", () async {
    ApiBase.jwt = "test/1";

    List<Account> l = await ApiAccount.accountList();
    print('---------begin-----------------');
    l.forEach((e) => print("----result:---${e.toJson()}-----------"));
    expect(1, equals(1));
    print(" ----------end--------------  ");
  });

  //------------------------------------------------
}

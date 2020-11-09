import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/login/login_table.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/9 10:06
// usage ：本地数据库打印输出信息
// ------------------------------------------------------

class LocalDBPrint extends StatefulWidget {
  LocalDBPrint({Key key}) : super(key: key);

  @override
  _LocalDBPrintState createState() => _LocalDBPrintState();
}

class _LocalDBPrintState extends State<LocalDBPrint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "本地数据库打印输出信息"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 30),
      children: <Widget>[
        Row(
          children: <Widget>[
            RaisedButton(
              child: Text("a、输出登录用户信息"),
              onPressed: _findAll,
            ),
            SizedBox(width: 20),
            RaisedButton(
              child: Text("b、token 登录验证"),
              onPressed: _findJwt,
            ),
          ],
        ),
      ],
    );
  }

  void _findAll() async {
    var l = await LoginDao(glbDB).findAll();
    for (var i = 0; i < l.length; i++) {
      Debug.log("demo中，第${i + 1}个用户的登录信息详情：${l[i].toJson()}");
    }
  }

  void _findJwt() async {
    String str = await KV.getStr(kv_jwt);
    CusLoginRes res = await LoginDao(glbDB).verifyJwt(str);
    Debug.log("当前 token 登录用户信息：${res.toJson()}");
  }
}

import 'package:flutter/material.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/28 下午2:53
// usage ：关于获取数据
// ------------------------------------------------------

class DemoGetData extends StatelessWidget {
  DemoGetData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "获取数据相关"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: <Widget>[
        NormalBox(
          title: "01 获取数据库中所有用户信息",
          onTap: () async {
            var l = await LoginDao(glbDB).readAll();
            for (var i = 0; i < l.length; i++) {
              Debug.log("第 ${i + 1} 个用户：${l[i].toJson()}");
            }
          },
        )
      ],
    );
  }
}

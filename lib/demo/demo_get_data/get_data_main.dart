import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/small/cus_box.dart';
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
          title: "01 数据库中所有用户信息",
          onTap: () async {
            var l = await LoginDao(glbDB).readAll();
            for (var i = 0; i < l.length; i++) {
              Log.info("第 ${i + 1} 个用户：${l[i].toJson()}");
            }
          },
        ),
        NormalBox(
          title: "02 当前登录用户",
          onTap: () async {
            var user = await LoginDao(glbDB).readUserByUid();
            Log.info("当前登录用户详情: ${user.toJson()}");
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/28 下午2:47
// usage ：关于清除数据
// ------------------------------------------------------

class DemoClearData extends StatelessWidget {
  DemoClearData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "清除数据相关"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: <Widget>[
        NormalBox(
          title: "01 删除本地 kv 数据",
          onTap: () async {
            bool ok = await KV.clear();
            String tip = "删除本地 kv 数据：${ok ? '成功' : '失败'}";
            CusDialog.tip(context, title: tip);
          },
        ),
        NormalBox(
          title: "02 删除 sqlite 全部用户信息",
          onTap: () async {
            bool ok = await LoginDao(glbDB).deleteAll();
            String tip = "删除本地数据库用户信息：${ok ? '成功' : '失败'}";
            CusDialog.tip(context, title: tip);
          },
        ),
        NormalBox(
          title: "03 删除 sqlite 和 kv",
          onTap: () async {
            if (await LoginDao(glbDB).deleteAll() && await KV.clear()) {
              CusDialog.tip(context, title: "删除成功");
            }
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/ui/broker/broker_apply_his.dart';
import 'package:yiapp/ui/master/master_apply_his.dart';
import 'package:yiapp/ui/master/master_enable.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 14:40
// usage ：后台管理
// ------------------------------------------------------

class BackstageManage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "后台管理"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: Adapt.px(10)),
        NormalBox(
          title: "大师申请审批",
          onTap: () => CusRoutes.push(context, MasterApplyHisPage()),
        ),
        NormalBox(
          title: "代理申请审批",
          onTap: () => CusRoutes.push(context, BrokerApplyHisPage()),
        ),
        NormalBox(
          title: "启用停用大师",
          onTap: () => CusRoutes.push(context, MasterEnable()),
        ),
      ],
    );
  }
}

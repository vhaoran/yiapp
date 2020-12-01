import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/back_stage/admin_master_orders.dart';
import 'package:yiapp/ui/back_stage/broker_apply_his.dart';
import 'package:yiapp/ui/back_stage/master_apply_his.dart';
import 'package:yiapp/ui/back_stage/master_enable.dart';

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
          onTap: () => CusRoute.push(context, MasterApplyHisPage()),
        ),
        NormalBox(
          title: "运营商申请审批",
          onTap: () => CusRoute.push(context, BrokerApplyHisPage()),
        ),
        NormalBox(
          title: "启用停用大师",
          onTap: () => CusRoute.push(context, MasterEnable()),
        ),
        NormalBox(
          title: "大师未完成订单",
          onTap: () => CusRoute.push(context, AdminMasterOrders()),
        ),
      ],
    );
  }
}

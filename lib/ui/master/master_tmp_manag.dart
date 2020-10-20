import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/ui/master/master_order/master_await_orders.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/20 17:04
// usage ：临时存放和大师相关的未分类的功能
// ------------------------------------------------------

class MasterTmpManage extends StatelessWidget {
  MasterTmpManage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "大师相关"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          NormalBox(
            title: "待处理订单",
            onTap: () => CusRoutes.push(context, MasterAwaitOrders()),
          ),
        ],
      ),
    );
  }
}

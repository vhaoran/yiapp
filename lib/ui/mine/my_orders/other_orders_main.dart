import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/vip/refund/user_refund_main_page.dart';
import 'package:yiapp/ui/vip/yiorder/user_yiorder_doing_list_page.dart';
import 'package:yiapp/ui/vip/yiorder/user_yiorder_his_list_page.dart';
import 'package:yiapp/ui/vip/yiorder/user_yiorder_unpaid_list_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/28 14:20
// usage ：其它相关的订单，将不知如何分类的暂时放到这里
// ------------------------------------------------------

class OtherOrdersMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "其它订单"),
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
            title: "处理中大师订单",
            onTap: () => CusRoute.push(context, UserYiOrderDoingListPage()),
          ),
          NormalBox(
            title: "待支付大师订单",
            onTap: () => CusRoute.push(context, UserYiOrderUnpaidListPage()),
          ),
          NormalBox(
            title: "已完成大师订单",
            onTap: () => CusRoute.push(context, UserYiOrderHisListPage()),
          ),
          NormalBox(
            title: "投诉记录",
            onTap: () => CusRoute.push(context, UserRefundMainPage()),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/ui/mine/fund_account/recharge_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/24 下午2:11
// usage ：余额不足弹窗
// ------------------------------------------------------

class LackBalance {
  LackBalance(BuildContext context, {num amt}) {
    _push(context, amt);
  }

  void _push(context, num amt) async {
    CusToast.toast(context, text: "元宝不足，请充值", milliseconds: 1200);
    CusRoute.push(context, RechargePage(amt: amt));
  }
}

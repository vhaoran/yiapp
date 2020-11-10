import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/demo/date_timed_demo.dart';
import 'package:yiapp/complex/demo/local_db_print.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/service/api/api-pay.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_msg.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/mine/com_pay_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/13 13:27
// usage ：demo测试的入口
// ------------------------------------------------------

class CusDemoMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "demo测试"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: [
        SizedBox(height: Adapt.px(10)),
        NormalBox(
          title: "01 自定义日历",
          onTap: () => CusRoutes.push(context, CusTimePickerDemo()),
        ),
        NormalBox(
          title: "02 支付功能测试",
          onTap: () => _testPay(context),
        ),
        NormalBox(
          title: "03 大师订单通知测试",
          onTap: () => _testMasterNotify(context),
        ),
        NormalBox(
          title: "04 清除本地 kv 数据",
          onTap: () async {
            bool ok = await KV.clear();
            Debug.log("清除本地 kv 数据结果：${ok ? '成功' : 'false'}");
          },
        ),
        NormalBox(
          title: "05 获取本地数据库信息",
          onTap: () => CusRoutes.push(context, LocalDBPrint()),
        ),
      ],
    );
  }

  /// 支付功能测试
  void _testPay(context) async {
    CusRoutes.push(
      context,
      ComPayPage(tip: "悬赏帖付款", b_type: b_bbs_prize, orderId: "", amt: 0.01),
    );
  }

  /// 大师订单发消息
  void _testMasterNotify(context) async {
    var m = {
      "id_of_order": "5f9bbd19c5ae742722738f6d",
      "msg_type": msg_text,
      "msg": "测试大师订单通知测试 用户149 to 大师134",
    };
    try {
      var res = await ApiMsg.yiOrderMsgSend(m);
      if (res != null) {
        Debug.log("通知返回的内容详情：${res.toJson()}");
        CusToast.toast(context, text: "通知成功");
      }
    } catch (e) {
      Debug.logError("大师订单通知测试出现异常：$e");
    }
  }
}

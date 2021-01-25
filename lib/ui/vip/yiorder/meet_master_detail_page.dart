import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/submit_hehun_data.dart';
import 'package:yiapp/model/bbs/submit_liuyao_data.dart';
import 'package:yiapp/model/bbs/submit_sizhu_data.dart';
import 'package:yiapp/model/bo/broker_master_cate.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/ui/master/master_console/master_yiorder_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/post_com/yiorder_com_detail.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/25 下午6:22
// usage ：约聊大师（含四柱、合婚、六爻）
// ------------------------------------------------------

class MeetMasterDetailPage extends StatefulWidget {
  final BrokerMasterCate cate; // 选择的大师信息
  final dynamic yiOrderData;

  MeetMasterDetailPage({this.yiOrderData, this.cate, Key key})
      : super(key: key);

  @override
  _MeetMasterDetailPageState createState() => _MeetMasterDetailPageState();
}

class _MeetMasterDetailPageState extends State<MeetMasterDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "约聊大师"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: S.w(10)),
              children: <Widget>[
                SizedBox(height: S.h(10)),
                // 约聊大师的信息
                Row(
                  children: <Widget>[
                    CusAvatar(url: widget.cate.master_icon), // 大师头像
                    SizedBox(width: S.w(10)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _comRow("大师姓名：", widget.cate.master_nick),
                          _comRow("测算项目：", widget.cate.yi_cate_name),
                          _comRow("服务价格：", "${widget.cate.price}"),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.yiOrderData != null)
                  YiOrderComDetail(yiOrderData: widget.yiOrderData),
              ],
            ),
          ),
          SizedBox(
            width: S.screenW(),
            child: CusRaisedButton(
              child: Text("下单"),
              onPressed: _doOrder,
              borderRadius: 50,
            ),
          ),
        ],
      ),
    );
  }

  void _doOrder() async {
    if (widget.yiOrderData != null) {
      var m = {
        "master_id": widget.cate.master_id,
        "yi_cate_id": widget.cate.yi_cate_id,
        "comment": widget.yiOrderData.title + widget.yiOrderData.brief,
      };
      if (widget.yiOrderData is SubmitSiZhuData) {
        var json = (widget.yiOrderData as SubmitSiZhuData).content.toJson();
        m.addAll({"si_zhu": json});
      }
      if (widget.yiOrderData is SubmitHeHunData) {
        var json = (widget.yiOrderData as SubmitHeHunData).content.toJson();
        m.addAll({"he_hun": json});
      }
      if (widget.yiOrderData is SubmitLiuYaoData) {
        var json = (widget.yiOrderData as SubmitLiuYaoData).content.toJson();
        m.addAll({"liu_yao": json});
      }
      Log.info("提交约聊大师的数据：${m.toString()}");
      SpinKit.threeBounce(context);
      try {
        YiOrder res = await ApiYiOrder.yiOrderAdd(m);
        if (res != null) {
          Navigator.pop(context);
          Log.info("返回的大师订单详情：${res.toJson()}");
          CusToast.toast(context, text: "下单成功", pos: ToastPos.bottom);
          var payData =
              PayData(amt: widget.cate.price, b_type: b_yi_order, id: res.id);
          BalancePay(context, data: payData, onSuccess: () {
            CusRoute.pushReplacement(
              context,
              MasterYiOrderPage(id: res.id, backData: "下完大师订单后，携带数据返回"),
            ).then((value) {
              if (value != null) {
                Navigator.of(context).pop("");
              }
            });
          });
        }
      } catch (e) {
        Log.error("约聊大师下单出现异常：$e");
      }
    } else {
      Log.error("传入的大师订单为空值");
    }
  }

  /// 通用的 Row
  Widget _comRow(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(2)),
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(color: t_primary, fontSize: S.sp(15))),
          Text(subtitle, style: TextStyle(color: t_gray, fontSize: S.sp(15))),
        ],
      ),
    );
  }
}

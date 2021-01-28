import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/submit_liuyao_data.dart';
import 'package:yiapp/model/bbs/submit_sizhu_data.dart';
import 'package:yiapp/model/bo/broker_master_cate.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/ui/vip/yiorder/user_yiorder_doing_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
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
  var _briefCtrl = TextEditingController(); // 摘要

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "约聊大师"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return Column(
      children: [
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
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
                SizedBox(height: S.h(10)),
                Divider(height: 0, thickness: 0.2, color: t_gray),
                if (widget.yiOrderData is SubmitLiuYaoData) ...[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: S.h(5)),
                    child: Text(
                      "填写你要咨询的问题",
                      style: TextStyle(fontSize: S.sp(16), color: t_primary),
                    ),
                  ),
                  _briefWt(), // 设置摘要
                ],
                if (widget.yiOrderData != null)
                  YiOrderComDetail(yiOrderContent: widget.yiOrderData.content),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: S.h(3)),
                  child: Text(
                    "问题描述:  ${widget.yiOrderData.title + widget.yiOrderData.brief}",
                    style: TextStyle(color: t_gray, fontSize: S.sp(16)),
                  ),
                ),
                SizedBox(height: S.h(30)),
              ],
            ),
          ),
        ),
        SizedBox(
          width: S.screenW(),
          child: CusRaisedButton(
            child: Text(
              "下单",
              style: TextStyle(fontSize: S.sp(14)),
            ),
            onPressed: _doYiOrder,
            borderRadius: 50,
          ),
        ),
      ],
    );
  }

  /// 约聊大师 摘要组件
  Widget _briefWt() {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: S.h(5)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CusRectField(
        controller: _briefCtrl,
        hintText: "该区域填写你的问题，问题描述的越清晰，详尽，大师们才能更完整、更高质量的为你解答",
        fromValue: "大师，帮我测算一下，玫瑰花有什么效果，喝了可以飞黄腾达吗？",
        autofocus: false,
        hideBorder: true,
        maxLines: 10,
        pdHor: 0,
      ),
    );
  }

  /// 约聊大师
  void _doYiOrder() async {
    if (widget.yiOrderData != null) {
      var yiOrder = widget.yiOrderData;
      if (yiOrder is SubmitLiuYaoData) {
        if (_briefCtrl.text.trim().isEmpty) {
          CusToast.toast(context, text: "请输入你要咨询的内容");
          return;
        }
      }
      var m = {
        "master_id": widget.cate.master_id,
        "yi_cate_id": widget.cate.yi_cate_id,
        "content": yiOrder.content.toJson(),
        "content_type": yiOrder.content_type,
      };
      if (yiOrder is SubmitSiZhuData || yiOrder is SubmitSiZhuData) {
        m.addAll({"comment": yiOrder.title + yiOrder.brief});
      }
      if (yiOrder is SubmitLiuYaoData) {
        m.addAll({"comment": _briefCtrl.text.trim()});
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
              UserYiOrderDoingPage(
                yiOrderId: res.id,
                backData: "下完大师订单后，携带数据返回",
              ),
            );
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

  @override
  void dispose() {
    _briefCtrl.dispose();
    super.dispose();
  }
}

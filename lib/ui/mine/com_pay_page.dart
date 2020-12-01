import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yiapp/func/cus_browser.dart';
import 'package:yiapp/widget/cus_dot_format.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/model/msg/msg-notify-his.dart';
import 'package:yiapp/service/api/api-pay.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/bus/im-bus.dart';
import 'package:yiapp/ui/home/home_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/28 11:53
// usage ：通用的支付页面
// ------------------------------------------------------

class ComPayPage extends StatefulWidget {
  final String tip; // 提示内容(如悬赏帖付款还是充值)
  final String b_type; // 支付类型
  final String orderId; // 订单号 id
  final num amt; // 默认的充值金额
  final String appBarName; // 默认名称为"支付"

  ComPayPage({
    this.tip,
    this.b_type,
    this.orderId,
    this.amt,
    this.appBarName: "支付",
    Key key,
  }) : super(key: key);

  @override
  _ComPayPageState createState() => _ComPayPageState();
}

class _ComPayPageState extends State<ComPayPage> {
  var _amtCtrl = TextEditingController(); // 充值金额输入框
  int _account_type = pay_alipay; // 0:支付宝 1:微信

  bool _defAmt = false; // 是否默认金额
  bool _recharge = false; // 是否充值类型
  bool _success = false; // 是否支付完成
  StreamSubscription<MsgNotifyHis> _busSub;

  @override
  void initState() {
    _defAmt = widget.amt == null ? false : true;
    _recharge = widget.b_type == b_recharge;
    _prepareBusEvent(); // 初始化监听
    super.initState();
  }

  /// 系统通知类型
  _prepareBusEvent() {
    _busSub = glbEventBus.on<MsgNotifyHis>().listen((event) {
      Log.info("监听到了吗");
      Log.info("返回的详情：${event.toJson()}");
      if (event.to == ApiBase.uid) {
        _success = true;
        Log.info("是发给本人的");
      }
    });
  }

  /// 支付功能
  void _doStartPay() async {
    num amt = 0;
    if (_amtCtrl.text.trim().isEmpty) {
      CusToast.toast(context, text: "请输入充值金额");
      return;
    } else {
      amt = num.parse(_amtCtrl.text.trim());
      if (amt == 0 || amt.isNaN) {
        CusToast.toast(context, text: "金额数必须大于0", milliseconds: 1500);
        return;
      }
    }
    Log.info("是充值：$_recharge");
    String trade_no = widget.b_type == b_recharge ? null : widget.orderId;
    Log.info("支付类型：${widget.b_type}、支付方式：$_account_type");
    Log.info("订单号：$trade_no、金额:$amt");
    String url = ApiPay.PayReqURL(widget.b_type, _account_type, trade_no, amt);
    if (url != null) CusBrowser.launchIn(url);

    // TODO 这里根据服务器返回的结果来显示ui和跳转
    // 这里让 _success 将等于服务器返回的交易结果
    if (_success) {
      CusToast.toast(context, text: "支付成功", milliseconds: 1500);
      CusRoute.push(context, HomePage());
    } else {
//      CusDialog.tip(
//        context,
//        title: "支付失败",
//        titleColor: Colors.red,
//      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: widget.appBarName,
        backData: "",
        leadingFn: () {
          if (!_recharge) {
            print(">>>不是充值");
            CusDialog.normal(
              context,
              title: "订单支付后大师们才可以看到哦",
              textAgree: "继续支付",
              fnDataCancel: "取消支付",
              cancelColor: btn_red,
              agreeColor: Colors.black,
              onThen: () => Navigator.pop(context),
            );
          }
          else {
            print(">>>是充值");
            Navigator.pop(context);
          }
        },
      ),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 15),
            child: CusText("${widget.tip}", t_primary, 30),
          ),
          CusRectField(
            controller: _amtCtrl,
            fromValue: _defAmt ? "${widget.amt}" : null,
            enable: _defAmt ? false : true,
            hintText: _recharge ? "请输入充值金额" : null,
            keyboardType: TextInputType.number,
            inputFormatters: [DotFormatter()],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: CusText("支付类型", t_primary, 30),
          ),
          _typeAliPay(),
          SizedBox(height: Adapt.px(5)),
          _typeWeChat(),
          SizedBox(height: Adapt.px(60)),
          CusRaisedBtn(
            text: "确定",
            textColor: t_gray,
            backgroundColor: fif_primary,
            onPressed: _doStartPay,
          ),
        ],
      ),
    );
  }

  /// 支付宝
  Widget _typeAliPay() {
    return InkWell(
      onTap: () => setState(() => _account_type = pay_alipay),
      child: Container(
        color: fif_primary,
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Radio(
              value: pay_alipay,
              groupValue: _account_type,
              activeColor: t_primary,
              onChanged: (val) => setState(() => _account_type = val),
            ),
            CusText("支付宝", t_gray, 30),
            Spacer(),
            Icon(
              IconData(0xe638, fontFamily: ali_font),
              color: Color(0xFF4C9FE3),
              size: Adapt.px(100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeWeChat() {
    return InkWell(
      onTap: () => setState(() => _account_type = pay_wechat),
      child: Container(
        color: fif_primary,
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Radio(
              value: pay_wechat,
              groupValue: _account_type,
              activeColor: t_primary,
              onChanged: (val) => setState(() => _account_type = val),
            ),
            CusText("微信", t_gray, 30),
            Spacer(),
            Icon(
              IconData(0xe607, fontFamily: ali_font),
              color: Color(0xFF5AB535),
              size: Adapt.px(100),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amtCtrl.dispose();
//    _busSub.cancel();
    super.dispose();
  }
}

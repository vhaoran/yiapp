import 'package:flutter/material.dart';
import 'package:yiapp/func/cus_browser.dart';
import 'package:yiapp/widget/cus_dot_format.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/service/api/api-pay.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/26 17:39
// usage ：充值页面
// ------------------------------------------------------

class RechargePage extends StatefulWidget {
  final num amt;
  final bool auto; // true 系统充值金额、 false 手动输入金额

  RechargePage({this.amt, this.auto: true, Key key}) : super(key: key);

  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  var _amtCtrl = TextEditingController(); // 充值金额输入框
  int _account_type = pay_alipay; // 0:支付宝 1:微信
  static const IconData _iconData0 = IconData(0xe6c0, fontFamily: ali_font);
  static const IconData _iconData1 = IconData(0xe638, fontFamily: ali_font);
  static const IconData _iconData2 = IconData(0xe607, fontFamily: ali_font);

  /// 添加资金账号
  void _doRecharge() async {
    num amt;
    if (widget.auto) {
      amt = widget.amt;
    } else {
      if (_amtCtrl.text.isEmpty) {
        CusToast.toast(context, text: "充值金额必须大于0", milliseconds: 1500);
        return;
      }
      if (_amtCtrl.text.isNotEmpty) {
        amt = num.parse(_amtCtrl.text);
        if (amt == 0 || amt.isNaN) {
          CusToast.toast(context, text: "充值金额必须大于0", milliseconds: 1500);
          return;
        }
      }
    }
    Log.info("amt:$amt");
    SpinKit.threeBounce(context);
    await Future.delayed(Duration(milliseconds: 1000));
    String url = ApiPay.PayReqURL(b_recharge, _account_type, "充值", amt);
    if (url != null) CusBrowser.launchIn(url);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "充值"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 10),
          // 自动充值
          if (widget.auto) _autoView(),
          // 手动输入充值
          if (!widget.auto) ...[
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 15),
              child: CusText("充值金额(￥)", t_primary, 30),
            ),
            CusRectField(
              controller: _amtCtrl,
              fromValue: "${widget.amt ?? ''}",
              hintText: "请输入充值金额",
              autofocus: false,
              keyboardType: TextInputType.number,
              inputFormatters: [DotFormatter()],
            ),
          ],
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                CusText("支付方式", t_primary, 30),
                CusText("  (1元=1元宝)", t_yi, 30),
              ],
            ),
          ),
          SizedBox(height: Adapt.px(20)),
          _typeAliPay(),
          SizedBox(height: Adapt.px(5)),
          _typeWeChat(),
          SizedBox(height: Adapt.px(100)),
          CusBtn(
            text: "确定",
            textColor: t_gray,
            backgroundColor: Colors.blueGrey,
            onPressed: _doRecharge,
          ),
        ],
      ),
    );
  }

  Widget _autoView() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 15),
      color: fif_primary,
      child: Row(
        children: <Widget>[
          SizedBox(width: 5),
          Icon(_iconData0, color: t_red, size: 44),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${widget.amt}元宝",
                style: TextStyle(fontSize: 18, color: t_yi),
              ),
              SizedBox(height: 5),
              Text(
                "鸿运来充值服务",
                style: TextStyle(fontSize: 14, color: t_gray),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 支付宝
  Widget _typeAliPay() {
    return GestureDetector(
      onTap: () {
        _account_type = pay_alipay;
        setState(() {});
      },
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
            Icon(_iconData1, color: Color(0xFF4C9FE3), size: Adapt.px(100)),
          ],
        ),
      ),
    );
  }

  Widget _typeWeChat() {
    return GestureDetector(
      onTap: () {
        _account_type = pay_wechat;
        setState(() {});
      },
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
            Icon(_iconData2, color: Color(0xFF5AB535), size: Adapt.px(100)),
          ],
        ),
      ),
    );
  }
}

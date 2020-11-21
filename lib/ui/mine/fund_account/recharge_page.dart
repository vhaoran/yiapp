import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/api_business_type.dart';
import 'package:yiapp/complex/class/cus_dot_format.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/service/api/api-pay.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/26 17:39
// usage ：充值页面
// ------------------------------------------------------

class RechargePage extends StatefulWidget {
  final num score;

  RechargePage({this.score, Key key}) : super(key: key);

  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  var _amtCtrl = TextEditingController(); // 充值金额输入框
  int _account_type = pay_alipay; // 0:支付宝 1:微信

  /// 添加资金账号
  void _doAdd() async {
    num amt = num.parse(_amtCtrl.text);
    if (_amtCtrl.text.isEmpty || amt == 0 || amt.isNaN) {
      CusToast.toast(context, text: "充值金额必须大于0", milliseconds: 1500);
      return;
    }
    Debug.log("amt:$amt");
    String url = ApiPay.PayReqURL(b_recharge, _account_type, "充值", amt);
    if (url != null) ApiBrowser.launchIn(url);
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40, bottom: 15),
            child: CusText("充值金额(￥)", t_primary, 30),
          ),
          CusRectField(
            controller: _amtCtrl,
            fromValue: "${widget.score}",
            hintText: "请输入充值金额",
            keyboardType: TextInputType.number,
            inputFormatters: [DotFormatter()],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: CusText("支付类型", t_primary, 30),
          ),
          SizedBox(height: Adapt.px(20)),
          _typeAliPay(),
          SizedBox(height: Adapt.px(5)),
          _typeWeChat(),
          SizedBox(height: Adapt.px(60)),
          CusRaisedBtn(
            text: "确定",
            textColor: t_gray,
            backgroundColor: fif_primary,
            onPressed: _doAdd,
          ),
        ],
      ),
    );
  }

  /// 支付宝
  Widget _typeAliPay() {
    return Container(
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
    );
  }

  Widget _typeWeChat() {
    return Container(
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
    );
  }
}

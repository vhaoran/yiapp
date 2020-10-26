import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/small/cus_checked.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/26 17:39
// usage ：充值页面
// ------------------------------------------------------

class RechargePage extends StatefulWidget {
  RechargePage({Key key}) : super(key: key);

  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  var _nameCtrl = TextEditingController(); // 充值金额输入框
  String _err;
  int _account_type = pay_alipay; // 0:支付宝 1:微信

  /// 添加资金账号
  void _doAdd() async {}

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
            child: CusText("充值金额", t_primary, 30),
          ),
          CusRectField(
            controller: _nameCtrl,
            errorText: _err,
            hintText: "请输入充值金额",
            onlyChinese: true,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: CusText("支付类型", t_primary, 30),
          ),
          SizedBox(height: Adapt.px(20)),
          _typeAliPay(),
          SizedBox(height: Adapt.px(30)),
          _typeWeChat(),
//          _typeTwo(),
          SizedBox(height: Adapt.px(60)),
          CusRaisedBtn(
            text: "确定",
            backgroundColor: Colors.blueGrey,
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          CusChecked(
            defValue: pay_alipay,
            fromValue: _account_type,
          ),
          SizedBox(width: Adapt.px(30)),
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          CusChecked(
            defValue: pay_wechat,
            fromValue: _account_type,
          ),
          SizedBox(width: Adapt.px(30)),
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

  Widget _typeTwo() {
    bool checked = _account_type == pay_wechat;
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            if (_account_type != pay_wechat) {
              _account_type = pay_wechat;
              setState(() {});
            }
          },
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: checked ? Color(0xFFEA742E) : Colors.grey,
            ),
            child: checked
                ? Icon(FontAwesomeIcons.check, size: 12, color: Colors.white)
                : null,
          ),
        ),
        CusText("微信", t_gray, 30),
        Spacer(),
        Icon(
          IconData(0xe607, fontFamily: ali_font),
          color: Color(0xFF5AB535),
          size: Adapt.px(100),
        ),
      ],
    );
  }
}

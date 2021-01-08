import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/pays/bankcard_res.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 上午9:36
// usage ：修改提现账号
// ------------------------------------------------------

class ChBankCardPage extends StatefulWidget {
  final BankCardRes card;

  ChBankCardPage({this.card, Key key}) : super(key: key);

  @override
  _ChBankCardPageState createState() => _ChBankCardPageState();
}

class _ChBankCardPageState extends State<ChBankCardPage> {
  var _bankNameCtrl = TextEditingController(); // 银行名称
  var _cardCodeCtrl = TextEditingController(); // 银行卡号
  var _bankAddrCtrl = TextEditingController(); // 开户行地址
  var _bankIdCtrl = TextEditingController(); // 开户行id
  String _err; // 不满足表单要求时的提示信息

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "修改提现账号"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          SizedBox(height: S.h(10)),
          _comTextField(
            controller: _bankNameCtrl,
            title: "开户行",
            fromValue: widget.card.bank_name,
          ),
          _comTextField(
            controller: _cardCodeCtrl,
            title: "卡号",
            fromValue: widget.card.card_code,
          ),
          _comTextField(
            controller: _bankAddrCtrl,
            title: "开户行地址",
            fromValue: widget.card.branch_bank_addr,
          ),
          _comTextField(
            controller: _bankIdCtrl,
            title: "开户行id",
            fromValue: widget.card.branch_band_id,
          ),
          SizedBox(height: S.h(50)),
          CusRaisedButton(
            child: Text(
              "确定",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
            backgroundColor: Colors.lightBlue,
            borderRadius: 50,
            onPressed: _doVerify,
          ),
        ],
      ),
    );
  }

  /// 验证输入信息
  void _doVerify() {
    setState(() {
      _err = null;
      if (_bankNameCtrl.text.trim().isEmpty)
        _err = "请填写开户行名称";
      else if (_cardCodeCtrl.text.trim().isEmpty)
        _err = "请填写卡号";
      else if (_bankAddrCtrl.text.trim().isEmpty)
        _err = "请填写开户行地址";
      else if (_bankIdCtrl.text.trim().isEmpty) _err = "请填写开户行id";
    });
    if (_err != null) {
      CusToast.toast(context, text: _err);
      return;
    }
    Log.info("开户行：${_bankNameCtrl.text}");
    Log.info("卡号：${_cardCodeCtrl.text}");
    Log.info("开户行地址：${_bankAddrCtrl.text}");
    Log.info("开户行id：${_bankIdCtrl.text}");
    _doChBankCard();
  }

  /// 修改提现账号
  void _doChBankCard() async {
    var m = {
      "acc_type": "master",
      "m_or_b_id": ApiBase.uid,
      "m": {
        "bank_name": _bankNameCtrl.text.trim(),
        "card_code": _cardCodeCtrl.text.trim(),
        "branch_bank_addr": _bankAddrCtrl.text.trim(),
        "branch_bank_id": _bankIdCtrl.text.trim(),
      },
    };
    try {
      bool ok = await ApiAccount.bankCardInfoCh(m);
      if (ok) {
        CusToast.toast(context, text: "修改成功");
        Navigator.of(context).pop("");
      }
    } catch (e) {
      Log.error("大师修改提现账号出现异常：$e");
    }
  }

  /// 通用输入框
  Widget _comTextField(
      {TextEditingController controller, String title, String fromValue}) {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(color: t_yi, fontSize: S.sp(15))),
          Expanded(
            child: CusRectField(
              controller: controller,
              fromValue: fromValue,
              autofocus: false,
              hideBorder: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bankNameCtrl.dispose();
    _cardCodeCtrl.dispose();
    _bankAddrCtrl.dispose();
    _bankIdCtrl.dispose();
    super.dispose();
  }
}

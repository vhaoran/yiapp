import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/service/api/api-account.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/23 19:06
// usage ：添加资金账号
// ------------------------------------------------------

class AddFundAccount extends StatefulWidget {
  AddFundAccount({Key key}) : super(key: key);

  @override
  _AddFundAccountState createState() => _AddFundAccountState();
}

class _AddFundAccountState extends State<AddFundAccount> {
  var _nameCtrl = TextEditingController(); // 账号输入框
  String _err;
  int _accountType = pay_alipay; // 0:支付宝 1:微信

  /// 添加资金账号
  void _doAdd() async {
    setState(() {
      _err = _nameCtrl.text.isEmpty ? "账号名称不能为空" : null;
    });
    if (_err != null) return;
    var m = {
      "account_type": _accountType,
      "account_code": _nameCtrl.text.trim(),
      "is_default": 0,
    };
    try {
      var res = await ApiAccount.accountSet(m);
      if (res != null) {
        CusToast.toast(context, text: "添加成功");
        Navigator.of(context).pop("");
      }
    } catch (e) {
      Log.error("添加资金账号出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "添加资金账号"),
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
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: CusText("设置账号", t_primary, 30),
          ),
          CusRectField(
            controller: _nameCtrl,
            errorText: _err,
            hintText: "请输入账号名称",
            onlyChinese: true,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 50),
            child: Row(
              children: <Widget>[
                CusText("支付类型", t_primary, 30),
                SizedBox(width: Adapt.px(20)),
                ..._accountCtr(value: pay_alipay, text: "支付宝"),
                SizedBox(width: Adapt.px(10)),
                ..._accountCtr(value: pay_wechat, text: "微信"),
              ],
            ),
          ),
          CusBtn(
            text: "确定",
            backgroundColor: Colors.blueGrey,
            onPressed: _doAdd,
          ),
        ],
      ),
    );
  }

  /// 选择支付类型
  List<Widget> _accountCtr({int value, String text}) {
    return <Widget>[
      Radio(
        value: value,
        groupValue: _accountType,
        activeColor: t_primary,
        onChanged: (val) {
          if (_err != null) _err = null;
          _accountType = val;
          setState(() {});
        },
      ),
      CusText(text, t_gray, 30),
    ];
  }
}

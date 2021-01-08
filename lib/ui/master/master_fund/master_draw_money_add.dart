import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/cus_dot_format.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/6 上午11:02
// usage ：大师提现账号申请
// ------------------------------------------------------

class MasterDrawMoneyAdd extends StatefulWidget {
  MasterDrawMoneyAdd({Key key}) : super(key: key);

  @override
  _MasterDrawMoneyAddState createState() => _MasterDrawMoneyAddState();
}

class _MasterDrawMoneyAddState extends State<MasterDrawMoneyAdd> {
  var _moneyCtrl = TextEditingController(); // 提现金额

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "提现"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(15)),
        children: <Widget>[
          SizedBox(height: S.h(20)),
          CusRectField(
            controller: _moneyCtrl,
            hintText: "请输入提现金额",
            // onlyNumber: true, 提现整数
            keyboardType: TextInputType.number,
            inputFormatters: [DotFormatter()],
          ),
          SizedBox(height: S.h(50)),
          CusRaisedButton(
            child: Text("确定"),
            borderRadius: 100,
            backgroundColor: Colors.lightBlue,
            onPressed: _doDrawMoney,
          ),
        ],
      ),
    );
  }

  /// 提现
  void _doDrawMoney() async {
    if (_moneyCtrl.text.trim().isEmpty) {
      CusToast.toast(context, text: "请输入提现金额");
      return;
    }
    num amt = num.parse(_moneyCtrl.text.trim());
    if (amt <= 0) {
      CusToast.toast(context, text: "提现金额必须大于0");
      return;
    }
    try {
      var res = await ApiAccount.masterDrawMoneyAdd(amt);
      if (res != null) {
        CusDialog.tip(
          context,
          title: "提现申请已提交",
          onApproval: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      if (e.toString().contains("余额不足")) {
        CusDialog.tip(context, title: "余额不足");
      }
      Log.error("大师提现出现异常：$e");
    }
  }

  @override
  void dispose() {
    _moneyCtrl.dispose();
    super.dispose();
  }
}

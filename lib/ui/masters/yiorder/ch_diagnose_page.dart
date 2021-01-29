import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午4:49
// usage ：修改大师订单的测算结果
// ------------------------------------------------------

class ChDiagnosePage extends StatefulWidget {
  final YiOrder yiOrder;

  ChDiagnosePage({this.yiOrder, Key key}) : super(key: key);

  @override
  _ChDiagnosePageState createState() => _ChDiagnosePageState();
}

class _ChDiagnosePageState extends State<ChDiagnosePage> {
  var _diagnoseCtrl = TextEditingController(); // 设置、修改测算结果

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "修改测算结果"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: S.w(10)),
      children: <Widget>[
        SizedBox(height: S.h(10)),
        CusRectField(
          controller: _diagnoseCtrl,
          hintText: widget.yiOrder.diagnose.isEmpty ? "请输入此订单的测算结果" : "",
          maxLines: 8,
          fromValue: widget.yiOrder.diagnose,
        ),
        SizedBox(height: S.h(10)),
        CusRaisedButton(
          child: Text(
            "确认",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
          onPressed: _setDiagnose,
          borderRadius: 50,
        ),
      ],
    );
  }

  /// 设置/修改 测算结果
  void _setDiagnose() async {
    try {
      var m = {
        "id": widget.yiOrder.id,
        "diagnose": _diagnoseCtrl.text.trim(),
      };
      bool ok = await ApiYiOrder.yiOrderSetDiagnose(m);
      if (ok) {
        String tip = widget.yiOrder.diagnose.isEmpty ? "设置成功" : "修改成功";
        CusToast.toast(context, text: tip);
        Navigator.of(context).pop("");
      }
    } catch (e) {
      Log.error("大师修改或者设置测算结果出现异常：$e");
    }
  }

  @override
  void dispose() {
    _diagnoseCtrl.dispose();
    super.dispose();
  }
}

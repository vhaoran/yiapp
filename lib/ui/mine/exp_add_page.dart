import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/30 下午3:24
// usage ：用户对大师订单进行点评
// ------------------------------------------------------

class ExpAddPage extends StatefulWidget {
  final YiOrder yiOrder;

  ExpAddPage({this.yiOrder, Key key}) : super(key: key);

  @override
  _ExpAddPageState createState() => _ExpAddPageState();
}

class _ExpAddPageState extends State<ExpAddPage> {
  var _textCtrl = TextEditingController();
  int _stat = rate_best; // 评价类别，默认好评

  @override
  void initState() {
    Log.info("当前评价的订单id：${widget.yiOrder.id}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "评价大师订单"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.h(10)),
        children: <Widget>[
          SizedBox(height: S.h(15)),
          Text(
            "订单评价",
            style: TextStyle(color: t_primary, fontSize: S.sp(15)),
          ),
          SizedBox(height: S.h(5)),
          CusRectField(
            controller: _textCtrl,
            hintText: "请输入订单评价...",
            maxLines: 8,
          ),
          SizedBox(height: S.h(15)),
          Text(
            "订单评分",
            style: TextStyle(color: t_primary, fontSize: S.sp(15)),
          ),
          // 选择评价标准
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _selectStat(rate_best, "好评"),
              _selectStat(rate_mid, "中评"),
              _selectStat(rate_bad, "差评"),
            ],
          ),
          SizedBox(height: S.h(50)),
          CusRaisedButton(
            child: Text("提交评价"),
            colors: [t_yi, t_red],
            borderRadius: 50,
            onPressed: _doExp,
          ),
        ],
      ),
    );
  }

  /// 大师订单评价
  void _doExp() async {
    if (_textCtrl.text.isEmpty) {
      CusToast.toast(context, text: "评价内容不能为空");
      return;
    }
    var m = {
      "order_id": widget.yiOrder.id,
      "text": _textCtrl.text.trim(),
      "exp_result": _stat,
    };
    Log.info("提交评价大师订单数据：$m");
    try {
      var res = await ApiYiOrder.yiOrderExpAdd(m);
      if (res != null) {
        CusToast.toast(context, text: "评价成功");
        Navigator.of(context).pop("");
      }
    } catch (e) {
      if (e.toString().contains("订单已评价")) {
        CusToast.toast(context, text: "~该订单已评价过了");
        Navigator.of(context).pop(); // 已评价返回上一界面并刷新
      }
      Log.error("用户提交大师订单评价出现异常：$e");
    }
  }

  /// 选择评价类别
  Widget _selectStat(int value, String text) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: _stat,
          activeColor: t_primary,
          onChanged: (val) => setState(() => _stat = val),
        ),
        Text(text, style: TextStyle(color: t_gray, fontSize: S.sp(15))),
      ],
    );
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }
}

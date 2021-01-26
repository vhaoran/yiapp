import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bo/broker_master_cate.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/ui/vip/yiorder/user_yiorder_doing_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/25 上午11:08
// usage ：大师订单下单(默认四柱)
// ------------------------------------------------------

class TalkAboutMaster extends StatefulWidget {
  final BrokerMasterCate data;

  TalkAboutMaster({this.data, Key key}) : super(key: key);

  @override
  _TalkAboutMasterState createState() => _TalkAboutMasterState();
}

class _TalkAboutMasterState extends State<TalkAboutMaster> {
  var _nameCtrl = TextEditingController(); // 姓名
  var _contentCtrl = TextEditingController(); // 内容输入框
  int _sex = male; // 0 女，1 男
  String _timeStr = ""; // 用来显示时间
  YiDateTime _yi;
  bool _isLunar = false; // 是否阴历

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "提交问题"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    TextStyle tYi = TextStyle(color: t_yi, fontSize: S.sp(15));
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(15)),
        children: <Widget>[
          SizedBox(height: S.h(5)),
          // 服务类型
          _comBg(children: <Widget>[
            Text("亲测服务", style: tYi),
            Expanded(
              child: CusRectField(
                hintText: "${widget.data.yi_cate_name}",
                enable: false,
                autofocus: false,
                hideBorder: true,
              ),
            ),
          ]),
          // 姓名
          _comBg(children: <Widget>[
            Text("姓名", style: tYi),
            Expanded(
              child: CusRectField(
                controller: _nameCtrl,
                hintText: "可默认匿名",
                autofocus: false,
                hideBorder: true,
              ),
            ),
          ]),
          // 选择性别
          _comBg(children: <Widget>[
            Text("性别", style: tYi),
            _selectCtr(male, "男"),
            SizedBox(width: S.w(10)),
            _selectCtr(female, "女"),
          ]),
          // 选择出生日期
          _choseDate(),
          SizedBox(height: S.h(5)),
          CusRectField(
            controller: _contentCtrl,
            hintText: "请详细描述你的问题",
            maxLines: 10,
            autofocus: false,
          ),
          SizedBox(height: S.h(50)),
          // 提交
          CusRaisedButton(
              child: Text("提交"), borderRadius: 50, onPressed: _doVerify),
        ],
      ),
    );
  }

  void _doVerify() async {
    String err;
    setState(() {
      if (_yi == null)
        err = "未选择日期";
      else if (_contentCtrl.text.isEmpty) err = "描述信息不能为空";
    });
    if (err != null) {
      CusToast.toast(context, text: err);
      return;
    }
    String name = _nameCtrl.text.trim().isEmpty ? "匿名" : _nameCtrl.text.trim();
    SiZhuContent siZhu = SiZhuContent(
      is_solar: !_isLunar,
      name: name,
      is_male: _sex == male ? true : false,
      year: _yi.year,
      month: _yi.month,
      day: _yi.day,
      hour: _yi.oldTime.hour,
      minute: _yi.oldTime.minute,
    );
    var m = {
      "master_id": widget.data.master_id,
      "comment": _contentCtrl.text.trim(),
      "yi_cate_id": widget.data.yi_cate_id,
      "si_zhu": siZhu.toJson(),
    };
    Log.info("用户提交下大师单的数据：${m.toString()}");
    SpinKit.threeBounce(context);
    try {
      YiOrder order = await ApiYiOrder.yiOrderAdd(m);
      if (order != null) {
        Navigator.pop(context);
        Log.info("用户下单后返回的订单id：${order.id}");
        CusToast.toast(context, text: "下单成功", pos: ToastPos.bottom);
        var payData =
            PayData(amt: widget.data.price, b_type: b_yi_order, id: order.id);
        BalancePay(context, data: payData, onSuccess: () {
          CusRoute.pushReplacement(
            context,
            UserYiOrderDoingPage(yiOrderId: order.id),
          );
        });
      }
    } catch (e) {
      Log.error("出现异常：$e");
    }
  }

  /// 选择出生日期
  Widget _choseDate() {
    _timeStr =
        _yi == null ? "请选择出生日期" : TimeUtil.YMDHM(isSolar: !_isLunar, date: _yi);
    return _comBg(
      children: <Widget>[
        Text("出生日期", style: TextStyle(color: t_yi, fontSize: S.sp(15))),
        Expanded(
          child:
              CusRectField(hintText: _timeStr, hideBorder: true, enable: false),
        ),
        CusRaisedButton(
          padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(3)),
          backgroundColor: Colors.grey,
          child: Text("选择", style: TextStyle(color: Colors.black)),
          onPressed: () => TimePicker(
            context,
            pickMode: PickerMode.full,
            showLunar: true,
            isLunar: (val) => setState(() => _isLunar = val),
            onConfirm: (val) => setState(() => _yi = val),
          ),
        ),
        SizedBox(width: S.w(10)),
      ],
    );
  }

  /// 选择性别组件
  Widget _selectCtr(int value, String text) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: _sex,
          activeColor: t_primary,
          onChanged: (val) => setState(() => _sex = val),
        ),
        Text(text, style: TextStyle(color: t_gray, fontSize: S.sp(15))),
      ],
    );
  }

  /// 通用背景组件
  Widget _comBg({List<Widget> children}) {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.symmetric(vertical: S.h(5)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: <Widget>[...children]),
    );
  }
}

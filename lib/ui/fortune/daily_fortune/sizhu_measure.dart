import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/complex/master_order_data.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/widget/master/broker_master_list_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/22 16:02
// usage ：四柱测算
// ------------------------------------------------------

class SiZhuMeasure extends StatefulWidget {
  SiZhuMeasure({Key key}) : super(key: key);

  @override
  _SiZhuMeasureState createState() => _SiZhuMeasureState();
}

class _SiZhuMeasureState extends State<SiZhuMeasure> {
  var _nameCtrl = TextEditingController(); // 姓名
  var _commentCtrl = TextEditingController(); // 内容输入框
  int _sex = male; // 0 女，1 男
  bool _isLunar = false;
  YiDateTime _yi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "四柱测算", backData: "清理kv_yiorder"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            "填写个人基本信息",
            style: TextStyle(color: t_primary, fontSize: S.sp(16)),
          ),
        ),
        _nameInput(), // 姓名输入框
        _selectSex(), // 选择性别
        _selectDate(), // 选择出生日期
        SizedBox(height: S.h(5)),
        CusRectField(
          controller: _commentCtrl,
          hintText: "请详细描述你的问题",
          maxLines: 10,
          autofocus: false,
        ),
        SizedBox(height: S.h(35)),
        // 大师亲测
        CusRaisedButton(child: Text("大师亲测"), onPressed: _doSelectMaster),
      ],
    );
  }

  /// 跳往选择大师页面
  void _doSelectMaster() async {
    String err;
    if (_yi == null)
      err = "未选择日期";
    else if (_commentCtrl.text.isEmpty) err = "描述内容不能为空";
    setState(() {});
    if (err != null) {
      CusToast.toast(context, text: err);
      return;
    }
    var siZhu = SiZhuContent(
      is_solar: !_isLunar,
      name: _nameCtrl.text.trim(),
      is_male: _sex == male ? true : false,
    );
    siZhu.ymdhm(_yi.toDateTime());
    var data = MasterOrderData(comment: _commentCtrl.text.trim(), siZhu: siZhu);
    Log.info("当前提交四柱的信息：${data.toJson()}");
    if (await KV.getStr(kv_order) != null) await KV.remove(kv_order); // 清除上次数据
    // 存储大师订单数据
    bool ok = await KV.setStr(kv_order, json.encode(data.toJson()));
    if (ok) CusRoute.push(context, BrokerMasterListPage(showLeading: true));
  }

  /// 姓名输入框
  Widget _nameInput() {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: <Widget>[
        Text("姓名", style: TextStyle(color: t_yi, fontSize: S.sp(15))),
        Expanded(
          child: CusRectField(
            controller: _nameCtrl,
            hintText: "(可不填)",
            autofocus: false,
            hideBorder: true,
          ),
        ),
      ]),
    );
  }

  /// 选择性别
  Widget _selectSex() {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: <Widget>[
        Text("性别", style: TextStyle(color: t_yi, fontSize: S.sp(15))),
        Radio(
          value: male,
          groupValue: _sex,
          activeColor: t_primary,
          onChanged: (val) => setState(() => _sex = val),
        ),
        Text("男", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
        SizedBox(width: S.w(10)),
        Radio(
          value: female,
          groupValue: _sex,
          activeColor: t_primary,
          onChanged: (val) => setState(() => _sex = val),
        ),
        Text("女", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
      ]),
    );
  }

  /// 选择出生日期
  Widget _selectDate() {
    String time = _yi == null
        ? "请选择出生日期"
        : TimeUtil.YMDHM(
            isSolar: !_isLunar, date: _isLunar ? _yi.toSolar() : _yi);
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: <Widget>[
        Text("出生日期", style: TextStyle(color: t_yi, fontSize: S.sp(15))),
        Expanded(
          child: CusRectField(hintText: time, hideBorder: true, enable: false),
        ),
        CusRaisedButton(
          padding: EdgeInsets.symmetric(vertical: S.h(4), horizontal: S.w(12)),
          backgroundColor: Colors.grey,
          child: Text("选择", style: TextStyle(color: Colors.black)),
          onPressed: () {
            _isLunar = false;
            TimePicker(
              context,
              pickMode: PickerMode.full,
              showLunar: true,
              isLunar: (val) => setState(() => _isLunar = val),
              onConfirm: (val) => setState(() => _yi = val),
            );
          },
        ),
        SizedBox(width: S.w(10)),
      ]),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }
}

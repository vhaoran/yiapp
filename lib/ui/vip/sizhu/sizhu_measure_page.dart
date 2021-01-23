import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/model/orders/sizhu_res.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 上午11:27
// usage ：四柱测算页面
// ------------------------------------------------------

class SiZhuMeasurePage extends StatefulWidget {
  SiZhuMeasurePage({Key key}) : super(key: key);

  @override
  _SiZhuMeasurePageState createState() => _SiZhuMeasurePageState();
}

class _SiZhuMeasurePageState extends State<SiZhuMeasurePage> {
  var _nameCtrl = TextEditingController(); // 姓名
  int _sex = male; // 默认性别男
  bool _isLunar = false;
  YiDateTime _yi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "四柱测算"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: S.w(10)),
            children: <Widget>[
              SizedBox(height: S.h(25)),
              Center(
                child: Text(
                  "填写个人基本信息",
                  style: TextStyle(color: t_primary, fontSize: S.sp(16)),
                ),
              ),
              SizedBox(height: S.h(10)),
              _nameInputWt(), // 姓名输入框
              _selectSexWt(), // 选择性别
              _selectDateWt(), // 选择出生日期
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: CusRaisedButton(
                child: Text("悬赏帖求测", style: TextStyle(fontSize: S.sp(15))),
                backgroundColor: Color(0xFFE96C62),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: CusRaisedButton(
                child: Text("闪断帖求测", style: TextStyle(fontSize: S.sp(15))),
                backgroundColor: Color(0xFFED9951),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: CusRaisedButton(
                child: Text("大师亲测", style: TextStyle(fontSize: S.sp(15))),
                backgroundColor: Color(0xFFE8493E),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 跳往选择大师页面
  void _doSelectMaster() async {
    String err;
    if (_yi == null) err = "未选择日期";
    setState(() {});
    if (err != null) {
      CusToast.toast(context, text: err);
      return;
    }
    var siZhu = SiZhuRes(
      is_solar: !_isLunar,
      name: _nameCtrl.text.trim(),
      is_male: _sex == male ? true : false,
    );
    siZhu.ymdhm(_yi.toDateTime());
  }

  /// 姓名输入框
  Widget _nameInputWt() {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: S.h(15)),
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
  Widget _selectSexWt() {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: S.h(15)),
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
  Widget _selectDateWt() {
    String time = _yi == null
        ? "请选择出生日期"
        : TimeUtil.YMDHM(
            isSolar: !_isLunar, date: _isLunar ? _yi.toSolar() : _yi);
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
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
          borderRadius: 50,
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
    super.dispose();
  }
}

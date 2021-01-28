import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/bbs/submit_sizhu_data.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/ui/question/ask_question/que_container.dart';
import 'package:yiapp/ui/vip/sizhu/sizhu_bottom_buttons_wt.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
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
  var _titleCtrl = TextEditingController(); // 标题
  var _briefCtrl = TextEditingController(); // 摘要
  var _yiDateTime = YiDateTime(); // 出生日期
  bool _isLunar = false; // 是否阴历（默认阳历）
  int _sex = male; // 性别（默认男）

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "四柱测算"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: S.w(10)),
      children: <Widget>[
        Container(
          height: S.screenH() - S.h(bottom_space),
          child: Column(
            children: <Widget>[
              SizedBox(height: S.h(5)),
              Center(
                child: Text(
                  "填写个人基本信息",
                  style: TextStyle(color: t_primary, fontSize: S.sp(16)),
                ),
              ),
              SizedBox(height: S.h(10)),
              _nameWt(), // 设置姓名
              _sexWt(), // 设置性别
              _birthDateWt(), // 设置出生日期
              _titleWt(), // 设置标题
              _briefWt(), // 设置摘要
            ],
          ),
        ),
        _bottomButtonsWt(), // 底部求测按钮
      ],
    );
  }

  Widget _bottomButtonsWt() {
    String name = _nameCtrl.text.trim().isEmpty ? "匿名" : _nameCtrl.text.trim();
    var content = SiZhuContent(
      is_solar: !_isLunar,
      name: name,
      is_male: _sex == male,
      birth_date: _showSelectTime,
      year: _yiDateTime.year,
      month: _yiDateTime.month,
      day: _yiDateTime.day,
      hour: _yiDateTime.hour,
      minute: _yiDateTime.minute,
    );
    var siZhuData = SubmitSiZhuData(
      amt: 0,
      level_id: 0,
      title: _titleCtrl.text.trim(),
      brief: _briefCtrl.text.trim(),
      content_type: submit_sizhu,
      content: content,
    );
    if (siZhuData != null) {
      return SiZhuBottomButtonsWt(siZhuData: siZhuData);
    }
    return SizedBox.shrink();
  }

  /// 姓名组件
  Widget _nameWt() {
    return QueContainer(
      title: "姓名",
      child: Expanded(
        child: CusRectField(
          controller: _nameCtrl,
          hintText: "可默认匿名",
          autofocus: false,
          hideBorder: true,
          onChanged: () => setState(() {}),
        ),
      ),
    );
  }

  /// 性别组件
  Widget _sexWt() {
    return QueContainer(
      title: "性别",
      child: Row(children: <Widget>[
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

  /// 出生日期组件
  Widget _birthDateWt() {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: S.h(10)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: <Widget>[
        Text("出生日期", style: TextStyle(color: t_yi, fontSize: S.sp(15))),
        Expanded(
          child: CusRectField(
              hintText: _showSelectTime, hideBorder: true, enable: false),
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
              onConfirm: (val) => setState(() => _yiDateTime = val),
            );
          },
        ),
        SizedBox(width: S.w(10)),
      ]),
    );
  }

  /// 标题组件、如果是大师订单，则合并标题和摘要为同一个数据
  Widget _titleWt() {
    return QueContainer(
      title: "标题",
      child: Expanded(
        child: CusRectField(
          controller: _titleCtrl,
          hintText: "请输入标题",
          fromValue: "大师，我想问一下，玫瑰花现在多少钱",
          autofocus: false,
          hideBorder: true,
          onChanged: () => setState(() {}),
        ),
      ),
    );
  }

  /// 摘要组件
  Widget _briefWt() {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: S.h(15)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CusRectField(
        controller: _briefCtrl,
        hintText: "该区域填写你的问题，问题描述的越清晰，详尽，大师们才能更完整、更高质量的为你解答",
        fromValue: "大师，帮我测算一下，玫瑰花有什么效果，喝了可以飞黄腾达吗？",
        autofocus: false,
        hideBorder: true,
        maxLines: 10,
        pdHor: 0,
        onChanged: () => setState(() {}),
      ),
    );
  }

  /// 显示选择的日期
  String get _showSelectTime {
    if (_yiDateTime.year == 0) {
      return "请选择出生日期";
    }
    var date = _isLunar ? _yiDateTime.toSolar() : _yiDateTime;
    return TimeUtil.YMDHM(isSolar: !_isLunar, date: date, comment: true);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _briefCtrl.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/bbs/submit_hehun_data.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/ui/question/ask_question/que_container.dart';
import 'package:yiapp/ui/vip/hehun/hehun_bottom_buttons.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/25 下午4:06
// usage ：合婚测算页面
// ------------------------------------------------------

class HeHunMeasurePage extends StatefulWidget {
  HeHunMeasurePage({Key key}) : super(key: key);

  @override
  _HeHunMeasurePageState createState() => _HeHunMeasurePageState();
}

class _HeHunMeasurePageState extends State<HeHunMeasurePage> {
  bool _isLunarMale = false; // 男生是否选择了阴历
  bool _isLunarFemale = false; // 女生是否选择了阴历
  var _maleYiDate = YiDateTime(); // 男生出生日期
  var _femaleYiDate = YiDateTime(); // 女生出生日期
  var _maleNameCtrl = TextEditingController(); // 男生姓名
  var _femaleNameCtrl = TextEditingController(); // 女生姓名
  var _commentCtrl = TextEditingController(); // 内容输入框
  var _titleCtrl = TextEditingController(); // 标题
  var _briefCtrl = TextEditingController(); // 摘要

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "合婚测算"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: S.h(5)),
              Center(
                child: Text(
                  "填写个人基本信息",
                  style: TextStyle(color: t_primary, fontSize: S.sp(16)),
                ),
              ),
              SizedBox(height: S.h(10)),
              _inputWt(_maleNameCtrl, "男方姓名"), // 设置男方姓名
              _birthDateWt(_maleYiDate, true), // 设置男方出生日期
              SizedBox(height: S.h(15)),
              _inputWt(_femaleNameCtrl, "女方姓名"), // 设置女方姓名
              _birthDateWt(_femaleYiDate, false), // 设置女方出生日期
              SizedBox(height: S.h(10)),
              _titleWt(), // 设置标题
              _briefWt(), // 设置摘要
              SizedBox(height: S.h(30)),
              // 大师亲测
            ],
          ),
          _bottomButtonsWt(), // 底部求测按钮
        ],
      ),
    );
  }

  Widget _bottomButtonsWt() {
    var content = HeHunContent(
      name_male: _maleNameCtrl.text.trim(),
      name_female: _femaleNameCtrl.text.trim(),
      is_solar_male: !_isLunarMale,
      is_solar_female: !_isLunarFemale,
    );
    content.ymdhm(_maleYiDate.toDateTime(), _femaleYiDate.toDateTime());
    var heHunData = SubmitHeHunData(
      amt: 0,
      level_id: 0,
      title: _titleCtrl.text.trim(),
      brief: _briefCtrl.text.trim(),
      content_type: submit_hehun,
      content: content,
    );
    if (heHunData != null) {
      return HeHunBottomButtons(heHunData: heHunData);
    }
    return SizedBox.shrink();
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

  /// 男/女 姓名输入框
  Widget _inputWt(TextEditingController ctrl, String text) {
    return Container(
      constraints: BoxConstraints(minHeight: S.h(45)),
      padding: EdgeInsets.symmetric(horizontal: S.w(5)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Row(
        children: <Widget>[
          Text(
            text, // 姓名
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
          Expanded(
            child: TextField(
              controller: ctrl,
              style: TextStyle(fontSize: S.h(15), color: Colors.grey),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: S.w(10)),
                hintText: "请输入名字",
                hintStyle: TextStyle(fontSize: S.h(15), color: Colors.grey),
              ),
              onChanged: (val) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  /// 男/女 选择出生日期组件
  Widget _birthDateWt(YiDateTime yi, bool isMale) {
    String time;
    if (yi.year <= 0) {
      time = "请选择出生日期";
    } else {
      bool isSolar = isMale ? !_isLunarMale : !_isLunarFemale;
      YiDateTime date = isMale ? _maleYiDate : _femaleYiDate;
      time = TimeUtil.YMDHM(
        isSolar: isSolar,
        date: isSolar ? date : date.toSolar(),
      );
    }
    return InkWell(
      child: Container(
        constraints: BoxConstraints(minHeight: S.h(45)),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: S.w(5)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Row(
          children: <Widget>[
            Text(
              "出生日期",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
            Expanded(
              child: TextField(
                style: TextStyle(fontSize: S.h(15), color: Colors.grey),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: S.w(10)),
                  hintText: time,
                  enabled: false,
                  hintStyle: TextStyle(fontSize: S.h(15), color: Colors.grey),
                ),
              ),
            ),
            Icon(FontAwesomeIcons.calendarAlt, color: Color(0xFFC85356)),
          ],
        ),
      ),
      onTap: () => TimePicker(
        context,
        pickMode: PickerMode.full,
        showLunar: true,
        isLunar: (val) {
          isMale ? _isLunarMale = val : _isLunarFemale = val;
          setState(() {});
        },
        onConfirm: (yiDate) {
          isMale ? _maleYiDate = yiDate : _femaleYiDate = yiDate;
          setState(() {});
        },
      ),
    );
  }

  @override
  void dispose() {
    _maleNameCtrl.dispose();
    _femaleNameCtrl.dispose();
    _commentCtrl.dispose();
    _titleCtrl.dispose();
    _briefCtrl.dispose();
    super.dispose();
  }
}

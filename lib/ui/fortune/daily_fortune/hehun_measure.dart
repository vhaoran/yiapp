import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_snackbar.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/orders/yiOrder-heHun.dart';
import 'package:yiapp/ui/master/master_order/master_recommend.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/23 10:55
// usage ：合婚测算
// ------------------------------------------------------

class HeHunMeasure extends StatefulWidget {
  HeHunMeasure({Key key}) : super(key: key);

  @override
  _HeHunMeasureState createState() => _HeHunMeasureState();
}

class _HeHunMeasureState extends State<HeHunMeasure> {
  String _err; // 错误提示信息
  String _maleTimeStr = ""; // 显示男生出生日期
  String _femaleTimeStr = ""; // 显示女生出生日期
  bool _isLunarMale = false; // 男生是否选择了阴历
  bool _isLunarFemale = false; // 女生是否选择了阴历
  YiDateTime _maleYiDate; // 男生出生日期
  YiDateTime _femaleYiDate; // 女生出生日期
  var _maleNameCtrl = TextEditingController(); // 男生姓名
  var _femaleNameCtrl = TextEditingController(); // 女生姓名
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 15),
            child: CusText("找一个爱你懂你的人", t_primary, 32),
          ),
          _inputChild(_maleNameCtrl, "男方姓名"),
          _dateChild(_maleYiDate, male),
          SizedBox(height: Adapt.px(30)),
          _inputChild(_femaleNameCtrl, "女方姓名"),
          _dateChild(_femaleYiDate, female),
          SizedBox(height: Adapt.px(50)),
          CusBtn(
            text: "立即测算",
            onPressed: _pushPage,
            backgroundColor: btn_red,
          ),
        ],
      ),
    );
  }

  /// 跳转路由
  void _pushPage() {
    setState(() {
      _err = null;
      _err = _maleNameCtrl.text.isEmpty ? "未填写男方姓名" : null;
      if (_err == null) {
        _err = _maleYiDate == null ? "未选择男方出生日期" : null;
      }
      if (_err == null) {
        _err = _femaleNameCtrl.text.isEmpty ? "未填写女方姓名" : null;
      }
      if (_err == null) {
        _err = _femaleYiDate == null ? "未选择女方出生日期" : null;
      }
    });
    if (_err != null) {
      CusSnackBar(
        context,
        scaffoldKey: _scaffoldKey,
        text: _err,
        backgroundColor: fif_primary,
      );
      return;
    }
    Log.info("测算通过");
    YiOrderHeHun heHun = YiOrderHeHun(
      name_male: _maleNameCtrl.text.trim(),
      is_solar_male: !_isLunarMale,
      year_male: _maleYiDate.year,
      month_male: _maleYiDate.month,
      day_male: _maleYiDate.day,
      hour_male: _maleYiDate.oldTime.hour,
      minute_male: _maleYiDate.oldTime.minute,
      name_female: _femaleNameCtrl.text.trim(),
      is_solar_female: !_isLunarFemale,
      year_female: _femaleYiDate.year,
      month_female: _femaleYiDate.month,
      day_female: _femaleYiDate.day,
      hour_female: _femaleYiDate.oldTime.hour,
      minute_female: _femaleYiDate.oldTime.minute,
    );
    CusRoute.push(
      context,
      MasterRecommend(
        type: post_hehun,
        timeHunMale: _maleTimeStr,
        timeHunFemale: _femaleTimeStr,
        heHun: heHun,
      ),
    );
  }

  /// 男/女 姓名输入框
  Widget _inputChild(TextEditingController ctrl, String text) {
    return Container(
      height: Adapt.px(90),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Row(
        children: <Widget>[
          CusText(text, t_gray, 30),
          Expanded(
            child: TextField(
              controller: ctrl,
              style: TextStyle(fontSize: Adapt.px(30), color: t_gray),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: "请输入名字(必须汉字)",
                hintStyle:
                    TextStyle(fontSize: Adapt.px(30), color: Colors.grey),
              ),
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp(r"[\u4e00-\u9fa5]")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 男/女 选择出生日期组件
  Widget _dateChild(YiDateTime yi, int sex) {
    bool isMale = sex == male;
    String timeStr = yi == null
        ? "请选择你的出生日期"
        : TimeUtil.YMDHM(isSolar: isMale ? !_isLunarMale : !_isLunarFemale);
    isMale ? _maleTimeStr = timeStr : _femaleTimeStr = timeStr;
    return InkWell(
      child: Container(
        height: Adapt.px(90),
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Row(
          children: <Widget>[
            CusText("出生日期", t_gray, 30),
            SizedBox(width: Adapt.px(30)),
            Text(
              timeStr,
              style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
            ),
            Spacer(),
            Icon(FontAwesomeIcons.calendarAlt, color: Color(0xFFC85356)),
          ],
        ),
      ),
      onTap: () => TimePicker(
        context,
        pickMode: PickerMode.yi,
        showLunar: true,
        isLunar: (val) {
          isMale ? _isLunarMale = val : _isLunarFemale = val;
          Log.info("男生阴历：$_isLunarMale、女生阴历：$_isLunarFemale");
          setState(() {});
        },
        onConfirm: (yiDate) {
          isMale ? _maleYiDate = yiDate : _femaleYiDate = yiDate;
          setState(() {});
        },
      ),
    );
  }
}

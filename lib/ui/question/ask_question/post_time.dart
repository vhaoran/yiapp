import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/class/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 09:27
// usage ：我要提问 - 出生日期
// ------------------------------------------------------

class PostTimeCtr extends StatefulWidget {
  FnYiDate yiDate;
  FnBool isLunar;

  PostTimeCtr({this.yiDate, this.isLunar, Key key}) : super(key: key);

  @override
  _PostTimeCtrState createState() => _PostTimeCtrState();
}

class _PostTimeCtrState extends State<PostTimeCtr> {
  YiDateTime _birth; // 出生日期
  bool _isLunar = false; // 是否选择了阴历

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _selectTime, // 选择时间
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(30), vertical: Adapt.px(20)),
        decoration: BoxDecoration(
          color: fif_primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: _row(),
      ),
    );
  }

  /// 选择时间
  void _selectTime() {
    if (_isLunar != false) _isLunar = false;
    TimePicker(
      context,
      pickMode: PickerMode.full,
      showLunar: true,
      isLunar: (val) {
        if (val != null) setState(() => _isLunar = val);
        if (widget.isLunar != null) widget.isLunar(val);
      },
      onConfirm: (yiDate) {
        if (yiDate != null) setState(() => _birth = yiDate);
        if (widget.yiDate != null) widget.yiDate(_birth);
      },
    );
  }

  Widget _row() {
    String str = _birth == null
        ? "选择出生日期"
        : _isLunar
            ? "${YiTool.fullDateNong(_birth)}"
            : "${YiTool.fullDateGong(_birth)}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CusText("出生日期", t_yi, 30),
        CusText(str, t_gray, 30),
        Icon(FontAwesomeIcons.calendarAlt, color: t_yi),
      ],
    );
  }
}

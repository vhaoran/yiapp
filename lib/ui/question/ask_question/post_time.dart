import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/util/temp/yi_tool.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 09:27
// usage ：我要提问 - 出生日期
// ------------------------------------------------------

class PostTimeCtr extends StatefulWidget {
  FnYiDate yiDate;
  FnBool isLunar;
  FnString timeStr;

  PostTimeCtr({
    this.yiDate,
    this.isLunar,
    this.timeStr,
    Key key,
  }) : super(key: key);

  @override
  _PostTimeCtrState createState() => _PostTimeCtrState();
}

class _PostTimeCtrState extends State<PostTimeCtr> {
  YiDateTime _birth; // 出生日期
  bool _isLunar = false; // 是否选择了阴历
  String _timeStr = "选择出生日期";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CusText("出生日期", t_yi, 30),
            CusText(_timeStr, t_gray, 30),
            Icon(FontAwesomeIcons.calendarAlt, color: t_yi),
          ],
        ),
        onTap: _selectTime,
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
        if (yiDate != null) {
          _birth = yiDate;
          if (widget.yiDate != null) {
            widget.yiDate(_birth);
          }
          _timeStr = _birth == null
              ? "选择出生日期"
              : _isLunar
                  ? "${YiTool.fullDateNong(_birth)}"
                  : "${YiTool.fullDateGong(_birth)}";
          if (widget.timeStr != null) {
            widget.timeStr(_timeStr);
          }
          setState(() {});
        }
      },
    );
  }
}

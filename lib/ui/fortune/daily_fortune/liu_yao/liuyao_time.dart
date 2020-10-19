import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/model/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/flutter/cus_divider.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/4 09:42
// usage ：起卦时间
// usage : 阳历显示为 公历 2020年09月04日 09:44
// ------------------------------------------------------

class LiuYaoTime extends StatefulWidget {
  FnYiDate pickerTime; // 选择器选择的时间
  YiDateTime outTime; // 没有点击选择器选择时间，传递进来点击铜钱时的时间

  LiuYaoTime({this.pickerTime, this.outTime, Key key}) : super(key: key);

  @override
  _LiuYaoTimeState createState() => _LiuYaoTimeState();
}

class _LiuYaoTimeState extends State<LiuYaoTime> {
  YiDateTime _guaTime; // 起卦时间，没选默认现在(outTime)
  String _guaStr = "可选起卦时间";

  bool _isLunar = false; // 是否选择了阴历

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CusDivider(),
        _row(),
        CusDivider(),
      ],
    );
  }

  Widget _row() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "起卦时间",
          style: TextStyle(
            color: t_gray,
            fontSize: Adapt.px(32),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: InkWell(
            child: Row(
              children: <Widget>[
                Spacer(),
                Text(
                  // TODO 六爻用阴历会报错，这个是否支持阴历(9月12日)
                  widget.outTime == null
                      ? _guaTime == null
                          ? _guaStr
                          : _isLunar
                              ? "${YiTool.fullDateNong(_guaTime)}"
                              : "${YiTool.fullDateGong(_guaTime)}"
                      : _isLunar
                          ? "${YiTool.fullDateNong(widget.outTime)}"
                          : "${YiTool.fullDateGong(widget.outTime)}",
                  style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
                ),
                Spacer(),
                Icon(FontAwesomeIcons.calendarAlt, color: t_yi),
              ],
            ),
            onTap: () {
              if (_isLunar != false) _isLunar = false;
              TimePicker(
                context,
                pickMode: PickerMode.full,
                showLunar: true,
                isLunar: (val) => setState(() => _isLunar = val),
                onConfirm: (yiDate) {
                  _guaTime = yiDate;
                  if (widget.pickerTime != null) {
                    widget.pickerTime(_guaTime);
                  }
                  setState(() {});
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

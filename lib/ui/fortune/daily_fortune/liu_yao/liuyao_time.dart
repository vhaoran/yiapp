import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
// usage : 阳历显示为 公元 2020年09月04日 09:44
// ------------------------------------------------------

class LiuYaoTime extends StatefulWidget {
  FnString pickerTime; // 点击时间选择器自选的时间

  LiuYaoTime({this.pickerTime, Key key}) : super(key: key);

  @override
  _LiuYaoTimeState createState() => _LiuYaoTimeState();
}

class _LiuYaoTimeState extends State<LiuYaoTime> {
  String _guaTime = "可选起卦时间"; // 起卦时间，没选默认现在

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CusDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "起卦时间",
              style: TextStyle(
                color: t_primary,
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
                      _guaTime.contains("公元")
                          ? _guaTime
                          : "公元 ${YiTool.fullDate(DateTime.now())}",
                      style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
                    ),
                    Spacer(),
                    Icon(FontAwesomeIcons.calendarAlt, color: t_yi),
                  ],
                ),
                onTap: () {
                  TimePicker(
                    context,
                    pickMode: PickerMode.full,
                    onConfirm: (date) {
                      _guaTime = "公元 ${YiTool.fullDate(date)}";
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
        ),
        CusDivider(),
      ],
    );
  }
}

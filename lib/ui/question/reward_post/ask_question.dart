import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/class/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/21 17:19
// usage ：我要提问
// ------------------------------------------------------

class AskQuestionPage extends StatefulWidget {
  AskQuestionPage({Key key}) : super(key: key);

  @override
  _AskQuestionPageState createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  var _nameCtrl = TextEditingController(); // 姓名
  String _nameErr; // 姓名提示信息
  bool _isLunar = false; // 是否选择了阴历
  YiDateTime _selectTime;

  @override



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "我要提问"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: Adapt.px(30)),
          child: CusText("请输入您的基本信息", t_primary, 32),
        ),
        Container(
          padding: EdgeInsets.only(left: Adapt.px(30)),
          decoration: BoxDecoration(
              color: fif_primary, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[
              CusText("您的姓名", t_yi, 30),
              Expanded(
                child: CusRectField(
                  controller: _nameCtrl,
                  errorText: _nameErr,
                  hideBorder: true,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Adapt.px(30), vertical: Adapt.px(20)),
          margin: EdgeInsets.only(top: Adapt.px(30)),
          decoration: BoxDecoration(
              color: fif_primary, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[
              CusText("出生日期", t_yi, 30),
              SizedBox(width: Adapt.px(30)),
              Expanded(
                child: InkWell(
                  child: Row(
                    children: <Widget>[
                      Text(
                        _selectTime == null
                            ? "选择出生日期"
                            : _isLunar
                                ? "${YiTool.fullDateNong(_selectTime)}"
                                : "${YiTool.fullDateGong(_selectTime)}",
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
                        _selectTime = yiDate;
                        print(">>>这里的lunar${_isLunar}");
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

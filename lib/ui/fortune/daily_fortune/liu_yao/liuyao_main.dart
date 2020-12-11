import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_online.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/3 10:06
// usage ：六爻排盘页面
// ------------------------------------------------------

class LiuYaoPage extends StatefulWidget {
  LiuYaoPage({Key key}) : super(key: key);

  @override
  _LiuYaoPageState createState() => _LiuYaoPageState();
}

class _LiuYaoPageState extends State<LiuYaoPage> {
  YiDateTime _guaTime; // 起卦时间
  List<int> _codes = []; // 在线起卦的六爻编码
  bool _isLunar = false; // 是否选择了阴历

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "六爻排盘"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    final style = TextStyle(color: t_gray, fontSize: S.sp(16), height: 1.3);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: S.w(10)),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(10)),
          child: Text(
            "六爻排盘又名周易摇卦，始于周朝，创于周文王，由《周易》演变，"
            "因万物演化皆有规律，通过摇卦预测吉凶，直观灵验。",
            style: style,
          ),
        ),
        _timeAndShake(), // 起卦时间和摇卦
        SizedBox(height: S.h(20)),
        Text(
          "请让内心平静，摒除杂念，集中注意力默想自己占卜之事，"
          "每次摇卦时在心里默数3秒，会更加灵验哦!",
          style: style,
        ),
      ],
    );
  }

  /// 起卦时间和摇卦
  Widget _timeAndShake() {
    Widget divider = Divider(height: 0, thickness: 0.2, color: t_gray);
    return Column(
      children: <Widget>[
        // 起卦时间
        divider,
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(10)),
          child: _liuYaoTime(),
        ),
        divider,
        // 摇卦
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(10)),
          child: LiuYaoByShake(
            l: _codes,
            guaTime: (YiDateTime time) {
              if (_guaTime != null || time == null) return;
              setState(() => _guaTime = time);
            },
          ),
        ),
        divider,
      ],
    );
  }

  /// 起卦时间
  Widget _liuYaoTime() {
    var style = TextStyle(color: t_gray, fontSize: S.sp(16));
    return InkWell(
      onTap: () {
        if (_isLunar != false) _isLunar = false;
        TimePicker(
          context,
          pickMode: PickerMode.full,
          showLunar: true,
          isLunar: (val) => setState(() => _isLunar = val),
          onConfirm: (yiDate) => setState(() => _guaTime = yiDate),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("起卦时间", style: style),
          Expanded(child: Center(child: Text(_time, style: style))),
          Icon(FontAwesomeIcons.calendarAlt, color: t_yi),
        ],
      ),
    );
  }

  String get _time {
    if (_guaTime == null) return "选择起卦时间";
    return TimeUtil.YMDHM(isSolar: !_isLunar, comment: true, date: _guaTime);
  }
}

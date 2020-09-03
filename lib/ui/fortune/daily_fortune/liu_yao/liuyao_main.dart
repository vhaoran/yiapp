import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_divider.dart';
import 'package:yiapp/complex/widgets/small/cus_liuyao.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_way.dart';

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
  // 起卦方式
  final List<String> _ways = ["在线起卦", "时间起卦", "待定起卦"];
  String _guaTime = "可选起卦时间"; // 起卦时间，没选默认现在
  int _select = 0; // 选中的哪一个起卦方式
  List<int> _l = []; // 六爻编码
  bool _shaking = false; // 是否正在摇卦

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "六爻排盘"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: Adapt.px(20)),
          child: Text(
            "        六爻排盘又名周易摇卦，始于周朝，创于周文王，由《周易》演变，"
            "因万物演化皆有规律，通过摇卦预测吉凶，直观灵验。",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
        ),
        // 起卦时间
        _selectGuaTime(),
        // 起卦方式
        LiuYaoWay(select: (way) => setState(() => _select = way)),
        // 摇卦
        _shakeGua(),
        Column(
          children: List.generate(
            _l.length,
            (i) => CusLiuYao(
              code: _l[i],
              num: i + 1,
            ),
          ).reversed.toList(),
        ),
        if (_l.length == 6)
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(30)),
            child: CusRaisedBtn(
              text: "开始起卦",
              onPressed: () {
                print(">>>六爻code码：$_l");
              },
            ),
          ),
      ],
    );
  }

  /// 选择起卦时间
  Widget _selectGuaTime() {
    return Column(
      children: <Widget>[
        CusDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _tip("起卦时间"),
            Expanded(
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      _guaTime,
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
                    onConfirm: (date) => setState(
                        () => _guaTime = "公元 ${YiTool.fullDate(date)}"),
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

  /// 摇卦
  Widget _shakeGua() {
    return Padding(
      padding: EdgeInsets.only(top: Adapt.px(40), bottom: Adapt.px(10)),
      child: Column(
        children: <Widget>[
          _l.length == 6
              ? SizedBox.shrink()
              : Text(
                  _shaking ? "点击铜钱出卦" : "点击铜钱进行摇卦",
                  style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
                ),
          CusRaisedBtn(
            text: _shaking ? "铜钱正在动，点击停止..." : "这是铜钱",
            pdHor: 80,
            backgroundColor: _shaking ? Colors.blue : t_yi,
            onPressed: _l.length == 6
                ? null
                : () {
                    _guaTime = "公元 ${YiTool.fullDate(DateTime.now())}";
                    _shaking = !_shaking;
                    if (!_shaking && _l.length != 6) {
                      int code = _ranLiuYao;
                      print(">>>摇的爻编码：$code");
                      _l.add(code);
                    }
                    if (_l.length == 6) {
                      print(">>>爻的编码：$_l");
                    }
                    setState(() {});
                  },
          ),
          _l.length == 6
              ? SizedBox.shrink()
              : Text(
                  "剩余 ${6 - _l.length} 次",
                  style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
                ),
        ],
      ),
    );
  }

  /// 提示文字组件，如选择起卦时间，方式
  Widget _tip(String tip) {
    return Text(
      tip,
      style: TextStyle(
        color: t_primary,
        fontSize: Adapt.px(32),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// 返回六爻数据
  int get _ranLiuYao => DateTime.now().microsecond % 4;
}

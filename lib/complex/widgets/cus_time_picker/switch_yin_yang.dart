import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/11 09:50
// usage ：切换阴阳历组件
// ------------------------------------------------------

class SwitchYinYang extends StatefulWidget {
  final FnBool selectLunar; // 点击阴历的事件

  SwitchYinYang({this.selectLunar, Key key}) : super(key: key);

  @override
  _SwitchYinYangState createState() => _SwitchYinYangState();
}

class _SwitchYinYangState extends State<SwitchYinYang> {
  List<String> _l = ["公历", "农历"];
  int _select = 0; // 当前选中的

  @override
  Widget build(BuildContext context) => Row(children: _yinYang());

  /// 阴阳历按钮
  List<Widget> _yinYang() {
    return List.generate(
      _l.length,
      (i) {
        bool select = _select == i; // 当前选中的
        bool isLunar = _l[i] == "农历" ? true : false;
        return InkWell(
          child: Container(
            decoration: _decoration(select, isLunar), // 边角
            child: CusText(
              _l[i], // 公历/农历
              select ? Colors.white70 : Color(0xFFB52E2D),
              28,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: Adapt.px(30), vertical: Adapt.px(8)),
          ),
          onTap: () {
            if (_select != i) {
              _select = i;
              if (widget.selectLunar != null) {
                widget.selectLunar(isLunar);
              }
              setState(() {});
            }
          },
        );
      },
    );
  }

  /// 控制阴阳历边框
  _decoration(bool select, bool isLunar) {
    return BoxDecoration(
      color: select ? Color(0xFFB52E2D) : Colors.white54, // 背景色
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isLunar ? 0 : 5),
        bottomLeft: Radius.circular(isLunar ? 0 : 5),
        topRight: Radius.circular(isLunar ? 5 : 0),
        bottomRight: Radius.circular(isLunar ? 5 : 0),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/temp/yi_tool.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/4 15:55
// usage ：生成六爻符号
// ------------------------------------------------------

class LiuYaoSymbol extends StatelessWidget {
  final int code; // 当前爻码 0 1 2 3
  final int num; // 第几爻

  LiuYaoSymbol({this.code: 0, this.num: 0, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: S.h(10)), // 爻间距
      child: _row(),
    );
  }

  Widget _row() {
    final style = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // 第几爻，什么爻
        Text(
          "${YiTool.numToChinese(num)}爻  ${_liu(code)['type']}",
          style: TextStyle(color: t_yi, fontSize: S.sp(15)),
        ),
        // 爻的符号
        SizedBox(width: S.w(5)),
        _yaoSym(),
        SizedBox(width: S.w(5)),
        // 老阴、老阳显示符号，其它的不显示
        SizedBox(
          width: S.w(15),
          child: Text(SwitchUtil.xoSymbol(code), style: style),
        ),
        // 几背几字
        Text("${_liu(code)['detail']}", style: style),
      ],
    );
  }

  /// 根据code，返回爻的内容
  Map<String, String> _liu(code) {
    var m = Map<String, String>();
    if (code == shao_yin) m = {"type": "少阴", "detail": "(2背1字)"};
    if (code == shao_yang) m = {"type": "少阳", "detail": "(1背2字)"};
    if (code == lao_yin) m = {"type": "老阴", "detail": "(0背3字)"};
    if (code == lao_yang) m = {"type": "老阳", "detail": "(3背0字)"};
    return m;
  }

  /// 爻的符号 奇数阳爻 ——  偶数阴爻 - -
  Widget _yaoSym() {
    final double width = 60;
    final double space = 10;
    if (code.isOdd) {
      return Container(
          height: S.h(20), width: S.w(2 * width + space), color: Colors.black);
    } else if (code.isEven) {
      return Row(
        children: <Widget>[
          Container(height: S.h(20), width: S.w(width), color: Colors.black),
          SizedBox(width: S.w(space)),
          Container(height: S.h(20), width: S.w(width), color: Colors.black),
        ],
      );
    }
    return SizedBox.shrink();
  }
}

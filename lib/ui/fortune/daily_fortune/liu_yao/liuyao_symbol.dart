import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/function/swicht_case.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/4 15:55
// usage ：生成六爻符号
// ------------------------------------------------------

const double _width = 130; // 阴爻中单个符号的宽度

class LiuYaoSymbol extends StatelessWidget {
  final int code; // 当前爻码 0 1 2 3
  final int num; // 第几爻

  LiuYaoSymbol({this.code: 0, this.num: 0, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Adapt.px(18)), // 爻间距
      child: _row(),
    );
  }

  Widget _row() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // 第几爻
        Text(
          "${YiTool.numToChinese(num)}爻:",
          style: TextStyle(color: t_yi, fontSize: Adapt.px(30)),
        ),
        // 什么爻
        Text(
          " ${_liuYao(code).first}",
          style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
        ),
        // 爻的符号
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(10)),
          child: code.isOdd // 是否奇数，奇数为阳，偶数为阴
              ? _yaoSym(width: 2 * _width + 20)
              : Row(
                  children: <Widget>[
                    _yaoSym(),
                    SizedBox(width: Adapt.px(20)),
                    _yaoSym(),
                  ],
                ),
        ),
        // 老阴、老阳显示符号，其它的不显示
        Container(
          width: Adapt.px(25),
          height: Adapt.px(30),
          margin: EdgeInsets.only(right: Adapt.px(10)),
          child: Text(
            YiSwitch.xoSymbol(code),
            style: TextStyle(
              color: t_gray,
              fontSize: Adapt.px(30),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // 几背几字
        Text(
          "${_liuYao(code).last}",
          style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
        ),
      ],
    );
  }

  /// 根据code，返回爻的内容
  List<String> _liuYao(int code) {
    String yao = "";
    String detail = "";
    switch (code) {
      case shao_yin: // 0
        yao = "少阴";
        detail = "(2背1字)";
        break;
      case shao_yang: // 1
        yao = "少阳";
        detail = "(1背2字)";
        break;
      case lao_yin: // 2
        yao = "老阴";
        detail = "(0背3字)";
        break;
      case lao_yang: // 3
        yao = "老阳";
        detail = "(3背0字)";
        break;
      default:
        break;
    }
    return [yao, detail];
  }

  /// 爻的符号 阳爻 ——  阴爻 - -
  Widget _yaoSym({double width = _width}) {
    return Container(
      height: Adapt.px(45),
      width: Adapt.px(width),
      color: Colors.black,
    );
  }
}

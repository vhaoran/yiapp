import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/4 15:55
// usage ：生成六爻符号
// ------------------------------------------------------

const int shao_yin = 0; // 少阴 2背1字 3/8 概率
const int shao_yang = 1; // 少阳 1背2字 3/8 概率
const int lao_yin = 2; // 老阴 3字 1/8 概率
const int lao_yang = 3; // 老阳 3面 1/8 概率
const double _width = 130; // 阴爻中单个符号的宽度

class LiuYaoSymbol extends StatelessWidget {
  final int code; // 当前爻码 0 1 2 3
  final int num; // 第几爻

  LiuYaoSymbol({
    this.code: 0,
    this.num: 0,
    Key key,
  }) : super(key: key);

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
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
          child: code.isOdd // 偶数为阴
              ? _yao(width: 2 * _width + 40)
              : Row(
                  children: <Widget>[
                    _yao(),
                    SizedBox(width: Adapt.px(40)),
                    _yao(),
                  ],
                ),
        ),
        // 老阴、老阳显示符号，其它的不显示
        Container(
          width: Adapt.px(25),
          height: Adapt.px(30),
          margin: EdgeInsets.only(right: Adapt.px(10)),
          child: Text(
            _symbol(code),
            style: TextStyle(
              color: t_gray,
              fontSize: Adapt.px(30),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // 什么爻
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

  /// 符号，老阴、老阳显示 X 和 O，少阴少阳不显示
  String _symbol(int code) {
    String str;
    switch (code) {
      case lao_yin: // 老阴
        str = "X";
        break;
      case lao_yang: // 老阳
        str = "O";
        break;
      default:
        str = "";
        break;
    }
    return str;
  }

  /// 爻的符号
  Widget _yao({double width = _width}) {
    return Container(
      height: Adapt.px(45),
      width: Adapt.px(width),
      color: Colors.black,
    );
  }
}

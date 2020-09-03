import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';

const int shao_yin = 0; // 少阴 2背1字 3/8 概率
const int shao_yang = 1; // 少阳 1背2字 3/8 概率
const int lao_yin = 2; // 老阴 3字 1/8 概率
const int lao_yang = 3; // 老阳 3面 1/8 概率

class CusLiuYao extends StatelessWidget {
  final int code; // 当前爻码 0 1 2 3
  final int num; // 第几爻

  const CusLiuYao({
    this.code: 0,
    this.num: 0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Adapt.px(18)), // 爻间距
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // 第几爻
          Text(
            "${YiTool.numToChinese(num)}爻:",
            style: TextStyle(color: t_yi, fontSize: Adapt.px(30)),
          ),
          Text(
            " ${_liuYao(code).first}",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(25)),
            child: code.isOdd // 偶数为阴
                ? _yao(width: 320) // 140+140+40
                : Row(
                    children: <Widget>[
                      _yao(),
                      SizedBox(width: Adapt.px(40)),
                      _yao(),
                    ],
                  ),
          ),
          // 什么爻
          Text(
            "${_liuYao(code).last}",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
        ],
      ),
    );
  }

  /// 爻的符号
  Widget _yao({double width = 140}) {
    return Container(
      height: Adapt.px(45),
      width: Adapt.px(width),
      color: Colors.black,
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
}

import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/function/swicht_case.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_divider.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/5 15:51
// usage ：六爻卦象
// ------------------------------------------------------

const double _width = 50; // 阴爻中单个符号的宽度

class LiuYaoSymRes extends StatelessWidget {
  final LiuYaoResult res;
  final List<int> codes; // 六爻编码

  LiuYaoSymRes({this.res, this.codes, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: t_gray,
        fontSize: Adapt.px(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                res.name,
                style: TextStyle(
                    fontSize: Adapt.px(30), fontWeight: FontWeight.bold),
              ),
              Text(
                res.name_bian,
                style: TextStyle(
                    fontSize: Adapt.px(30), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: Adapt.px(20)),
          // 因为本卦变卦中字数可能是4或5，所以设计成了两个Column，这样伏神可以保持对齐
          ...List.generate(
            6,
            (i) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _benGua(res.liushen[i], res.l[i], codes[i], res.fushen[i]),
                _bianGua(res.l_bian[i], codes[i]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 本卦
  Widget _benGua(String liushen, String benGua, int code, String fushen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            // 六神
            Text(liushen),
            SizedBox(width: Adapt.px(15)),
            // 本卦内容
            SizedBox(width: Adapt.px(150), child: Text(benGua)),
            // 本卦爻符号
            Padding(
              padding: EdgeInsets.only(right: Adapt.px(15)),
              child: code.isOdd // // 是否奇数，奇数为阳，偶数为阴
                  ? _yaoSym(width: 2 * _width + 10)
                  : Row(
                      children: <Widget>[
                        _yaoSym(),
                        SizedBox(width: Adapt.px(10)),
                        _yaoSym(),
                      ],
                    ),
            ),
            // 老阳显示 O,老阴显示 X
            SizedBox(
              width: Adapt.px(20),
              child: Text(
                YiSwitch.xoSymbol(code),
                 style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Text(
          fushen.isEmpty ? "" : "↑伏神 $fushen",
          style: TextStyle(color: t_red, fontSize: Adapt.px(26)),
        ),
      ],
    );
  }

  /// 变卦
  Widget _bianGua(String bian_gua, int code) {
    if (code == 2) {
      code = 3; // 至阴为阳
    } else if (code == 3) {
      code = 2; // 至阳为阴
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: Adapt.px(40)),
            // 变卦内容
            SizedBox(width: Adapt.px(150), child: Text(bian_gua)),
            // 变卦爻符号（老阴变老阳、老阳变老阴）
            code.isOdd // // 是否奇数，奇数为阳，偶数为阴
                ? _yaoSym(width: 2 * _width + 10)
                : Row(
                    children: <Widget>[
                      _yaoSym(),
                      SizedBox(width: Adapt.px(10)),
                      _yaoSym(),
                    ],
                  ),
          ],
        ),
      ],
    );
  }

  /// 爻的符号 阳爻 ——  阴爻 - -
  Widget _yaoSym({double width = _width}) {
    return Container(
      height: Adapt.px(30),
      width: Adapt.px(width),
      color: Colors.black,
    );
  }
}

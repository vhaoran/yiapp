import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/small/cus_liuyao.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/4 09:51
// usage ：在线起卦
// ------------------------------------------------------

class LiuYaoByOnLine extends StatefulWidget {
  List<int> l = []; // 六爻编码
  FnString guaTime; // 起卦时间
  VoidCallback onChanged;

  LiuYaoByOnLine({
    this.l,
    this.guaTime,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  _LiuYaoByOnLineState createState() => _LiuYaoByOnLineState();
}

class _LiuYaoByOnLineState extends State<LiuYaoByOnLine> {
  bool _shaking = false; // 是否正在摇卦
  String _guaTime = ""; // 起卦时间

  @override
  Widget build(BuildContext context) {
    if (widget.onChanged != null) {
      widget.onChanged();
      widget.l.clear();
      setState(() {});
    }
    return Padding(
      padding: EdgeInsets.only(top: Adapt.px(40), bottom: Adapt.px(10)),
      child: Column(
        children: <Widget>[
          ..._shake(), // 点击铜钱摇卦
          ..._showLiuYao(), // 显示六爻
        ],
      ),
    );
  }

  /// 点击铜钱摇卦
  List<Widget> _shake() {
    return <Widget>[
      widget.l.length == 6
          ? SizedBox.shrink()
          : Text(
              _shaking ? "点击铜钱出卦" : "点击铜钱进行摇卦",
              style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
            ),
      CusRaisedBtn(
        text: _shaking ? "铜钱正在动，点击停止..." : "这是铜钱",
        pdHor: 80,
        backgroundColor: _shaking ? Colors.blue : t_yi,
        onPressed: widget.l.length == 6 ? null : _doShake,
      ),
      // 剩余次数
      if (widget.l.length != 6)
        Text(
          "剩余 ${6 - widget.l.length} 次",
          style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
        ),
    ];
  }

  /// 显示六爻
  List<Widget> _showLiuYao() {
    return <Widget>[
      // 逐个显示爻
      Column(
        children: List.generate(
          widget.l.length,
          (i) => CusLiuYao(
            code: widget.l[i],
            num: i + 1,
          ),
        ).reversed.toList(),
      ),
      // 六爻都摇完后，显示起卦按钮
      if (widget.l.length == 6)
        Padding(
          padding: EdgeInsets.only(top: Adapt.px(30)),
          child: CusRaisedBtn(
            text: "开始起卦",
            pdHor: 50,
            onPressed: () {
              print(">>>六爻code码：${widget.l}");
            },
          ),
        ),
    ];
  }

  /// 点击铜钱摇卦
  void _doShake() {
    if (_guaTime.isEmpty) {
      _guaTime = "公元 ${YiTool.fullDate(DateTime.now())}";
    }
    if (widget.guaTime != null) {
      widget.guaTime(_guaTime);
    }
    _shaking = !_shaking;
    if (!_shaking && widget.l.length != 6) {
      int code = _ranLiuYao;
      print(">>>摇的爻编码：$code");
      widget.l.add(code);
    }
    if (widget.l.length == 6) {
      print(">>>爻的编码：${widget.l}");
    }
    setState(() {});
  }

  /// 返回六爻数据
  int get _ranLiuYao => DateTime.now().microsecond % 4;
}

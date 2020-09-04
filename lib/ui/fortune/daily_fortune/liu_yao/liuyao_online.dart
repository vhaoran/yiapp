import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/small/liuyao_symbol.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/4 09:51
// usage ：在线起卦
// ------------------------------------------------------

const String _zi = "assets/images/zi_mian.png"; // 铜钱字面(正面)
const String _bei = "assets/images/bei_mian.png"; // 铜钱背面(反面)

class LiuYaoByOnLine extends StatefulWidget {
  List<int> l = []; // 六爻编码
  FnString guaTime; // 起卦时间

  LiuYaoByOnLine({this.l, this.guaTime, Key key}) : super(key: key);

  @override
  _LiuYaoByOnLineState createState() => _LiuYaoByOnLineState();
}

class _LiuYaoByOnLineState extends State<LiuYaoByOnLine> {
  bool _shaking = false; // 是否正在摇卦
  String _guaTime = ""; // 起卦时间
  String _assets = _bei;
  List<String> _ziBei = []; // 铜钱字背面
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ..._shake(), // 点击铜钱摇卦
        ..._showLiuYao(), // 显示六爻
      ],
    );
  }

  /// 点击铜钱摇卦
  List<Widget> _shake() {
    return <Widget>[
      if (widget.l.length != 6)
        Text(
          _shaking ? "点击铜钱出卦" : "点击铜钱进行摇卦",
          style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
        ),
      // 铜钱
      InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (i) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Adapt.px(25), vertical: Adapt.px(20)),
              child: Image.asset(
                _ziBei.isEmpty ? _assets : _ziBei[i],
                scale: 4,
              ),
            ),
          ),
        ),
        onTap: widget.l.length == 6 ? null : _doShake,
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
          (i) => LiuYaoSymbol(code: widget.l[i], num: i + 1),
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
    _ziBei.clear(); // 清空上一次的数据
    if (_guaTime.isEmpty) {
      _guaTime = "公元 ${YiTool.fullDate(DateTime.now())}";
    }
    if (widget.guaTime != null) {
      widget.guaTime(_guaTime);
    }
    _shaking = !_shaking;
    print(">>>当前_shaking:$_shaking");
    if (!_shaking && widget.l.length != 6) {
      int code = _ranLiuYao;
      print(">>>摇的爻编码：$code");
      widget.l.add(code);
      _detailData(code); // 根据少阳少阴老阳老阴，显示具体的铜钱面
    }
    if (widget.l.length == 6) {
      print(">>>爻的编码：${widget.l}");
    }
    _shakeAni(); // 模拟点击铜钱的动画，交替显示铜钱正反面
    setState(() {});
  }

  /// 模拟点击铜钱的动画，交替显示铜钱正反面
  void _shakeAni() async {
    bool b = false;
    while (_shaking) {
      b = !b;
      _assets = b ? _zi : _bei;
      await Future.delayed(Duration(milliseconds: 200));
      if (mounted) setState(() {});
    }
  }

  /// 根据少阳少阴老阳老阴，显示具体的铜钱面
  void _detailData(int code) {
    switch (code) {
      case shao_yin:
        switch (Random().nextInt(3)) {
          case 0:
            _ziBei.addAll([_bei, _bei, _zi]);
            break;
          case 1:
            _ziBei.addAll([_bei, _zi, _bei]);
            break;
          case 2:
            _ziBei.addAll([_zi, _bei, _bei]);
            break;
        }
        break;
      case shao_yang:
        switch (Random().nextInt(3)) {
          case 0:
            _ziBei.addAll([_bei, _zi, _zi]);
            break;
          case 1:
            _ziBei.addAll([_zi, _zi, _bei]);
            break;
          case 2:
            _ziBei.addAll([_zi, _bei, _zi]);
            break;
        }
        break;
      case lao_yin:
        _ziBei.addAll([_zi, _zi, _zi]);
        break;
      case lao_yang:
        _ziBei.addAll([_bei, _bei, _bei]);
        break;
      default:
        break;
    }
    setState(() {});
  }

  /// 返回六爻数据
  int get _ranLiuYao => DateTime.now().microsecond % 4;

  @override
  void dispose() {
    _shaking = false; // 正在摇铜钱但是直接返回上一页面，需要设置该项，否则i会继续增加
    super.dispose();
  }
}

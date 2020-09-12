import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol.dart';
import 'package:yiapp/service/api/api_yi.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_result.dart';
import 'package:provider/provider.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/4 09:51
// usage ：在线起卦
// ------------------------------------------------------

const String _zi = "assets/images/zi_mian.png"; // 铜钱字面(正面)
const String _bei = "assets/images/bei_mian.png"; // 铜钱背面(反面)

class LiuYaoByOnLine extends StatefulWidget {
  List<int> l = []; // 六爻编码
  FnYiDate guaTime; // 当前点击铜钱的时间，传递给外部的起卦时间
  YiDateTime pickerTime; // 如果通过选择器更改了时间，则同步该时间

  LiuYaoByOnLine({
    this.l,
    this.guaTime,
    this.pickerTime,
    Key key,
  }) : super(key: key);

  @override
  _LiuYaoByOnLineState createState() => _LiuYaoByOnLineState();
}

class _LiuYaoByOnLineState extends State<LiuYaoByOnLine> {
  bool _shaking = false; // 是否正在摇卦
  bool _hadShaken = false; // 是否已经摇完6爻
  YiDateTime _guaTime;
  String _assets = _bei;
  List<String> _ziBei = []; // 铜钱字背面
  int _sex; // 用户性别

  @override
  Widget build(BuildContext context) {
    _hadShaken = widget.l.length == 6 ? true : false;
    _sex = context.watch<UserInfoState>()?.userInfo?.sex ?? -1;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(15)),
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
      if (!_hadShaken)
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
        onTap: _hadShaken ? null : _doShake,
      ),
      // 剩余次数
      if (!_hadShaken)
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
      if (_hadShaken)
        Padding(
          padding: EdgeInsets.only(top: Adapt.px(30)),
          child: CusRaisedBtn(
            text: "开始起卦",
            minWidth: double.infinity,
            onPressed: _doQiGua,
          ),
        ),
    ];
  }

  /// 开始起卦
  void _doQiGua() async {
    String code = "";
    widget.l.forEach((e) => code += e.toString());
    print(">>>guatime.tojson:${_guaTime.toJson()}");
    var m = {
      "year": _guaTime.year,
      "month": _guaTime.month,
      "day": _guaTime.day,
      "hour": _guaTime.hour,
      "minute": _guaTime.minute,
      "code": code,
      "male": _sex,
    };
    try {
      var res = await ApiYi.liuYaoQiGua(m);
      print(">>>六爻起卦的数据是：${res.toJson()}");
      if (res != null) {
        CusRoutes.pushReplacement(
          context,
          LiuYaoResPage(res: res, l: widget.l, guaTime: _guaTime),
        );
      }
    } catch (e) {
      print("<<<六爻起卦出现异常：$e");
    }
  }

  /// 点击铜钱摇卦
  void _doShake() {
    _ziBei.clear(); // 清空上一次的数据
    if (_guaTime == null) {
      _guaTime = YiTool.toYiDate(DateTime.now());
      // 先通过选择器选择时间，再点铜钱，不能去改变选择器的时间，所以加了pickerTime == null
      if (widget.guaTime != null && widget.pickerTime == null) {
        widget.guaTime(_guaTime);
      }
    }
    if (widget.pickerTime != null) {
      _guaTime = widget.pickerTime;
    }
    _shaking = !_shaking;
    if (!_shaking && !_hadShaken) {
      int code = _ranLiuYao;
      widget.l.add(code);
      _showZiBei(code); // 根据少阳少阴老阳老阴，显示具体的铜钱面
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
  void _showZiBei(int code) {
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

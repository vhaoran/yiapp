import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/submit_liuyao_data.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_measure_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/temp/yi_tool.dart';
import 'package:yiapp/util/us_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol.dart';
import 'package:yiapp/service/api/api_pai_pan.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/4 09:51
// usage ：在线起卦
// ------------------------------------------------------

const String _zi = "assets/images/zi_mian.png"; // 铜钱字面(正面)，阴面
const String _bei = "assets/images/bei_mian.png"; // 铜钱背面(反面)，阳面

class LiuYaoOnLine extends StatefulWidget {
  final List<int> l; // 六爻编码
  final FnYiDate guaTime; // 当前点击铜钱的时间
  final int male;
  final String qigua_time;

  LiuYaoOnLine({
    this.l,
    this.guaTime,
    this.male,
    this.qigua_time,
    Key key,
  }) : super(key: key);

  @override
  _LiuYaoOnLineState createState() => _LiuYaoOnLineState();
}

class _LiuYaoOnLineState extends State<LiuYaoOnLine> {
  bool _shaking = false; // 是否正在摇卦
  bool _hadShaken = false; // 是否已经摇完6爻
  YiDateTime _guaTime;
  String _assets = _bei;
  List<String> _ziBeiList = []; // 铜钱字背面

  @override
  Widget build(BuildContext context) {
    _hadShaken = widget.l.length == 6 ? true : false;
    return Column(
      children: <Widget>[
        _shake(), // 点击铜钱摇卦
        _showLiuYao(), // 显示六爻
      ],
    );
  }

  /// 点击铜钱摇卦
  Widget _shake() {
    var style = TextStyle(color: t_gray, fontSize: S.sp(16));
    return Column(
      children: <Widget>[
        if (!_hadShaken) // 没有摇完六爻时
          Text(_shaking ? "点击铜钱出卦" : "点击铜钱进行摇卦", style: style),
        SizedBox(height: S.h(10)),
        // 铜钱
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Padding(
                padding: EdgeInsets.symmetric(horizontal: S.w(i == 1 ? 10 : 0)),
                child: Image.asset(
                  _ziBeiList.isEmpty ? _assets : _ziBeiList[i],
                  scale: 4,
                ),
              ),
            ),
          ),
          onTap: _hadShaken ? null : _doShake,
        ),
        SizedBox(height: S.h(10)),
        // 剩余次数
        if (!_hadShaken) Text("剩余 ${6 - widget.l.length} 次", style: style),
      ],
    );
  }

  /// 显示六爻
  Widget _showLiuYao() {
    return Column(
      children: <Widget>[
        // 逐个显示爻
        ...List.generate(
          widget.l.length,
          (i) => LiuYaoSymbol(code: widget.l[i], num: i + 1),
        ).reversed,
        // 六爻都摇完后，显示起卦按钮
        SizedBox(height: S.h(15)),
        if (_hadShaken)
          SizedBox(
            width: S.screenW() / 1.5,
            child: CusRaisedButton(
              child: Text("开始起卦", style: TextStyle(fontSize: S.sp(15))),
              onPressed: _doQiGua,
            ),
          ),
      ],
    );
  }

  /// 六爻起卦
  void _doQiGua() async {
    SpinKit.threeBounce(context);
    // 六爻起卦的数据
    String yaoCode = UsUtil.yaoCode(widget.l);
    var m = {
      "year": _guaTime.year,
      "month": _guaTime.month,
      "day": _guaTime.day,
      "hour": _guaTime.hour,
      "minute": _guaTime.minute,
      "yao_code": yaoCode,
      "male": widget.male,
    };
    Log.info("准备六爻起卦的数据:$m");
    try {
      var liuyaoRes = await ApiPaiPan.liuYaoQiGua(m);
      if (liuyaoRes != null) {
        Navigator.pop(context);
        var liuYaoContent = LiuYaoContent(
          yao_code: yaoCode,
          is_male: widget.male == male,
          year: _guaTime.year,
          month: _guaTime.month,
          day: _guaTime.day,
          hour: _guaTime.hour,
          minute: _guaTime.minute,
          liuyao_res: liuyaoRes,
          qigua_time: widget.qigua_time,
        );
        var liuYaoData = SubmitLiuYaoData(
          amt: 0,
          level_id: 0,
          title: "",
          brief: "",
          content_type: submit_liuyao, // 六爻类型
          content: liuYaoContent,
        );
        CusRoute.pushReplacement(
          context,
          LiuYaoMeasurePage(liuYaoData: liuYaoData),
        ).then((val) {
          if (val != null) Navigator.pop(context);
        });
      }
    } catch (e) {
      Log.error("六爻起卦出现异常：$e");
    }
  }

  /// 点击铜钱摇卦
  void _doShake() async {
    // 清空上一次的数据
    _ziBeiList.clear();
    // 记录当前点击铜钱的时间
    _guaTime = YiTool.toYiDate(DateTime.now());
    widget.guaTime(_guaTime);
    _shaking = !_shaking;
    // 如果没有正在摇卦，且没有摇够六次，返回六爻数据
    if (!_shaking && !_hadShaken) {
      int code = DateTime.now().microsecond % 4;
      widget.l.add(code);
      _showZiBei(code); // 具体铜钱面
    }
    // 铜钱动画
    bool b = false;
    while (_shaking) {
      b = !b;
      _assets = b ? _zi : _bei;
      await Future.delayed(Duration(milliseconds: 200));
      if (mounted) setState(() {});
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _shaking = false; // 正在摇铜钱但是直接返回上一页面，需要设置该项，否则i会继续增加
    super.dispose();
  }

  /// 根据少阳少阴老阳老阴，显示具体的铜钱面
  void _showZiBei(int code) {
    int r = Random().nextInt(3);
    if (code == shao_yin) {
      if (r == 0) _ziBeiList.addAll([_bei, _bei, _zi]);
      if (r == 1) _ziBeiList.addAll([_bei, _zi, _bei]);
      if (r == 2) _ziBeiList.addAll([_zi, _bei, _bei]);
    }
    if (code == shao_yang) {
      if (r == 0) _ziBeiList.addAll([_bei, _zi, _zi]);
      if (r == 1) _ziBeiList.addAll([_zi, _zi, _bei]);
      if (r == 2) _ziBeiList.addAll([_zi, _bei, _zi]);
    }
    if (code == lao_yin) _ziBeiList.addAll([_zi, _zi, _zi]);
    if (code == lao_yang) _ziBeiList.addAll([_bei, _bei, _bei]);
    if (mounted) setState(() {});
  }
}

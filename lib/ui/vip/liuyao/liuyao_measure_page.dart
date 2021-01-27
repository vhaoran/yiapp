import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/bbs/submit_liuyao_data.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol_res.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_bottom_buttons.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_divider.dart';
import 'package:yiapp/widget/post_com/liuyao_com_header.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 下午6:02
// usage ：六爻测算界面
// ------------------------------------------------------

class LiuYaoMeasurePage extends StatefulWidget {
  final LiuYaoResult liuYaoRes;
  final SubmitLiuYaoData liuYaoData;

  LiuYaoMeasurePage({this.liuYaoRes, this.liuYaoData, Key key})
      : super(key: key);

  @override
  _LiuYaoMeasurePageState createState() => _LiuYaoMeasurePageState();
}

class _LiuYaoMeasurePageState extends State<LiuYaoMeasurePage> {
  _LiuYaoMeasurePageState();
  List<int> _codes = [];

  @override
  void initState() {
    List<String> codes = widget.liuYaoData.content.yao_code.split('');
    codes.forEach((e) => _codes.add(int.parse(e)));
    // 显示的时候是倒序
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "六爻排盘", backData: ""),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: S.w(15)),
            children: <Widget>[
              SizedBox(height: S.h(5)),
              // 六爻头部信息，含占类、时间、干支
              LiuYaoComHeader(
                liuYaoRes: widget.liuYaoRes,
                liuYaoContent: widget.liuYaoData.content,
              ),
              CusDivider(),
              // 卦象
              LiuYaoSymRes(
                res: widget.liuYaoRes,
                codes: _codes.reversed.toList(),
              ),
              CusDivider(),
            ],
          ),
        ),
        // 底部求测按钮
        _bottomButtonsWt(),
      ],
    );
  }

  Widget _bottomButtonsWt() {
    if (widget.liuYaoData != null) {
      return LiuYaoBottomButtons(
        liuYaoData: widget.liuYaoData,
        liuYaoRes: widget.liuYaoRes,
        codes: _codes.reversed.toList(),
      );
    }
    return SizedBox.shrink();
  }
}

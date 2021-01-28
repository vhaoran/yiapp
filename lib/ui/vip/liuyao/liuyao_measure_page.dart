import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/submit_liuyao_data.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_prize_page.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_vie_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_content_ui.dart';
import 'package:yiapp/widget/master/broker_master_list_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 下午6:02
// usage ：六爻测算界面
// ------------------------------------------------------

class LiuYaoMeasurePage extends StatefulWidget {
  final SubmitLiuYaoData liuYaoData;

  LiuYaoMeasurePage({this.liuYaoData, Key key}) : super(key: key);

  @override
  _LiuYaoMeasurePageState createState() => _LiuYaoMeasurePageState();
}

class _LiuYaoMeasurePageState extends State<LiuYaoMeasurePage> {
  _LiuYaoMeasurePageState();

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
              LiuYaoContentUI(liuYaoContent: widget.liuYaoData.content),
            ],
          ),
        ),
        // 底部求测按钮
        _bottomButtonsWt(),
      ],
    );
  }

  /// 底部求测按钮
  Widget _bottomButtonsWt() {
    return Row(
      children: <Widget>[
        Expanded(child: _prizeButtonWt()), // 悬赏帖求测
        Expanded(child: _vieButtonWt()), // 闪断帖求测
        Expanded(child: _yiOrderButtonWt()), // 大师亲测
      ],
    );
  }

  /// 悬赏帖求测
  Widget _prizeButtonWt() {
    return CusRaisedButton(
      child: Text("悬赏帖求测", style: TextStyle(fontSize: S.sp(15))),
      backgroundColor: Color(0xFFE96C62),
      onPressed: () async {
        CusRoute.push(
          context,
          LiuYaoPrizePage(liuYaoData: widget.liuYaoData),
        ).then((value) {
          if (value != null) Navigator.of(context).pop("");
        });
      },
    );
  }

  /// 闪断帖求测
  Widget _vieButtonWt() {
    return CusRaisedButton(
        child: Text("闪断帖求测", style: TextStyle(fontSize: S.sp(15))),
        backgroundColor: Color(0xFFED9951),
        onPressed: () async {
          CusRoute.push(
            context,
            LiuYaoViePage(liuYaoData: widget.liuYaoData),
          ).then((value) {
            if (value != null) Navigator.of(context).pop("");
          });
        });
  }

  /// 大师亲测
  Widget _yiOrderButtonWt() {
    return CusRaisedButton(
      child: Text("大师亲测", style: TextStyle(fontSize: S.sp(15))),
      backgroundColor: Color(0xFFE8493E),
      onPressed: () async {
        CusRoute.push(
          context,
          BrokerMasterListPage(
            showLeading: true,
            yiOrderData: widget.liuYaoData,
          ),
        );
      },
    );
  }
}

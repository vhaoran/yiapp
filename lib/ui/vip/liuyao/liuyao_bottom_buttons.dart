import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/submit_liuyao_data.dart';
import 'package:yiapp/model/complex/cus_liuyao_data.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_prize_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/master/broker_master_list_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 下午6:51
// usage ：六爻底部的按钮事件，含悬赏帖求测、闪断帖求测、大师亲测
// ------------------------------------------------------

class LiuYaoBottomButtons extends StatefulWidget {
  final SubmitLiuYaoData liuYaoData;
  final LiuYaoResult liuYaoRes;
  final List<int> codes; // 六爻编码

  LiuYaoBottomButtons({this.liuYaoData, this.liuYaoRes, this.codes, Key key})
      : super(key: key);

  @override
  _LiuYaoBottomButtonsState createState() => _LiuYaoBottomButtonsState();
}

class _LiuYaoBottomButtonsState extends State<LiuYaoBottomButtons> {
  @override
  Widget build(BuildContext context) {
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
        if (await _approved) {
          CusRoute.push(
            context,
            LiuYaoPrizePage(liuYaoData: widget.liuYaoData),
          ).then((value) {
            if (value != null) Navigator.pop(context);
          });
        }
      },
    );
  }

  /// 闪断帖求测
  Widget _vieButtonWt() {
    return CusRaisedButton(
      child: Text("闪断帖求测", style: TextStyle(fontSize: S.sp(15))),
      backgroundColor: Color(0xFFED9951),
      onPressed: () {
        //          CusRoute.push(context, SiZhuViePage(siZhuData: widget.liuYaoData))
//              .then((value) {
//            if (value != null) Navigator.pop(context);
//          });
      },
    );
  }

  /// 大师亲测
  Widget _yiOrderButtonWt() {
    return CusRaisedButton(
      child: Text("大师亲测", style: TextStyle(fontSize: S.sp(15))),
      backgroundColor: Color(0xFFE8493E),
      onPressed: () {
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

  /// 存储六爻数据
  Future<bool> get _approved async {
    // 存储前有数据先清理
    if (await KV.getStr(kv_liuyao) != null) {
      await KV.remove(kv_liuyao);
    }
    CusLiuYaoData yaoData = CusLiuYaoData(
      res: widget.liuYaoRes,
      codes: widget.codes,
    );
    String str = json.encode(yaoData.toJson());
    bool isOk = await KV.setStr(kv_liuyao, str);
    Log.info("存储六爻排盘的结果 $isOk");
    return isOk;
  }
}

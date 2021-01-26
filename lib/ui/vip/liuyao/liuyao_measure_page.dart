import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/submit_liuyao_data.dart';
import 'package:yiapp/model/complex/cus_liuyao_data.dart';
import 'package:yiapp/model/complex/master_order_data.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_bottom_buttons.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_divider.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/model/liuyaos/liuyao_riqi.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol_res.dart';
import 'package:yiapp/ui/question/ask_question/ask_main_page.dart';
import 'package:yiapp/widget/master/broker_master_list_page.dart';
import 'package:yiapp/widget/post_com/liuyao_com_header.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 下午6:02
// usage ：六爻测算界面
// ------------------------------------------------------

class LiuYaoMeasurePage extends StatefulWidget {
  final LiuYaoResult liuYaoRes;
  final List<int> l; // 六爻编码
  final YiDateTime guaTime;

  LiuYaoMeasurePage({this.liuYaoRes, this.l, this.guaTime, Key key})
      : super(key: key);

  @override
  _LiuYaoMeasurePageState createState() => _LiuYaoMeasurePageState();
}

class _LiuYaoMeasurePageState extends State<LiuYaoMeasurePage> {
  _LiuYaoMeasurePageState();
  DateTime _qiGuaTime; // 起卦时间

  @override
  void initState() {
    // 显示的时候是倒序
    LiuYaoRiqi riqi = widget.liuYaoRes.riqi;
    _qiGuaTime =
        DateTime(riqi.year, riqi.month, riqi.day, riqi.hour, riqi.minute);
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
              LiuYaoComHeader(liuYaoRes: widget.liuYaoRes),
              CusDivider(),
              // 卦象
              LiuYaoSymRes(
                res: widget.liuYaoRes,
                codes: widget.l.reversed.toList(),
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
    String code = "";
    widget.l.forEach((e) => code += e.toString());
    var content = LiuYaoContent(yao_code: code);
    content.ymdhm(widget.liuYaoRes.riqi.dateTime());
    var liuYaoData = SubmitLiuYaoData(
      amt: 0,
      level_id: 0,
      title: "",
      brief: "",
      content_type: submit_liuyao,
      content: content,
    );
    if (liuYaoData != null) {
      return LiuYaoBottomButtons(
        liuYaoData: liuYaoData,
        liuYaoRes: widget.liuYaoRes,
        codes: widget.l.reversed.toList(),
      );
    }
    return SizedBox.shrink();
  }

  /// 跳往选择大师页面
  void _doSelectMaster() async {
    CusLiuYaoData yaoData = CusLiuYaoData(
      res: widget.liuYaoRes,
      codes: widget.l.reversed.toList(),
    );
    String str = json.encode(yaoData.toJson());
    bool ok = await KV.setStr(kv_liuyao, str);
    if (ok) Log.info("已存储 kv_liuyao");
    String code = "";
    widget.l.forEach((e) => code += e.toString());
    // 这里设置的男性需要修改
    var liuYao = LiuYaoContent(yao_code: code, is_male: true);
    liuYao.ymdhm(_qiGuaTime);
    var data = MasterOrderData(comment: "", liuYao: liuYao);
    Log.info("当前提交六爻的信息：${data.toJson()}");
    // 清除上次数据
    if (await KV.getStr(kv_order) != null) await KV.remove(kv_order);
    // 存储大师订单数据
    bool success = await KV.setStr(kv_order, json.encode(data.toJson()));
    if (success)
      CusRoute.push(context, BrokerMasterListPage(showLeading: true));
  }

  /// 求测悬赏帖还是闪断帖
  void _doPost(bool isFlash) async {
    CusRole.isVie = isFlash;
    CusRoute.push(
      context,
      AskQuestionPage(
        content_type: submit_liuyao,
        res: widget.liuYaoRes,
        l: widget.l,
        guaTime: widget.guaTime,
        user_nick: "这只是默认名称，待修改",
      ),
    ).then((value) => Navigator.of(context).pop(""));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/bo/broker_master_cate.dart';
import 'package:yiapp/model/complex/master_order_data.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_divider.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/home/home_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/28 下午5:45
// usage ：约聊大师（默认四柱测算）
// ------------------------------------------------------

class MeetMasterPage extends StatefulWidget {
  final BrokerMasterCate cate;

  MeetMasterPage({this.cate, Key key}) : super(key: key);

  @override
  _MeetMasterPageState createState() => _MeetMasterPageState();
}

class _MeetMasterPageState extends State<MeetMasterPage> {
  var _future;
  String _err; // 错误提示信息
  MasterOrderData _data;

  @override
  void initState() {
    Log.info("测算的项目：${widget.cate.toJson()}");
    _future = _loadData();
    super.initState();
  }

  /// 加载本地大师订单数据
  _loadData() async {
    String str = await KV.getStr(kv_order);
    if (str != null) {
      var data = MasterOrderData.fromJson(json.decode(str));
      if (data != null) _data = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "约聊大师"),
      body: FutureBuilder(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            return _lv();
          }),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.all(Adapt.px(30)),
        children: <Widget>[
          Row(
            children: <Widget>[
              CusText("服务类型", t_primary, 30),
              SizedBox(width: Adapt.px(40)),
              CusText("四柱测算", t_gray, 30),
            ],
          ),
          CusDivider(),
          CusText("基本信息", t_primary, 30),
          _baseInfo(),
          CusDivider(),
          CusText("问题描述", t_primary, 30),
          SizedBox(height: Adapt.px(20)),
          SizedBox(height: Adapt.px(20)),
          CusBtn(
            text: "下单",
            backgroundColor: Colors.blueGrey,
            onPressed: _doOrder,
          ),
        ],
      ),
    );
  }

  Widget _baseInfo() {
    return Column(
      children: <Widget>[
        SizedBox(height: Adapt.px(20)),
        Row(
          children: <Widget>[
            CusText("姓名：", t_primary, 30),
            CusText(_data.siZhu.name, t_gray, 30),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Adapt.px(10)),
          child: Row(
            children: <Widget>[
              CusText("性别：", t_primary, 30),
              CusText(_data.siZhu.is_male ? "男" : "女", t_gray, 30),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            CusText("出生日期：", t_primary, 30),
            CusText("显示日期", t_gray, 30),
          ],
        ),
      ],
    );
  }

  void _doOrder() async {
    if (_err != null) return;
    var m = {
//      "master_id": widget.master_id,
      "yi_cate_id": ApiBase.uid,
    };
    Log.info("数据：${m.toString()}");
    try {
      SpinKit.threeBounce(context);
      YiOrder res = await ApiYiOrder.yiOrderAdd(m);
      if (res != null) {
        Navigator.pop(context);
        Log.info("四柱下单后返回的订单id：${res.id}");
        CusToast.toast(context, text: "下单成功");
        CusRoute.pushReplacement(context, HomePage());
      }
    } catch (e) {
      Log.error("四柱下大师单出现异常：$e");
    }
  }
}

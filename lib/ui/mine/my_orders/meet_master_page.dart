import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bo/broker_master_cate.dart';
import 'package:yiapp/model/complex/master_order_data.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/master/master_console/master_yiorder_page.dart';
import 'package:yiapp/ui/mine/my_orders/hehun_order.dart';
import 'package:yiapp/ui/mine/my_orders/master_order.dart';
import 'package:yiapp/ui/mine/my_orders/sizhu_order.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/us_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/28 下午5:45
// usage ：约聊大师，大师下单（默认四柱测算）
// ------------------------------------------------------

class MeetMasterPage extends StatefulWidget {
  final BrokerMasterCate cate;

  MeetMasterPage({this.cate, Key key}) : super(key: key);

  @override
  _MeetMasterPageState createState() => _MeetMasterPageState();
}

class _MeetMasterPageState extends State<MeetMasterPage> {
  var _future;
  MasterOrderData _data;

  @override
  void initState() {
    _future = _loadData();
    super.initState();
  }

  /// 加载本地大师订单数据
  _loadData() async {
    try {
      String str = await KV.getStr(kv_order);
      if (str != null) {
        var data = MasterOrderData.fromJson(json.decode(str));
        if (data != null) {
          _data = data;
          Log.info("本地大师订单数据：${_data.toJson()}");
        }
      }
    } catch (e) {
      Log.error("加载本地大师订单数据出现异常：$e");
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
        padding: EdgeInsets.all(S.w(15)),
        children: <Widget>[
          // 约聊大师的信息
          _masterInfo(),
          Divider(height: 15, thickness: 0.2, color: t_gray),
          // 根据服务类型，动态显示结果
          _dynamicTypeView(),
          Divider(height: 15, thickness: 0.2, color: t_gray),
          if (_data.liuYao == null) ...[
            Text("问题描述",
                style: TextStyle(color: t_primary, fontSize: S.sp(15))),
            SizedBox(height: S.h(5)),
            Text(
              "${_data.comment}", // 问题描述
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ],
          SizedBox(height: S.h(40)),
          CusRaisedButton(child: Text("下单"), onPressed: _doOrder),
        ],
      ),
    );
  }

  /// 约聊大师的信息
  Widget _masterInfo() {
    return Row(
      children: <Widget>[
        CusAvatar(url: widget.cate.master_icon), // 大师头像
        SizedBox(width: S.w(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _comRow("大师姓名：", widget.cate.master_nick),
              _comRow("测算项目：", widget.cate.yi_cate_name),
              _comRow("服务价格：", "${widget.cate.price}"),
            ],
          ),
        ),
      ],
    );
  }

  /// 通用的 Row
  Widget _comRow(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(2)),
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(color: t_primary, fontSize: S.sp(15))),
          Text(subtitle, style: TextStyle(color: t_gray, fontSize: S.sp(15))),
        ],
      ),
    );
  }

  void _doOrder() async {
    var m = {
      "master_id": widget.cate.master_id,
      "yi_cate_id": widget.cate.yi_cate_id,
      "comment": _data.comment,
    };
    if (_data.siZhu != null) m.addAll({"si_zhu": _data.siZhu.toJson()});
    if (_data.heHun != null) m.addAll({"he_hun": _data.heHun.toJson()});
    if (_data.liuYao != null) m.addAll({"liu_yao": _data.liuYao.toJson()});
    Log.info("提交约聊大师数据：${m.toString()}");
    SpinKit.threeBounce(context);
    try {
      YiOrder res = await ApiYiOrder.yiOrderAdd(m);
      if (res != null) {
        Navigator.pop(context);
        Log.info("约聊大师后返回的订单id：${res.id}");
        Log.info("大师订单详情：${res.toJson()}");
        await UsUtil.checkLocalY(); // 清除本地下单数据
        if (_data.liuYao != null) await KV.remove(kv_liuyao);
        CusToast.toast(context, text: "下单成功", pos: ToastPos.bottom);
        var payData =
            PayData(amt: widget.cate.price, b_type: b_yi_order, id: res.id);
        BalancePay(context, data: payData, onSuccess: () {
          CusRoute.pushReplacement(context, MasterYiOrderPage(id: res.id));
        });
      }
    } catch (e) {
      Log.error("约聊大师下单出现异常：$e");
    }
  }

  /// 根据服务类型，动态显示结果
  Widget _dynamicTypeView() {
    if (_data.siZhu != null) {
      Log.info("这是测算四柱");
      return SiZhuOrder(siZhu: _data.siZhu);
    } else if (_data.heHun != null) {
      Log.info("这是测算合婚");
      return HeHunOrder(heHun: _data.heHun);
    } else if (_data.liuYao != null) {
      Log.info("这是测算六爻");
      return MasterOrder(liuYaoContent: _data.liuYao);
    }
    return Container();
  }
}

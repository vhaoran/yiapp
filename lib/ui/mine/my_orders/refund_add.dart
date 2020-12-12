import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/12 下午4:03
// usage ：添加新的投诉单
// ------------------------------------------------------

class RefundOrderAdd extends StatefulWidget {
  final BBSVie data; // 这里先用闪断帖代替所有类型，测试完所有后再改为动态的
  final String b_type;

  RefundOrderAdd({this.data, this.b_type, Key key}) : super(key: key);

  @override
  _RefundOrderAddState createState() => _RefundOrderAddState();
}

class _RefundOrderAddState extends State<RefundOrderAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "投诉$_bType"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[],
    );
  }

  String get _bType {
    if (widget.b_type == b_mall) return "商品";
    if (widget.b_type == b_yi_order) return "大师订单";
    if (widget.b_type == b_bbs_prize) return "悬赏帖订单";
    if (widget.b_type == b_bbs_vie) return "闪断帖订单";
    return "未知投诉类型";
  }
}

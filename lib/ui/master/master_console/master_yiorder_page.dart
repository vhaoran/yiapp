import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/orders/yiOrder-sizhu.dart';
import 'package:yiapp/ui/master/master_console/yiorder_input.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/25 下午5:19
// usage ：单个大师订单详情
// ------------------------------------------------------

class MasterYiOrderPage extends StatefulWidget {
  final YiOrder yiOrder;

  MasterYiOrderPage({this.yiOrder, Key key}) : super(key: key);

  @override
  _MasterYiOrderPageState createState() => _MasterYiOrderPageState();
}

class _MasterYiOrderPageState extends State<MasterYiOrderPage> {
  YiOrderSiZhu _siZhu;

  @override
  void initState() {
    _siZhu = widget.yiOrder.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "大师订单"),
      body: Column(
        children: [
          Expanded(child: _lv()),
          YiOrderInput(),
        ],
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(10)),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: S.h(10)),
            child: _baseInfo(),
          ),
          CusText("问题描述", t_primary, 30),
          CusText(widget.yiOrder.comment, t_gray, 30),
          SizedBox(height: S.h(10)),
          CusText("所求名称", t_primary, 30),
          CusText(
            "${SwitchUtil.serviceType(widget.yiOrder.yi_cate_id)}",
            t_gray,
            30,
          ),
        ],
      ),
    );
  }

  /// 用户基本信息
  Widget _baseInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CusAvatar(url: widget.yiOrder.icon_ref, rate: 10, size: 70),
        SizedBox(width: S.w(10)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CusText(_siZhu.name, t_primary, 30),
                SizedBox(width: S.w(10)),
                CusText(_siZhu.is_male ? "男" : "女", t_primary, 30),
              ],
            ),
            SizedBox(height: S.h(10)),
            Row(
              children: <Widget>[
                CusText("出生日期：", t_gray, 30),
                CusText(
                    "${TimeUtil.YMDHM(isSolar: _siZhu.is_solar, date: _siZhu.dateTime())}",
                    t_gray,
                    30),
              ],
            )
          ],
        ),
      ],
    );
  }
}

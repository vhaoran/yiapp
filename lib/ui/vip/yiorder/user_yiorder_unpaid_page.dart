import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/yiorder_com_detail.dart';
import 'package:yiapp/widget/post_com/yiorder_com_header.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 上午11:44
// usage ：会员待付款的单个大师订单详情
// ------------------------------------------------------

class UserYiOrderUnpaidPage extends StatefulWidget {
  final String yiOrderId;

  UserYiOrderUnpaidPage({this.yiOrderId, Key key}) : super(key: key);

  @override
  _UserYiOrderUnpaidPageState createState() => _UserYiOrderUnpaidPageState();
}

class _UserYiOrderUnpaidPageState extends State<UserYiOrderUnpaidPage> {
  YiOrder _yiOrder;
  var _future;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 会员获取大师订单详情
  _fetch() async {
    try {
      YiOrder order = await ApiYiOrder.yiOrderGet(widget.yiOrderId);
      if (order != null) {
        Log.info("会员当前待付款大师订单详情：${order.toJson()}");
        _yiOrder = order;
        setState(() {});
      }
    } catch (e) {
      Log.error("会员获取待付款大师订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "大师订单"),
      body: _buildFbWt(),
      backgroundColor: primary,
    );
  }

  Widget _buildFbWt() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return ScrollConfiguration(
          behavior: CusBehavior(),
          child: EasyRefresh(
            header: CusHeader(),
            footer: CusFooter(),
            onRefresh: () async => _fetch(),
            child: _lv(),
          ),
        );
      },
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: S.w(10)),
      children: <Widget>[
        if (_yiOrder == null) EmptyContainer(text: "订单找不到了~"),
        if (_yiOrder != null) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 大师订单头部信息
              YiOrderComHeader(yiOrder: _yiOrder),
              // 大师订单详情
              YiOrderComDetail(yiOrderContent: _yiOrder.content),
              Padding(
                padding: EdgeInsets.symmetric(vertical: S.h(3)),
                child: Text(
                  "问题描述:  ${_yiOrder.comment}",
                  style: TextStyle(color: t_gray, fontSize: S.sp(16)),
                ),
              ),
            ],
          )
        ],
      ],
    );
  }
}

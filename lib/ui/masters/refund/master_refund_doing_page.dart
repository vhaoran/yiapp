import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/orders/refund_res.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/refund_com_content.dart';
import 'package:yiapp/widget/post_com/refund_com_header.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午7:20
// usage ：大师查看处理中的投诉订单详情
// ------------------------------------------------------

class MasterRefundDoingPage extends StatefulWidget {
  final String refundId; // 投诉大师订单id

  MasterRefundDoingPage({this.refundId, Key key}) : super(key: key);

  @override
  _MasterRefundDoingPageState createState() => _MasterRefundDoingPageState();
}

class _MasterRefundDoingPageState extends State<MasterRefundDoingPage> {
  var _future;
  RefundRes _refundRes; // 单条投诉单详情

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      var refundRes = await ApiYiOrder.refundOrderGet(widget.refundId);
      if (refundRes != null) {
        _refundRes = refundRes;
        Log.info("大师查看当前处理中的投诉大师订单详情 ${_refundRes.toJson()}");
      }
    } catch (e) {
      Log.error("大师查看当前处理中的投诉大师订单详情出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "投诉详情"),
      body: _buildFb(),
      backgroundColor: primary,
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_refundRes == null) {
          return Center(
            child: Text("~订单不存在",
                style: TextStyle(color: t_gray, fontSize: S.sp(15))),
          );
        }
        return _lv();
      },
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(10)),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: S.h(5)),
            child: Text(
              "投诉人",
              style: TextStyle(color: t_primary, fontSize: S.sp(15)),
            ),
          ),
          // 投诉订单头部
          RefundComHeader(
            refundRes: _refundRes,
            iconUrl: _refundRes.icon,
            nick: _refundRes.nick,
          ),
          // 投诉的内容
          RefundComContent(refundRes: _refundRes),
        ],
      ),
    );
  }
}

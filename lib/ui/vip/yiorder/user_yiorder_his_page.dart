import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_msg.dart';
import 'package:yiapp/ui/vip/refund/refund_add_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/yiorder_com_detail.dart';
import 'package:yiapp/widget/post_com/yiorder_com_header.dart';
import 'package:yiapp/widget/post_com/yiorder_com_reply_area.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午1:37
// usage ：会员已完成的单个大师订单详情
// ------------------------------------------------------

class UserYiOrderHisPage extends StatefulWidget {
  final String yiOrderId;

  UserYiOrderHisPage({this.yiOrderId, Key key}) : super(key: key);

  @override
  _UserYiOrderHisPageState createState() => _UserYiOrderHisPageState();
}

class _UserYiOrderHisPageState extends State<UserYiOrderHisPage> {
  YiOrder _yiOrder;
  var _future;

  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<MsgYiOrder> _l = []; // 大师订单聊天记录

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取大师订单
  _fetch() async {
    await _fetchOrder();
    await _fetchReply();
  }

  /// 会员获取大师订单详情
  _fetchOrder() async {
    try {
      YiOrder order = await ApiYiOrder.yiOrderHisGet(widget.yiOrderId);
      if (order != null) {
        Log.info("会员当前已完成大师订单详情：${order.toJson()}");
        _yiOrder = order;
        setState(() {});
      }
    } catch (e) {
      Log.error("会员获取已完成大师订单出现异常：$e");
    }
  }

  /// 会员分页获取聊天内容
  _fetchReply() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "id_of_yi_order": widget.yiOrderId,
    };
    try {
      PageBean pb = await ApiMsg.yiOrderMsgHisPage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("已完成的大师订单聊天总个数 $_rowsCount");
        var l = pb.data.map((e) => e as MsgYiOrder).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        setState(() {});
        Log.info("当前已加载已完成的大师订单聊天个数 ${_l.length}");
      }
    } catch (e) {
      Log.error("会员分页获取已完成大师订单聊天记录出现异常 $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWt(),
      body: FutureBuilder(
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
              onRefresh: () async => _refresh(),
              onLoad: () async => _fetchReply(),
              child: _lv(),
            ),
          );
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        if (_yiOrder == null) EmptyContainer(text: "订单找不到了~"),
        if (_yiOrder != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: S.w(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 大师订单头部信息
                YiOrderComHeader(yiOrder: _yiOrder),
                // 大师订单详情
                YiOrderComDetail(yiOrderContent: _yiOrder.content),
                SizedBox(height: S.h(6)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "问题描述:",
                      style: TextStyle(color: t_primary, fontSize: S.sp(16)),
                    ),
                    Text(
                      _yiOrder.comment,
                      style: TextStyle(color: t_gray, fontSize: S.sp(16)),
                    ),
                  ],
                ),
                SizedBox(height: S.h(10)),
                // 测算结果
                _diagnoseWt(),
              ],
            ),
          ),
          // 大师订单评论区
          if (_yiOrder != null) YiOrderComReplyArea(l: _l, uid: _yiOrder.uid),
        ],
      ],
    );
  }

  /// 测算结果
  Widget _diagnoseWt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "测算结果:",
          style: TextStyle(color: t_primary, fontSize: S.sp(16)),
        ),
        Text(
          _yiOrder.diagnose.isEmpty ? "暂无测算结果" : _yiOrder.diagnose,
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
        Divider(height: 0, thickness: 0.2, color: t_gray),
      ],
    );
  }

  Widget _appBarWt() {
    return CusAppBar(text: "大师订单", actions: [
      FlatButton(
        onPressed: () =>
            CusRoute.push(context, RefundAddPage(yiOrder: _yiOrder)),
        child: Text(
          "投诉",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
      )
    ]);
  }

  _refresh() async {
    _l.clear();
    _pageNo = _rowsCount = 0;
    setState(() {});
    await _fetch();
  }
}

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
import 'package:yiapp/ui/masters/yiorder/ch_diagnose_page.dart';
import 'package:yiapp/ui/masters/yiorder/master_yiorder_input.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/post_com/yiorder_com_reply_area.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/yiorder_com_detail.dart';
import 'package:yiapp/widget/post_com/yiorder_com_header.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午2:10
// usage ：大师处理中的单个大师订单详情
// ------------------------------------------------------

class MasterYiOrderDoingPage extends StatefulWidget {
  final String yiOrderId;

  MasterYiOrderDoingPage({this.yiOrderId, Key key}) : super(key: key);

  @override
  _MasterYiOrderDoingPageState createState() => _MasterYiOrderDoingPageState();
}

class _MasterYiOrderDoingPageState extends State<MasterYiOrderDoingPage> {
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

  /// 大师获取大师订单详情
  _fetchOrder() async {
    try {
      YiOrder order = await ApiYiOrder.yiOrderGet(widget.yiOrderId);
      if (order != null) {
        Log.info("大师当前处理中大师订单详情：${order.toJson()}");
        _yiOrder = order;
        setState(() {});
      }
    } catch (e) {
      Log.error("大师获取处理中大师订单出现异常：$e");
    }
  }

  /// 大师分页获取聊天内容
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
        Log.info("处理中的大师订单聊天总个数 $_rowsCount");
        var l = pb.data.map((e) => e as MsgYiOrder).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        setState(() {});
        Log.info("当前已加载处理中的大师订单聊天个数 ${_l.length}");
      }
    } catch (e) {
      Log.error("大师分页获取处理中大师订单聊天记录出现异常 $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: _appBarWt(),
          body: _co(),
          backgroundColor: primary,
        );
      },
    );
  }

  Widget _co() {
    return Column(
      children: [
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: EasyRefresh(
              header: CusHeader(),
              footer: CusFooter(),
              onRefresh: () async => _refresh(),
              onLoad: () async => _fetchReply(),
              child: _lv(),
            ),
          ),
        ),
        MasterYiOrderInput(yiOrder: _yiOrder, onSend: _refresh),
      ],
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
    bool empty = _yiOrder.diagnose.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "测算结果:",
              style: TextStyle(color: t_primary, fontSize: S.sp(16)),
            ),
            Spacer(),
            CusRaisedButton(
              padding: EdgeInsets.symmetric(
                horizontal: S.w(13),
                vertical: S.h(0),
              ),
              backgroundColor: empty ? t_yi : t_ji,
              child: Text(
                empty ? "设置测算结果" : "修改测算结果",
                style: TextStyle(fontSize: S.sp(13), color: Colors.black),
              ),
              onPressed: () {
                CusRoute.push(context, ChDiagnosePage(yiOrder: _yiOrder))
                    .then((value) {
                  if (value != null) _fetch();
                });
              },
              borderRadius: 50,
            ),
          ],
        ),
        SizedBox(height: S.h(5)),
        Text(
          empty ? "暂未设置测算结果" : _yiOrder.diagnose, // 显示测试结果
          style: TextStyle(color: t_gray, fontSize: S.sp(16)),
        ),
        SizedBox(height: S.h(5)),
        Divider(height: 0, thickness: 0.2, color: t_gray),
      ],
    );
  }

  Widget _appBarWt() {
    return CusAppBar(
      text: "大师订单",
      actions: [
        if (_yiOrder.diagnose.isNotEmpty)
          FlatButton(
            child:
                Text("结单", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
            onPressed: () async {
              CusDialog.normal(context, title: "是否现在结单", onApproval: () async {
                bool ok = await ApiYiOrder.yiOrderComplete(_yiOrder.id);
                if (ok) {
                  CusToast.toast(context, text: "已结单");
                  Navigator.of(context).pop("");
                }
              });
            },
          ),
      ],
    );
  }

  _refresh() async {
    _l.clear();
    _pageNo = _rowsCount = 0;
    setState(() {});
    await _fetch();
  }
}

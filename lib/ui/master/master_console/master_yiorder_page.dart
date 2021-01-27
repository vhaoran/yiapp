import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_msg.dart';
import 'package:yiapp/ui/master/master_console/yiorder_input.dart';
import 'package:yiapp/ui/mine/my_orders/hehun_order.dart';
import 'package:yiapp/ui/mine/my_orders/master_order.dart';
import 'package:yiapp/ui/mine/my_orders/sizhu_order.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/25 下午5:19
// usage ：单个大师订单详情
// ------------------------------------------------------

class MasterYiOrderPage extends StatefulWidget {
  final bool isHis; // 是否历史查询
  final String id;
  final String backData;

  MasterYiOrderPage({this.id, this.isHis: false, this.backData, Key key})
      : super(key: key);

  @override
  _MasterYiOrderPageState createState() => _MasterYiOrderPageState();
}

class _MasterYiOrderPageState extends State<MasterYiOrderPage> {
  YiOrder _yiOrder;
  var _future;
  bool _needCh = false; // 是否需要修改测算结果
  var _scrollCtrl = ScrollController();

  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<MsgYiOrder> _l = []; // 大师订单聊天记录

  TextStyle _tGray = TextStyle(color: t_gray, fontSize: S.sp(15));
  TextStyle _tPrimary = TextStyle(color: t_primary, fontSize: S.sp(15));

  @override
  void initState() {
    Log.info("是否历史查询：${widget.isHis}");
    _future = _fetch();
    super.initState();
  }

  /// 获取大师订单
  _fetch() async {
    await _fetchOrder();
    await _fetchReply();
  }

  /// 获取大师订单详情
  _fetchOrder() async {
    try {
      Log.info("id:${widget.id}");
      YiOrder order = widget.isHis
          ? await ApiYiOrder.yiOrderHisGet(widget.id)
          : await ApiYiOrder.yiOrderGet(widget.id);
      if (order != null) {
        Log.info("当前大师订单详情：${order.toJson()}");
        _yiOrder = order;
        _needCh = false;
        setState(() {});
      }
    } catch (e) {
      Log.error("获取大师订单出现异常：$e");
    }
  }

  /// 分页获取聊天内容
  _fetchReply() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "id_of_yi_order": widget.id,
    };
    try {
      PageBean pb = await ApiMsg.yiOrderMsgHisPage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("总的大师订单回复聊天个数：$_rowsCount");
        var l = pb.data.map((e) => e as MsgYiOrder).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        setState(() {});
        Log.info("当前已显示回复聊天个数：${_l.length}");
      }
    } catch (e) {
      Log.error("根据大师订单id查询聊天记录出现异常：$e");
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
            appBar: _appBar(),
            body: Column(
              children: [
                Expanded(child: _lv()),
                // 回复大师订单输入框
                if (_yiOrder.stat == bbs_paid)
                  YiOrderInput(
                      yiOrder: _yiOrder,
                      onSend: () async {
                        await _refresh();
                        Timer(
                          Duration(milliseconds: 500),
                          () => _scrollCtrl
                              .jumpTo(_scrollCtrl.position.maxScrollExtent),
                        );
                      },
                      needCh: _needCh),
              ],
            ),
            backgroundColor: primary,
          );
        });
  }

  Widget _lv() {
    if (_yiOrder == null)
      return Center(
        child: Text(
          "订单找不到了~",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
      );
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: EasyRefresh(
        header: CusHeader(),
        footer: CusFooter(),
        onRefresh: () async => _refresh(),
        onLoad: () async => _fetchReply(),
        child: ListView(
          controller: _scrollCtrl,
          padding: EdgeInsets.symmetric(horizontal: S.w(10)),
          children: <Widget>[
            _orderDataView(),
            _diagnoseWid(_yiOrder.diagnose), // 测算结果
            SizedBox(height: S.h(10)),
            Center(child: Text(_l.isEmpty ? "暂无评论" : "评论区", style: _tPrimary)),
            SizedBox(height: S.h(10)),
            Divider(height: 0, thickness: 0.2, color: t_gray),
            SizedBox(height: S.h(5)),
            // 评论区域
            ...List.generate(_l.length, (i) => _replyItem(_l[i], i + 1)),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    _l.clear();
    _pageNo = _rowsCount = 0;
    await _fetch();
  }

  /// 单个评论的内容
  Widget _replyItem(MsgYiOrder e, int level) {
    return Padding(
      padding: EdgeInsets.only(bottom: S.h(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // 评论人头像
              CusAvatar(url: e.from_icon ?? "", circle: true, size: 45),
              SizedBox(width: S.w(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(e.from_nick, style: _tPrimary), // 评论人昵称
                        Spacer(),
                        Text("$level楼", style: _tGray), // 显示层数
                      ],
                    ),
                    SizedBox(height: S.h(5)),
                    Text(
                      e.create_date,
                      style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: S.h(10)),
          Text(e.content, style: _tGray), // 评论的内容
          SizedBox(height: S.h(10)),
          Divider(height: 0, thickness: 0.2, color: t_gray),
        ],
      ),
    );
  }

  /// 订单区域显示
  Widget _orderDataView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(10)),
          child: _dynamicTypeView(), // 用户基本信息
        ),
        if (!(_yiOrder.content is LiuYaoContent)) ...[
          Text("问题描述", style: _tPrimary),
          Text(_yiOrder.comment, style: _tGray), // 问题描述
        ],
        SizedBox(height: S.h(10)),
        Text("所求类型 ", style: _tPrimary), // 所求类型
        Text("${SwitchUtil.serviceType(_yiOrder.yi_cate_id)}", style: _tGray),
        SizedBox(height: S.h(10)),
      ],
    );
  }

  /// 测算结果组件
  Widget _diagnoseWid(String diagnose) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("当前测算结果", style: _tPrimary),
            if (CusRole.is_master &&
                _yiOrder.diagnose.isNotEmpty &&
                _yiOrder.stat != bbs_ok)
              InkWell(
                onTap: () => setState(() => _needCh = true),
                child: Text(
                  " 点击修改",
                  style: TextStyle(color: Colors.lightBlue, fontSize: S.sp(15)),
                ),
              ),
          ],
        ),
        Text(
          _yiOrder.diagnose.isEmpty ? "暂无测算结果" : _yiOrder.diagnose,
          style: _tGray,
        ), // 测算结果
      ],
    );
  }

  /// 根据服务类型，动态显示结果
  Widget _dynamicTypeView() {
    if (_yiOrder.content is SiZhuContent) {
      Log.info("这是测算四柱");
      return SiZhuOrder(siZhu: _yiOrder.content);
    } else if (_yiOrder.content is HeHunContent) {
      Log.info("这是测算合婚");
      return HeHunOrder(heHun: _yiOrder.content);
    } else if (_yiOrder.content is LiuYaoContent) {
      Log.info("这是测算六爻");
      return MasterOrder(liuYaoContent: _yiOrder.content);
    }
    return Container();
  }

  Widget _appBar() {
    return CusAppBar(
      text: "大师订单",
      backData: widget.backData,
      actions: [
        // 如果是大师本人查看订单，订单已支付，且有测算结果时，则显示结单按钮
        if (_yiOrder.master_id == ApiBase.uid &&
            _yiOrder.stat == bbs_paid &&
            _yiOrder.diagnose.isNotEmpty)
          FlatButton(
            child: Text("结单", style: _tGray),
            onPressed: () async {
              CusDialog.normal(context, title: "是否现在结单", onApproval: () async {
                bool ok = await ApiYiOrder.yiOrderComplete(widget.id);
                if (ok) {
                  CusToast.toast(context, text: "已结单");
                  Navigator.of(context).pop("");
                }
              });
            },
          ),
        if (CusRole.is_vip && _yiOrder.stat == bbs_ok)
          FlatButton(
            child: Text("投诉", style: _tGray),
            onPressed: () {},
          ),
      ],
    );
  }
}

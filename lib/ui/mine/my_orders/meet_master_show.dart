import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_msg.dart';
import 'package:yiapp/ui/mine/my_orders/hehun_order.dart';
import 'package:yiapp/ui/mine/my_orders/master_order.dart';
import 'package:yiapp/ui/vip/refund/user_refund_add_page.dart';
import 'package:yiapp/ui/mine/my_orders/sizhu_order.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/29 下午2:56
// usage ：查看约聊大师
// ------------------------------------------------------

class MeetMasterShow extends StatefulWidget {
  final YiOrder yiOrder;

  MeetMasterShow({this.yiOrder, Key key}) : super(key: key);

  @override
  _MeetMasterShowState createState() => _MeetMasterShowState();
}

class _MeetMasterShowState extends State<MeetMasterShow> {
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<MsgYiOrder> _l = []; // 大师订单聊天记录
  var _future;

  @override
  void initState() {
    _future = _fetchReply();
    super.initState();
  }

  /// 分页获取聊天内容
  _fetchReply() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "id_of_yi_order": widget.yiOrder.id,
    };
    try {
      PageBean pb = await ApiMsg.yiOrderMsgHisPage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("历史大师订单中总的大师订单回复聊天个数：$_rowsCount");
        var l = pb.data.map((e) => e as MsgYiOrder).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        setState(() {});
        Log.info("历史大师订单中当前已显示回复聊天个数：${_l.length}");
      }
    } catch (e) {
      Log.error("历史大师订单中根据大师订单id查询聊天记录出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
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
      child: EasyRefresh(
        header: CusHeader(),
        footer: CusFooter(),
        onRefresh: () async => _refresh(),
        onLoad: () async => _fetchReply(),
        child: ListView(
          padding: EdgeInsets.all(S.w(15)),
          children: <Widget>[
            _masterInfo(), // 约聊大师的信息
            Divider(height: 15, thickness: 0.2, color: t_gray),
            Text("基本信息",
                style: TextStyle(color: t_primary, fontSize: S.sp(15))),
            // 根据服务类型，动态显示结果
            _dynamicTypeView(),
            Divider(height: 15, thickness: 0.2, color: t_gray),
            Text("问题描述",
                style: TextStyle(color: t_primary, fontSize: S.sp(15))),
            SizedBox(height: S.h(5)),
            Text(
              widget.yiOrder.comment, // 问题描述
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
            SizedBox(height: S.h(5)),
            Text("测算结果",
                style: TextStyle(color: t_primary, fontSize: S.sp(15))),
            SizedBox(height: S.h(5)),
            Text(
              widget.yiOrder.diagnose,
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
            SizedBox(height: S.h(5)),
            // 评论区域
            Center(
                child: Text("评论区",
                    style: TextStyle(color: t_primary, fontSize: S.sp(15)))),
            ...List.generate(_l.length, (i) => _replyItem(_l[i], i + 1)),
            // 根据订单状态显示不同状态按钮
            SizedBox(height: S.h(40)),
            _showBtn(stat: widget.yiOrder.stat),
          ],
        ),
      ),
    );
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
                        Text(e.from_nick,
                            style: TextStyle(
                                color: t_primary, fontSize: S.sp(15))), // 评论人昵称
                        Spacer(),
                        Text("$level楼",
                            style: TextStyle(
                                color: t_gray, fontSize: S.sp(15))), // 显示层数
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
          Text(e.content,
              style: TextStyle(color: t_gray, fontSize: S.sp(15))), // 评论的内容
          SizedBox(height: S.h(10)),
          Divider(height: 0, thickness: 0.2, color: t_gray),
        ],
      ),
    );
  }

  /// 根据订单状态显示不同状态按钮
  Widget _showBtn({int stat}) {
    if (stat == bbs_unpaid)
      return CusRaisedButton(
        child: Text("支付"),
        onPressed: () {
          PayData payData = PayData(
            amt: widget.yiOrder.amt,
            b_type: b_yi_order,
            id: widget.yiOrder.id,
          );
          BalancePay(
            context,
            data: payData,
            onSuccess: () => Navigator.of(context).pop(""),
          );
        },
      );
    return SizedBox.shrink();
  }

  /// 约聊大师的信息
  Widget _masterInfo() {
    return Row(
      children: <Widget>[
        CusAvatar(url: widget.yiOrder.master_icon_ref), // 大师头像
        SizedBox(width: S.w(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _comRow("大师姓名：", widget.yiOrder.master_nick_ref),
              _comRow(
                "测算项目：",
                "${SwitchUtil.serviceType(widget.yiOrder.yi_cate_id)}",
              ),
              _comRow("服务价格：", "${widget.yiOrder.amt}"),
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

  /// 根据服务类型，动态显示所问订单详情
  Widget _dynamicTypeView() {
    if (widget.yiOrder.content is SiZhuContent) {
      return SiZhuOrder(siZhu: widget.yiOrder.content);
    } else if (widget.yiOrder.content is HeHunContent) {
      return HeHunOrder(heHun: widget.yiOrder.content);
    } else if (widget.yiOrder.content is LiuYaoContent) {
      Log.info("这是测算六爻");
      return MasterOrder(liuYaoContent: widget.yiOrder.content);
    }
    return SizedBox.shrink();
  }

  Future<void> _refresh() async {
    _l.clear();
    _pageNo = _rowsCount = 0;
    await _fetchReply();
  }

  Widget _appBar() {
    return CusAppBar(
      text: "约聊大师",
      actions: [
        if (widget.yiOrder.uid == ApiBase.uid &&
            widget.yiOrder.stat == yiorder_ok)
          FlatButton(
            onPressed: () => CusRoute.push(
              context,
              UserRefundAddPage(yiOrder: widget.yiOrder),
            ),
            child: Text(
              "投诉",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ),
      ],
    );
  }
}

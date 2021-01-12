import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/orders/refund_res.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/mine/my_orders/complaints_detail_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/5 上午11:06
// usage ：投诉大师订单--含处理中和已处理
// ------------------------------------------------------

class ComplaintsOrderPage extends StatefulWidget {
  final bool isHis; // 是否历史查询

  ComplaintsOrderPage({this.isHis: false, Key key}) : super(key: key);

  @override
  _ComplaintsOrderPageState createState() => _ComplaintsOrderPageState();
}

class _ComplaintsOrderPageState extends State<ComplaintsOrderPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<ComplaintsRes> _l = []; // 投诉的大师订单结果

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "sort": {"create_time_int": -1},
    };
    var m1 = {
      "where": {"master_id": ApiBase.uid} // 大师查看
    };
    var m2 = {
      "where": {"uid": ApiBase.uid} // 投诉人查看
    };
    m.addAll(CusRole.is_master ? m1 : m2);
    widget.isHis ? await _fetchHis(m) : await _fetchIng(m);
  }

  /// 分页获取处理中投诉订单
  _fetchIng(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiYiOrder.refundOrderPage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("总的处理中投诉大师订单个数：$_rowsCount");
        var l = pb.data.map((e) => e as ComplaintsRes).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        setState(() {});
        Log.info("已加载处理中投诉大师订单个数：${_l.length}");
      }
    } catch (e) {
      Log.error("查看处理中投诉大师订单出现异常：$e");
    }
  }

  /// 分页获取已处理投诉订单
  _fetchHis(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiYiOrder.refundOrderHisPage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("总的已处理投诉大师订单个数：$_rowsCount");
        var l = pb.data.map((e) => e as ComplaintsRes).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        setState(() {});
        Log.info("已加载已处理投诉大师订单个数：${_l.length}");
      }
    } catch (e) {
      Log.error("查看已处理投诉大师订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (_l.isEmpty) {
            return Center(
              child: Text("暂无数据",
                  style: TextStyle(color: t_gray, fontSize: S.sp(16))),
            );
          }
          return _lv();
        },
      ),
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: EasyRefresh(
        header: CusHeader(),
        footer: CusFooter(),
        onRefresh: () async => _refresh(),
        onLoad: () async => _fetch(),
        child: ListView(
          children: <Widget>[..._l.map((e) => _complaintsCover(e))],
        ),
      ),
    );
  }

  /// 投诉订单封面
  Widget _complaintsCover(ComplaintsRes res) {
    // 动态显示大师、用户头像
    String url = CusRole.is_master ? res.icon : res.master_icon;
    String nick = CusRole.is_master ? res.nick : res.master_nick;
    return InkWell(
      onTap: () => CusRoute.push(
        context,
        ComplaintsDetailPage(id: res.id, isHis: widget.isHis),
      ),
      child: Card(
        color: fif_primary,
        margin: EdgeInsets.symmetric(vertical: S.h(2)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
          child: _coverItem(res, url, nick),
        ),
      ),
    );
  }

  Widget _coverItem(ComplaintsRes res, String url, nick) {
    TextStyle tGray = TextStyle(color: t_gray, fontSize: S.sp(15));
    TextStyle tPrimary = TextStyle(color: t_primary, fontSize: S.sp(15));
    return Row(
      children: <Widget>[
        CusAvatar(url: url, rate: 20), // 大师或者用户的头像
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(nick, style: tPrimary), // 大师或者用户的昵称
                  Spacer(),
                  Text(
                    res.draw_back ? "退款 ${res.amt} 元宝" : "", // 退款金额
                    style: tPrimary,
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints(minHeight: S.h(50)),
                child: Text(
                  res.brief, // 投诉大师的摘要
                  style: tGray,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: <Widget>[
                  Text(_statView(res), style: tPrimary), // 投诉状态
                  Spacer(),
                  Text(res.create_date, style: tGray), // 投诉时间
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 显示投诉状态
  String _statView(ComplaintsRes res) {
    if (res.stat == 1 || res.stat == 4) {
      return res.draw_back ? "已退款" : "已审批";
    }
    if (res.stat == -1) {
      return "已驳回";
    }
    return "";
  }

  _refresh() async {
    _l.clear();
    _pageNo = _rowsCount = 0;
    setState(() {});
    await _fetch();
  }

  @override
  bool get wantKeepAlive => true;
}
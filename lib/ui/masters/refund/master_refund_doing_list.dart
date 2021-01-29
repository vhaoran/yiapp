import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/orders/refund_res.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/masters/refund/master_refund_doing_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/post_com/refund_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午5:55
// usage ：大师处理中的投诉订单列表
// ------------------------------------------------------

class MasterRefundDoingList extends StatefulWidget {
  MasterRefundDoingList({Key key}) : super(key: key);

  @override
  _MasterRefundDoingListState createState() => _MasterRefundDoingListState();
}

class _MasterRefundDoingListState extends State<MasterRefundDoingList>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<RefundRes> _l = []; // 投诉的大师订单结果

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
      "where": {
        "stat": {
          "\$in": [refund_await, refund_b_pass] // 运营商已审批核待审批的
        },
        "master_id": ApiBase.uid
      }
    };
    try {
      PageBean pb = await ApiYiOrder.refundOrderPage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("大师总的处理中投诉大师订单个数 $_rowsCount");
        var l = pb.data.map((e) => e as RefundRes).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        setState(() {});
        Log.info("大师已加载处理中投诉大师订单个数 ${_l.length}");
      }
    } catch (e) {
      Log.error("大师查看处理中投诉大师订单出现异常：$e");
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
          children: <Widget>[
            if (_l.isEmpty) EmptyContainer(text: "暂无订单"),
            if (_l.isNotEmpty)
              ..._l.map(
                (e) => InkWell(
                  onTap: () => CusRoute.push(
                    context,
                    MasterRefundDoingPage(refundId: e.id),
                  ),
                  child: RefundComCover(
                    refundRes: e,
                    nick: e.nick,
                    iconUrl: e.icon,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
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

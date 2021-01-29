import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/orders/refund_res.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/vip/refund/user_refund_his_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/post_com/refund_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午6:59
// usage ：会员已完成的投诉订单列表
// ------------------------------------------------------

class UserRefundHisList extends StatefulWidget {
  UserRefundHisList({Key key}) : super(key: key);

  @override
  _UserRefundHisListState createState() => _UserRefundHisListState();
}

class _UserRefundHisListState extends State<UserRefundHisList>
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
          "\$in": [refund_p_pass, refund_r] // 平台已审批的和已驳回的
        },
        "uid": ApiBase.uid
      }
    };
    try {
      PageBean pb = await ApiYiOrder.refundOrderHisPage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("会员总的已处理投诉大师订单个数：$_rowsCount");
        var l = pb.data.map((e) => e as RefundRes).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        setState(() {});
        Log.info("会员已加载已处理投诉大师订单个数：${_l.length}");
      }
    } catch (e) {
      Log.error("会员查看已处理投诉大师订单出现异常：$e");
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
                    UserRefundHisPage(refundId: e.id),
                  ),
                  child: RefundComCover(
                    refundRes: e,
                    nick: e.master_nick,
                    iconUrl: e.master_icon,
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

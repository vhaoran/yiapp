import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/masters/yiorder/master_yiorder_his_page.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/yiorder_com_button.dart';
import 'package:yiapp/widget/post_com/yiorder_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午5:24
// usage ：大师已完成的大师订单列表
// ------------------------------------------------------

class MasterYiOrderHisListPage extends StatefulWidget {
  MasterYiOrderHisListPage({Key key}) : super(key: key);

  @override
  _MasterYiOrderHisListPageState createState() =>
      _MasterYiOrderHisListPageState();
}

class _MasterYiOrderHisListPageState extends State<MasterYiOrderHisListPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<YiOrder> _l = []; // 大师已完成的大师订单列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 大师分页查询已完成的大师订单
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"master_id": ApiBase.uid, "stat": yiorder_ok},
      "sort": {"create_date": -1},
    };
    try {
      PageBean pb = await ApiYiOrder.yiOrderHisPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as YiOrder).toList();
      Log.info("大师已完成大师订单总数 $_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Log.info("大师已查询已完成大师订单个数 ${_l.length}");
    } catch (e) {
      Log.error("大师分页查询已完成大师订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CusAppBar(text: "已完成大师订单"),
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
        return ScrollConfiguration(
          behavior: CusBehavior(),
          child: EasyRefresh(
            header: CusHeader(),
            footer: CusFooter(),
            onLoad: () async => await _fetch(),
            onRefresh: () async => await _refresh(),
            child: ListView(
              children: <Widget>[
                if (_l.isEmpty) EmptyContainer(text: "暂无订单"),
                ..._l.map(
                  (e) => InkWell(
                    onTap: () => _lookYiOrderPage(e.id),
                    child: YiOrderComCover(
                      yiOrder: e,
                      iconUrl: e.icon_ref,
                      nick: e.nick_ref,
                      child: YiOrderComButton(
                        text: "详情",
                        onPressed: () => _lookYiOrderPage(e.id),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 查看已完成大师订单页
  void _lookYiOrderPage(String yiOrderId) {
    CusRoute.push(context, MasterYiOrderHisPage(yiOrderId: yiOrderId))
        .then((value) {
      if (value != null) _refresh();
    });
  }

  /// 刷新数据
  _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    setState(() {});
    await _fetch();
  }

  @override
  bool get wantKeepAlive => true;
}

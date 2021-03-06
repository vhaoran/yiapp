import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/master/master_order_cover.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-yi-order.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/20 17:11
// usage ：大师自查未完成订单
// ------------------------------------------------------

class MasterAwaitOrders extends StatefulWidget {
  MasterAwaitOrders({Key key}) : super(key: key);

  @override
  _MasterAwaitOrdersState createState() => _MasterAwaitOrdersState();
}

class _MasterAwaitOrdersState extends State<MasterAwaitOrders>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<YiOrder> _l = []; // 大师未完成列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询大师未完成列表
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "sort": {"create_date": -1},
    };
    try {
      PageBean pb = await ApiYiOrder.yiOrderPageOfMaster(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as YiOrder).toList();
      Log.info("总的大师未完成列表个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      if (mounted) setState(() {});
      Log.info("当前已查询大师未完成列表个数：${_l.length}");
    } catch (e) {
      Log.error("分页查询大师未完成列表出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildFb();
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(child: CusText("你还没有相关订单", t_gray, 32));
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
                ..._l.map((e) => MasterOrderCover(yiOrder: e)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 刷新数据
  _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

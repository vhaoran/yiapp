import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/master/master_order_cover.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-yi-order.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/20 15:57
// usage ：管理员查看大师未处理的单子
// ------------------------------------------------------

class AdminMasterOrders extends StatefulWidget {
  AdminMasterOrders({Key key}) : super(key: key);

  @override
  _AdminMasterOrdersState createState() => _AdminMasterOrdersState();
}

class _AdminMasterOrdersState extends State<AdminMasterOrders> {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<YiOrder> _l = []; // 大师未完成列表(后台)

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询大师未完成列表(后台)
  _fetch() async {
    if (_pageNo * _rows_per_page > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rows_per_page,
      "sort": {"create_date": -1},
    };
    try {
      PageBean pb = await ApiYiOrder.boYiOrderPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as YiOrder).toList();
      Debug.log("总的大师未完成列表(后台)个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Debug.log("当前已查询大师未完成列表(后台)个数：${_l.length}");
    } catch (e) {
      Debug.logError("分页查询大师未完成列表(后台)出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "订单详情"),
      body: _buildFb(),
      backgroundColor: primary,
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(child: CusText("还没有相关订单", t_gray, 32));
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
  void _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }
}

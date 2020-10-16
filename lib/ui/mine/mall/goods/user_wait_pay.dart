import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/orders/cus_order_data.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-product-order.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/16 17:47
// usage ：用户待付款
// ------------------------------------------------------

class AwaitPayment extends StatefulWidget {
  AwaitPayment({Key key}) : super(key: key);

  @override
  _AwaitPaymentState createState() => _AwaitPaymentState();
}

class _AwaitPaymentState extends State<AwaitPayment> {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<ProductOrder> _l = []; // 未完成商城订单列表
  AllShopData _allShops; //

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询未完成商城订单
  _fetch() async {
    if (_pageNo * _rows_per_page > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rows_per_page,
      "where": {"stat": 1}, // 应该是 0:,先用1
    };
    try {
      PageBean pb = await ApiProductOrder.productOrderPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as ProductOrder).toList();
      Debug.log("总的未完成商城订单个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Debug.log("用户待付款订单个数：${_l.length}");
    } catch (e) {
      Debug.logError("用户查询待付款订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "待付款"),
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
          return Center(child: CusText("您还没有相关的订单", t_gray, 28));
        }
        return EasyRefresh(
          header: CusHeader(),
          footer: CusFooter(),
          child: ListView(
            children: <Widget>[
              ...List.generate(
                _l.length,
                (i) => Text("123"),
              ),
            ],
          ),
          onLoad: () async {
            await _fetch();
            setState(() {});
          },
          onRefresh: () async {
            await _refresh();
          },
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

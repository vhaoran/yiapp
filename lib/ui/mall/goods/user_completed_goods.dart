import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-product-order.dart';
import 'package:yiapp/ui/mall/goods/complete_detail.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/17 14:05
// usage ：已完成订单
// ------------------------------------------------------

class CompletedGoods extends StatefulWidget {
  CompletedGoods({Key key}) : super(key: key);

  @override
  _CompletedGoodsState createState() => _CompletedGoodsState();
}

class _CompletedGoodsState extends State<CompletedGoods> {
  var _future;
  int _page_no = 0;
  int _rowsCount = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<ProductOrder> _l = []; // 已完成订单列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询已完成订单
  _fetch() async {
    if (_page_no * _rows_per_page > _rowsCount) return;
    _page_no++;
    var m = {
      "page_no": _page_no,
      "rows_per_page": _rows_per_page,
      "sort": {"create_time_int": -1},
      "where": {"stat": 1},
    };
    try {
      PageBean pb = await ApiProductOrder.productOrderPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as ProductOrder).toList();
      Log.info("已完成订单总个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Log.info("用户当前自查已完成订单多少条：${_l.length}");
    } catch (e) {
      Log.error("用户自查已完成订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "已完成订单"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (_l.isEmpty) {
            return Center(
              child: Text(
                "",
                style: TextStyle(color: t_gray, fontSize: S.sp(15)),
              ),
            );
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return EasyRefresh(
      header: CusHeader(),
      footer: CusFooter(),
      child: ListView(
        children: <Widget>[
          ..._l.map(
            (e) => InkWell(
              onTap: () => CusRoute.push(
                context,
                CompleteDetail(order: e, id: e.id),
              ),
              child: _coverItem(e),
            ),
          ),
        ],
      ),
      onLoad: () async {
        await _fetch();
        setState(() {});
      },
      onRefresh: () async => _refresh(),
    );
  }

  /// 单个已完成订单封面
  Widget _coverItem(ProductOrder order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: S.w(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ...order.items.map(
              (e) => Padding(
                padding: EdgeInsets.symmetric(vertical: S.h(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Text(
                        "${e.name}x${e.qty}",
                        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                      ),
                    ), // 商品名称
                    Flexible(
                      flex: 1,
                      child: Text(
                        "颜色：${e.color_code}",
                        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                      ),
                    ), // 商品颜色
                    Flexible(
                      flex: 1,
                      child: Text(
                        "颜色：${e.color_code}",
                        style: TextStyle(color: t_yi, fontSize: S.sp(15)),
                      ),
                    ), // 商品价格
                  ],
                ),
              ),
            ),
            SizedBox(height: S.h(10)),
            Row(
              children: <Widget>[
                Text(
                  "${order.create_date}",
                  style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                ),
                Spacer(),
                Text(
                  "合计:￥${order.amt}",
                  style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                ),
              ],
            ),
            SizedBox(height: S.h(10)),
          ],
        ),
      ),
      color: fif_primary,
      shadowColor: t_gray,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }

  /// 刷新数据
  void _refresh() async {
    _page_no = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }
}

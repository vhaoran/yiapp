import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-product-order.dart';
import 'package:yiapp/ui/mine/mall/goods/complete_detail.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_details.dart';

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
  int _pageNo = 0;
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
    if (_pageNo * _rows_per_page > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rows_per_page,
      "sort": {"create_time_int": -1},
      "where": {"stat": 2},
    };
    try {
      PageBean pb = await ApiProductOrder.productOrderPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as ProductOrder).toList();
      Debug.log("已完成订单总个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Debug.log("用户当前自查已完成订单多少条：${_l.length}");
    } catch (e) {
      Debug.logError("用户自查已完成订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "已完成订单"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
            return Center(child: CircularProgressIndicator());
          }
          if (_l.isEmpty) {
            return Center(child: CusText("您还没有相关的订单", t_gray, 28));
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
          ...List.generate(_l.length, (i) => _coverItem(_l[i])),
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
  }

  /// 单个已完成订单封面
  Widget _coverItem(ProductOrder order) {
    return InkWell(
      onTap: () => CusRoutes.push(
        context,
        CompleteDetail(order: order, id: order.id),
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ...order.items.map(
                (e) => Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () => CusRoutes.push(
                      context,
                      ProductDetails(id_of_es: e.product_id),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: CusText("${e.name}x${e.qty}", t_gray, 30),
                        ), // 商品名称
                        Flexible(
                          flex: 1,
                          child: CusText("颜色：${e.color_code}", t_gray, 30),
                        ), // 商品颜色
                        Flexible(
                          flex: 1,
                          child: CusText("总价:￥${e.amt}", t_yi, 30),
                        ), // 商品价格
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  CusText("${order.createDate}", t_gray, 28),
                  Spacer(),
                  CusText("合计:￥${order.total_amt}", t_primary, 28),
                ],
              )
            ],
          ),
        ),
        color: fif_primary,
        shadowColor: t_gray,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
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

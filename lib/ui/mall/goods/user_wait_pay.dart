import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-product-order.dart';
import 'package:yiapp/ui/mall/product/product_detail/product_details.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/17 11:57
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
  List<ProductOrder> _l = []; // 待付款列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询待付款订单
  _fetch() async {
    if (_pageNo * _rows_per_page > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rows_per_page,
      "where": {"stat": 0},
    };
    try {
      PageBean pb = await ApiProductOrder.productOrderPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as ProductOrder).toList();
      Log.info("待付款总个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Log.info("用户自查待付款订单多少条：${_l.length}");
    } catch (e) {
      Log.error("用户自查待付款订单出现异常：$e");
    }
  }

  /// 付款
  void _doPay(String id) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "待付款"),
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
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ...order.items.map(
              (e) => Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: InkWell(
                  onTap: () => CusRoute.push(
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
                CusText("${order.createDate}", t_gray, 30),
                Spacer(),
                CusText("合计:￥${order.total_amt}", t_primary, 28),
              ],
            ),
            CusRaisedBtn(
              text: "付款",
              pdHor: 40,
              fontSize: 26,
              textColor: Colors.white,
              backgroundColor: Color(0xFFCB4031),
              borderRadius: 100,
              onPressed: () => _doPay(order.id),
            ),
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
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }
}

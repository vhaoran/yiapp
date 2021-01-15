import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
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
  int _page_no = 0;
  int _rows_count = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<ProductOrder> _l = []; // 待付款列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询待付款订单
  _fetch() async {
    if (_page_no * _rows_per_page > _rows_count) return;
    _page_no++;
    var m = {
      "page_no": _page_no,
      "rows_per_page": _rows_per_page,
      "where": {"stat": 0},
      "sort": {"create_time_int": -1},
    };
    try {
      PageBean pb = await ApiProductOrder.productOrderPage(m);
      if (_rows_count == 0) _rows_count = pb.rowsCount;
      var l = pb.data.map((e) => e as ProductOrder).toList();
      Log.info("待付款总个数：$_rows_count");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "待付款"),
      body: buildFb(),
      backgroundColor: primary,
    );
  }

  Widget buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(
            child: Text(
              "暂无待付款订单",
              style: TextStyle(color: t_gray, fontSize: S.sp(18)),
            ),
          );
        }
        return EasyRefresh(
          header: CusHeader(),
          footer: CusFooter(),
          child: ListView(
            children: <Widget>[
              ..._l.map((e) {
                return InkWell(
                  onTap: () => CusRoute.push(
                    context,
                    ProductDetails(id_of_es: e.items.first.product_id),
                  ),
                  child: _coverItem(e),
                );
              }),
            ],
          ),
          onLoad: () async => await _fetch(),
          onRefresh: () async => _refresh(),
        );
      },
    );
  }

  /// 单个已完成订单封面
  Widget _coverItem(ProductOrder order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ...order.items.map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: CusText("${e.name}x${e.qty}", t_gray, 30),
                  ), // 商品名称
                  Flexible(
                    flex: 1,
                    child: CusText("规格：${e.color_code}", t_gray, 30),
                  ), // 商品颜色
                  Flexible(
                    flex: 1,
                    child: CusText("总价:￥${e.amt}", t_yi, 30),
                  ), // 商品价格
                ],
              ),
            ),
            SizedBox(height: S.h(5)),
            Row(
              children: <Widget>[
                CusText("${order.create_date}", t_gray, 30),
                Spacer(),
                CusText("合计:￥${order.amt}", t_primary, 28),
              ],
            ),
            SizedBox(height: S.h(10)),
            CusRaisedButton(
              child: Text("付款"),
              padding:
                  EdgeInsets.symmetric(vertical: S.h(3), horizontal: S.w(15)),
              borderRadius: 50,
              onPressed: () => BalancePay(
                context,
                data: PayData(amt: order.amt, b_type: b_mall, id: order.id),
              ),
            ),
            SizedBox(height: S.h(5)),
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
    _page_no = _rows_count = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }
}

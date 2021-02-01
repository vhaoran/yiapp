import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api_base.dart';
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
// date  ：2021/2/1 上午9:35
// usage ：会员待付款商城订单
// ------------------------------------------------------

class UserMallUnpaidPage extends StatefulWidget {
  UserMallUnpaidPage({Key key}) : super(key: key);

  @override
  _UserMallUnpaidPageState createState() => _UserMallUnpaidPageState();
}

class _UserMallUnpaidPageState extends State<UserMallUnpaidPage> {
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
      "where": {"stat": mall_unpaid, "uid": ApiBase.uid},
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
      setState(() {});
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
          onRefresh: () async => await _refresh(),
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
                  SizedBox(
                    width: S.screenW() * 2 / 5,
                    child: Text(
                      "${e.name}x${e.qty}",
                      style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ), // 商品名称
                  SizedBox(width: S.w(10)),
                  // 商品颜色
                  Text(
                    "规格 ${e.color_code}",
                    style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                  ),
                  Spacer(),
                  // 商品价格
                  Text(
                    "单价 ${e.amt} 元",
                    style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                  ),
                ],
              ),
            ),
            SizedBox(height: S.h(5)),
            Text(
              "合计 ${order.amt} 元",
              style: TextStyle(color: t_primary, fontSize: S.sp(15)),
            ),
            Padding(
              padding: EdgeInsets.only(top: S.h(10), bottom: S.h(5)),
              child: Row(
                children: <Widget>[
                  Text(
                    "${order.create_date}",
                    style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                  ),
                  Spacer(),
                  CusRaisedButton(
                    child: Text(
                      "付款",
                      style: TextStyle(color: Colors.white, fontSize: S.sp(14)),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: S.h(3), horizontal: S.w(15)),
                    borderRadius: 50,
                    onPressed: () => BalancePay(
                      context,
                      data:
                          PayData(amt: order.amt, b_type: b_mall, id: order.id),
                      onSuccess: _refresh,
                    ),
                  ),
                ],
              ),
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
  _refresh() async {
    _page_no = _rows_count = 0;
    _l.clear();
    setState(() {});
    await _fetch();
  }
}

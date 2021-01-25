import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-product-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/mall/product/product_detail/product_details.dart';
import 'package:yiapp/ui/mine/my_orders/complaints_add.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/refresh_hf.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/16 下午6:16
// usage ：用户已收货
// ------------------------------------------------------

class HadGetGoodsPage extends StatefulWidget {
  HadGetGoodsPage({Key key}) : super(key: key);

  @override
  _HadGetGoodsPageState createState() => _HadGetGoodsPageState();
}

class _HadGetGoodsPageState extends State<HadGetGoodsPage> {
  var _future;
  int _page_no = 0;
  int _rows_count = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<ProductOrder> _l = []; // 已收货列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询已收货商城订单
  _fetch() async {
    if (_page_no * _rows_per_page > _rows_count) return;
    _page_no++;
    var m = {
      "page_no": _page_no,
      "rows_per_page": _rows_per_page,
      "where": {"stat": mall_received, "uid": ApiBase.uid},
      "sort": {"create_time_int": -1},
    };
    try {
      PageBean pb = await ApiProductOrder.productOrderHisPage(m);
      if (_rows_count == 0) _rows_count = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as ProductOrder).toList();
      Log.info("已收货订单总个数：$_rows_count");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Log.info("用户自查已收货订单多少条：${_l.length}");
    } catch (e) {
      Log.error("用户自查已收货订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "已收货"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (_l.isEmpty) {
            return Center(
              child: Text(
                "暂无已收货记录",
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
          ...List.generate(_l.length, (i) => _coverItem(_l[i]))
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

  /// 单个未完成订单封面
  Widget _coverItem(ProductOrder order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: S.h(15), right: S.h(15), top: S.h(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ...order.items.map(
              (e) => InkWell(
                onTap: () => CusRoute.push(
                  context,
                  ProductDetails(id_of_es: e.product_id),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: S.screenW() * 2 / 5,
                      child: Text(
                        "${e.name}x${e.qty}",
                        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                      ),
                    ), // 商品名称
                    SizedBox(width: S.w(10)),
                    // 商品颜色
                    Text(
                      "规格：${e.color_code}",
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
            ),
            SizedBox(height: S.h(5)),
            Row(
              children: <Widget>[
                Text(
                  "合计 ${order.amt} 元",
                  style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                ),
                Spacer(),
                Text(
                  "${order.create_date}",
                  style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                ),
              ],
            ),
            SizedBox(height: S.h(5)),
//            Padding(
//              padding: EdgeInsets.only(top: S.h(10), bottom: S.h(5)),
//              child: Row(
//                children: <Widget>[
//                  Spacer(),
//                  CusRaisedButton(
//                    child: Text(
//                      "投诉",
//                      style: TextStyle(color: Colors.white, fontSize: S.sp(14)),
//                    ),
//                    padding: EdgeInsets.symmetric(
//                        vertical: S.h(3), horizontal: S.w(15)),
//                    borderRadius: 50,
//                    onPressed: () => CusRoute.push(
//                      context,
//                      ComplaintsAdd(productOrder: order),
//                    ),
//                  ),
//                ],
//              ),
//            ),
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

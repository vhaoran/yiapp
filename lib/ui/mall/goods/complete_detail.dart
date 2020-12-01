import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/model/orders/productOrder-item.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/service/api/api-product-order.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/17 14:42
// usage ：已完成订单详情
// ------------------------------------------------------

class CompleteDetail extends StatefulWidget {
  final ProductOrder order;
  final String id;

  CompleteDetail({this.order, this.id, Key key}) : super(key: key);

  @override
  _CompleteDetailState createState() => _CompleteDetailState();
}

class _CompleteDetailState extends State<CompleteDetail> {
  var _future;
  var _order = ProductOrder(); // 当前订单详情

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取单个已完成订单
  _fetch() async {
    try {
      var res = await ApiProductOrder.productOrderHisGet(widget.id);
      if (res != null) _order = res;
    } catch (e) {
      _order = widget.order;
      Log.error("获取单个已完成订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "订单详情"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
            child: CusText("收货人", t_primary, 30),
          ),
          _addrCtr(), // 收货人
          Padding(
            padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
            child: Row(
              children: <Widget>[
                CusText("订单详情", t_primary, 30),
                SizedBox(width: Adapt.px(60)),
                CusText("合计:￥${_order.total_amt}", t_primary, 30),
              ],
            ),
          ),
          ..._order.items.map((e) => _colorPrice(e)), // 商品的颜色和价格
          Padding(
            padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
            child: CusText("时间：${_order.createDate}", t_primary, 30),
          ),
        ],
      ),
    );
  }

  /// 收货人
  Widget _addrCtr() {
    return Card(
      color: fif_primary,
      shadowColor: t_gray,
      child: Padding(
        padding: EdgeInsets.all(Adapt.px(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CusText(_order.contact, t_primary, 30), // 收件人
                SizedBox(width: Adapt.px(30)),
                CusText(_order.addr.mobile, t_primary, 30), // 手机号
              ],
            ),
            SizedBox(height: Adapt.px(10)),
            Text(
              _order.addr.detail, // 收货地址
              style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  /// 单个订单详情
  Widget _colorPrice(ProductOrderItem e) {
    return Card(
      color: fif_primary,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CusText("${e.name}", t_gray, 28), // 商品名称
                SizedBox(width: Adapt.px(30)),
                CusText("颜色：${e.color_code}", t_gray, 28), // 商品颜色
              ],
            ),
            SizedBox(height: Adapt.px(30)),
            Row(
              children: <Widget>[
                CusText("价格：${e.price}", t_gray, 28), // 商品价格
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
                  child: CusText("购买数量：${e.qty}", t_gray, 28),
                ), // 商品购买数量
                CusText("总价：${e.amt}", t_gray, 28), // 商品总价
              ],
            ),
          ],
        ),
      ),
    );
  }
}

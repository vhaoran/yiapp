import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/complex/address_result.dart';
import 'package:yiapp/model/complex/cus_order_data.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-product-order.dart';
import 'package:yiapp/temp/shopcart_func.dart';
import 'package:yiapp/ui/mall/product/product_detail/p_order_address.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/15 10:20
// usage ：商品订单详情
// ------------------------------------------------------

class ProductOrderPage extends StatefulWidget {
  final AllShopData allShop;
  final bool isShop; // 是否购物车

  ProductOrderPage({this.allShop, this.isShop, Key key}) : super(key: key);

  @override
  _ProductOrderPageState createState() => _ProductOrderPageState();
}

class _ProductOrderPageState extends State<ProductOrderPage> {
  AddressResult _addr; // 收货地址
  List<SingleShopData> _l; // 订单数据

  @override
  void initState() {
    _l = widget.allShop.shops;
    super.initState();
  }

  /// 提交订单
  void _doBuy() async {
    List<Map> maps = [];
    _l.forEach((e) {
      maps.add({
        "product_id": e.product.id_of_es,
        "name": e.product.name,
        "color_code": e.color.code,
        "price": e.color.price, // 单价
        "qty": e.count, // 购买个数
      });
    });
    var m = {
      "items": maps,
      "contact": _addr.contact_person, // 联系人
      "addr": {"detail": _addr.detail, "mobile": _addr.mobile},
    };
    try {
      var res = await ApiProductOrder.productOrderAdd(m);
      if (res != null) {
        Log.info("商城订单已生成");
        Navigator.pop(context);
        if (widget.isShop) {
          // 如果是购物车，则清空数据
          AllShopData data = await ShopKV.remove(widget.allShop);
          bool ok = await ShopKV.refresh(data);
          print(">>>删除购物车数据结果：$ok");
        }
        BalancePay(
          context,
          data: PayData(amt: widget.allShop.amt, b_type: b_mall, id: res.id),
        );
      }
    } catch (e) {
      Log.error("提交订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "确认订单"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(height: S.h(5)),
                // 显示和选择收货地址
                ProOrderAddress(
                  onChanged: (val) => setState(() => _addr = val),
                ),
                ..._l.map((e) => _colorPrice(e)), // 商品的颜色和价格
              ],
            ),
          ),
          _bottomArea(), // 底部结算区域
        ],
      ),
    );
  }

  /// 商品的颜色和价格
  Widget _colorPrice(SingleShopData e) {
    return Card(
      color: fif_primary,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          children: <Widget>[
            CusAvatar(url: e.path, rate: 20, size: 100),
            SizedBox(width: Adapt.px(Adapt.px(50))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CusText("颜色：${e.color.code}", t_gray, 28), // 商品颜色
                    SizedBox(width: Adapt.px(30)),
                    CusText("价格：${e.color.price}", t_gray, 28), // 商品价格
                  ],
                ),
                SizedBox(height: Adapt.px(30)),
                // 商品购买数量
                CusText("购买数量：${e.count}", t_gray, 28),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 底部结算区域
  Widget _bottomArea() {
    return Container(
      color: fif_primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "共${widget.allShop.counts}件",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
          SizedBox(width: S.w(5)),
          Text(
            "￥合计:${widget.allShop.amt}",
            style: TextStyle(color: t_yi, fontSize: S.sp(16)),
          ),
          InkWell(
            onTap: _doBuy,
            child: Container(
              child: Text(
                "提交订单",
                style: TextStyle(color: Colors.white, fontSize: S.sp(14)),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xFFEA6A2C),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

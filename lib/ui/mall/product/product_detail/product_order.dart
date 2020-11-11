import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/function/shopcart_func.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/small/cus_loading.dart';
import 'package:yiapp/model/complex/address_result.dart';
import 'package:yiapp/complex/model/cus_order_data.dart';
import 'package:yiapp/model/orders/productOrder-item.dart';
import 'package:yiapp/service/api/api-product-order.dart';
import 'package:yiapp/ui/mine/com_pay_page.dart';
import 'package:yiapp/ui/mall/product/product_detail/p_order_address.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/15 10:20
// usage ：商品订单详情
// ------------------------------------------------------

class ProductOrderPage extends StatefulWidget {
  final AllShopData allShop;

  ProductOrderPage({this.allShop, Key key}) : super(key: key);

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
    CusLoading(context);
    Navigator.pop(context);
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
        AllShopData data = await ShopKV.remove(widget.allShop);
        bool ok = await ShopKV.refresh(data);
        if (ok) {
          CusToast.toast(
            context,
            text: "订单提交成功，即将跳转到支付界面",
            milliseconds: 1500,
          );
          Future.delayed(Duration(milliseconds: 1500)).then(
            (value) => CusRoutes.pushReplacement(
              context,
              ComPayPage(
                tip: "商城订单付款",
                b_type: b_yi_order,
                orderId: res.id,
                amt: num.parse("${widget.allShop.amt}"),
              ),
            ),
          );
          Navigator.of(context).pop("");
        }
      }
    } catch (e) {
      Debug.logError("提交订单出现异常：$e");
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
                SizedBox(height: Adapt.px(10)),
                // 显示和选择收货地址
                ProOrderAddress(
                  onChanged: (val) => setState(() => _addr = val),
                ),
                ..._l.map((e) => _colorPrice(e)), // 商品的颜色和价格
                SizedBox(height: 60),
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
          CusText("共${widget.allShop.counts}件", t_gray, 28),
          SizedBox(width: Adapt.px(10)),
          CusText("￥合计:${widget.allShop.amt}", t_yi, 32),
          InkWell(
            onTap: _doBuy,
            child: Container(
              child: CusText("提交订单", Colors.white, 28),
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

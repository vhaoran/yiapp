import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_user.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_color_show.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_count.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_loops.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_order.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/5 11:43
// usage ：单个商品详情
// ------------------------------------------------------

class ProductDetails extends StatefulWidget {
  final String id_of_es;

  ProductDetails({this.id_of_es, Key key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var _future;
  Product _product = Product();
  ProductColor _color; // 选择的商品颜色和价格
  int _count = 0; // 购买的数量
  String _path = ""; // 选择的商品的图片链接

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  // 根据id获取单个商品详情
  _fetch() async {
    try {
      Product res = await ApiProduct.productGet(widget.id_of_es);
      Debug.log("产品详情：${res.toJson()}");
      if (res != null) _product = res;
    } catch (e) {
      Debug.logError("查看商品时，根据id获取商品出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "商品详情"),
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
    return Column(
      children: <Widget>[
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: ListView(
              children: <Widget>[
                ProductLoops(product: _product), // 商品轮播图
                SizedBox(height: Adapt.px(15)),
                _productName(), // 商品名称
                SizedBox(height: Adapt.px(15)),
                _colorPrice(), // 商品颜色和价格
                SizedBox(height: Adapt.px(15)),
                ProductCount(
                  OnChanged: (val) => setState(() => _count = val),
                ), // 商品的购买数量
              ],
            ),
          ),
        ),
        Row(
          children: <Widget>[
            _addShopCart(), // 加入购物车
            _doReadyBuy(), // 点击购买
          ],
        ),
      ],
    );
  }

  /// 商品名称
  Widget _productName() {
    return Container(
      color: fif_primary, // 商品名称
      padding: EdgeInsets.all(Adapt.px(20)),
      child: Text(
        _product.name,
        style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 商品颜色和价格
  Widget _colorPrice() {
    return InkWell(
      onTap: () => CusRoutes.push(
        context,
        ProductColorShow(
          product: _product,
          fnColor: (val) => setState(() => _color = val),
          OnPath: (val) => setState(() => _path = val),
        ),
      ),
      child: Container(
        color: fif_primary,
        padding: EdgeInsets.all(Adapt.px(20)),
        child: Row(
          children: <Widget>[
            CusText("请选择颜色分类", t_gray, 28),
            SizedBox(width: Adapt.px(40)),
            _color == null
                ? CusText("共 ${_product.colors.length} 种颜色可选", t_gray, 28)
                : CusText("已选：${_color.code}", t_gray, 28),
          ],
        ),
      ),
    );
  }

  /// 加入购物车
  Widget _addShopCart() {
    return Flexible(
      flex: 1,
      child: RaisedButton(
        child: Container(
          height: Adapt.px(80),
          alignment: Alignment.center,
          child: CusText("加入购物车", Colors.black, 30),
        ),
        color: Color(0xFFF2B83F),
        onPressed: () async {},
      ),
    );
  }

  /// 立即购买
  Widget _doReadyBuy() {
    return Flexible(
      flex: 1,
      child: RaisedButton(
        child: Container(
          height: Adapt.px(80),
          alignment: Alignment.center,
          child: CusText("立即购买", Colors.black, 30),
        ),
        color: Color(0xFFEB7E31),
        onPressed: () async {
          if (_color == null) {
            CusToast.toast(context, text: "请选择商品颜色");
            return;
          }
          if (_count == 0 || _count == null) {
            CusToast.toast(context, text: "请选择商品数量");
            return;
          }
          try {
            var res = await ApiUser.userAddrList(ApiBase.uid);
            if (res != null) {
              CusRoutes.push(
                context,
                ProductOrderPage(
                  product: _product,
                  firstAddr: res.first,
                  color: _color,
                  path: _path,
                  count: _count,
                ),
              ).then((val) => {if (val != null) Navigator.pop(context)});
            }
          } catch (e) {
            Debug.logError("出现异常：$e");
            CusDialog.tip(context, title: "请先在个人信息中添加收货地址");
          }
        },
      ),
    );
  }
}

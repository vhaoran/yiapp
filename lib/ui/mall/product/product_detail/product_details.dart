import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/ui/mall/product/product_detail/product_color_show.dart';
import 'package:yiapp/ui/mall/product/product_detail/product_loops.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/15 09:56
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
  Product _product;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  // 根据id获取单个商品详情
  _fetch() async {
    try {
      Product res = await ApiProduct.bProductGet(widget.id_of_es);
      Log.info("当前商品详情：${res.toJson()}");
      if (res != null) _product = res;
    } catch (e) {
      Log.error("查看商品时，根据id获取商品出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "商品详情", backData: true),
      body: _buildFb(),
      backgroundColor: primary,
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (_product == null) {
            return Center(
              child: Text(
                "暂无数据",
                style: TextStyle(color: t_gray, fontSize: S.sp(16)),
              ),
            );
          }
          return Column(children: <Widget>[
            Expanded(
              child: ScrollConfiguration(
                behavior: CusBehavior(),
                child: _lv(),
              ),
            ),
            Row(children: <Widget>[
              _shopBtn("加入购物车", Color(0xFFF2B83F), true),
              _shopBtn("立即购买", Color(0xFFEB7E31), false),
            ])
          ]);
        });
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        // 商品轮播图
        ProductLoops(product: _product),
        // 商品名称
        Container(
          color: fif_primary,
          margin: EdgeInsets.symmetric(vertical: S.h(10)),
          padding: EdgeInsets.all(S.w(10)),
          child: Text(
            _product.name,
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // 商品可选颜色
        Container(
          color: fif_primary,
          padding: EdgeInsets.all(S.w(10)),
          child: Text(
            "${_product.colors.length} 种颜色可选",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
        ),
      ],
    );
  }

  /// 加入购物车和立即购买的按钮
  Widget _shopBtn(String text, Color color, bool shopCart) {
    return Flexible(
      flex: 1,
      child: RaisedButton(
        child: Container(
          height: S.h(40),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: S.sp(16)),
          ),
        ),
        color: color,
        onPressed: () => CusRoute.push(
          context,
          ProductColorShow(product: _product, shopCart: shopCart),
        ),
      ),
    );
  }
}

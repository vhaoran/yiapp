import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_color_show.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_loops.dart';

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
      Product res = await ApiProduct.productGet(widget.id_of_es);
      if (res != null) _product = res;
    } catch (e) {
      Debug.logError("查看商品时，根据id获取商品出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "商品详情", refresh: true),
      body: FutureBuilder(
          future: _future,
          builder: (context, snap) {
            if (!snapDone(snap)) {
              return Center(child: CircularProgressIndicator());
            }
            if (_product == null) {
              return Center(
                child: CusText("暂未有商品详情", t_gray, 30),
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
                _bottomBtn("加入购物车", Color(0xFFF2B83F), true),
                _bottomBtn("立即购买", Color(0xFFEB7E31), false),
              ])
            ]);
          }),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        // 商品轮播图
        ProductLoops(product: _product),
        // 商品名称
        Container(
          color: fif_primary,
          margin: EdgeInsets.symmetric(vertical: Adapt.px(15)),
          padding: EdgeInsets.all(Adapt.px(20)),
          child: Text(
            _product.name,
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // 商品可选颜色
        Container(
          color: fif_primary,
          padding: EdgeInsets.all(Adapt.px(20)),
          child: CusText("${_product.colors.length} 种颜色可选", t_gray, 30),
        ),
      ],
    );
  }

  /// 加入购物车和立即购买的按钮
  Widget _bottomBtn(String text, Color color, bool shopCart) {
    return Flexible(
      flex: 1,
      child: RaisedButton(
        child: Container(
          height: Adapt.px(80),
          alignment: Alignment.center,
          child: CusText(text, Colors.black, 30),
        ),
        color: color,
        onPressed: () => CusRoutes.push(
          context,
          ProductColorShow(product: _product, shopCart: shopCart),
        ),
      ),
    );
  }
}

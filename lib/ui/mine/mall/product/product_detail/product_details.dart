import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/gather/cus_swiper_pagination.dart';
import 'package:yiapp/complex/widgets/gather/net_photoview.dart';
import 'package:yiapp/complex/widgets/small/cus_bg_wall.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_color_show.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_count.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_loops.dart';

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
                ProductColorShow(product: _product), // 商品颜色和对应价格
                SizedBox(height: Adapt.px(15)),
                ProductCount(), // 商品的购买数量
              ],
            ),
          ),
        ),
        RaisedButton(
          child: Container(
            height: Adapt.px(80),
            alignment: Alignment.center,
            child: CusText("点击购买", Colors.white, 30),
          ),
          color: Color(0xFFEB7E31),
          onPressed: () {},
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
}

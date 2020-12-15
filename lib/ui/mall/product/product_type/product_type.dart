import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/ui/mall/product/product_type/product_type_cover.dart';
import 'add_product_type.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/5 14:10
// usage ：商品分类
// ------------------------------------------------------

class ProductType extends StatefulWidget {
  ProductType({Key key}) : super(key: key);

  @override
  _ProductTypeState createState() => _ProductTypeState();
}

class _ProductTypeState extends State<ProductType> {
  var _future;
  List<Category> _l = []; // 商品种类列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      List<Category> res = await ApiProduct.categoryList();
      if (res != null) _l = res;
    } catch (e) {
      Log.error("获取商品分类出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "商品分类",
        actions: <Widget>[
          FlatButton(
            onPressed: () =>
                CusRoute.push(context, AddProductType()).then((val) {
              if (val != null) _refresh();
            }),
            child: CusText("新增", Colors.orangeAccent, 28),
          ),
        ],
      ),
      body: _bodyCtr(),
      backgroundColor: primary,
    );
  }

  Widget _bodyCtr() {
    Log.info("_l的长度：${_l.length}");
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(child: CusText("暂无分类", t_gray, 30));
        }
        return ScrollConfiguration(
          behavior: CusBehavior(),
          child: EasyRefresh(
            header: CusHeader(),
            onRefresh: () async {
              await _refresh();
            },
            child: ListView(
              children: <Widget>[
                SizedBox(height: Adapt.px(20)),
                ..._l.map(
                  (e) => ProductTypeCover(category: e, onChanged: _refresh),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _refresh() async {
    _l.clear();
    await _fetch();
    setState(() {});
  }
}

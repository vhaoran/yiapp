import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/ui/mine/mall/product_type/product_type_cover.dart';
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
      Debug.logError("获取商品分类出现异常：$e");
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
                CusRoutes.push(context, AddProductType()).then((val) {
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
    Debug.log("_l的长度：${_l.length}");
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
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

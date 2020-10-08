import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/ui/mine/mall/product/add_product/add_p_images.dart';
import 'package:yiapp/ui/mine/mall/product/add_product/chose_p_type.dart';
import 'package:yiapp/ui/mine/mall/product/add_product/add_p_name.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/6 19:27
// usage ：新增商品
// ------------------------------------------------------

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var _nameCtrl = TextEditingController(); // 商品名称
  var _future;
  List<Category> _l = []; // 已有的商品分类

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
      Debug.logError("新增商品时，获取商品分类出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "新增商品",
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: CusText("保存", Colors.orangeAccent, 28),
          )
        ],
      ),
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
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
        children: <Widget>[
          SizedBox(height: Adapt.px(30)),
          AddProductName(controller: _nameCtrl), // 商品名称
          ChoseProductType(l: _l), // 选择商品种类
          AddProductImages(), // 添加商品图片
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}

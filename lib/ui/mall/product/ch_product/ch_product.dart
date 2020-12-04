import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/temp/cus_tool.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_snackbar.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/ui/mall/product/ch_product/ch_p_color.dart';
import 'package:yiapp/ui/mall/product/ch_product/ch_p_name.dart';
import 'package:yiapp/ui/mall/product/ch_product/ch_p_type.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/9 12:02
// usage ：修改商品
// ------------------------------------------------------

class ChProduct extends StatefulWidget {
  final String id;

  ChProduct({this.id, Key key}) : super(key: key);

  @override
  _ChProductState createState() => _ChProductState();
}

class _ChProductState extends State<ChProduct> {
  var _nameCtrl = TextEditingController(); // 商品名称
  var _colorCtrl = TextEditingController(); // 商品颜色
  var _priceCtrl = TextEditingController(); // 商品价格
  Category _category = Category(); // 当前修改商品种类详情
  Product _product = Product(); // 当前修改商品的详情
//  List<Asset> _images; // 商品图片
  List<ProductColor> _cpList = []; // 商品的颜色和价格列表
  List<Category> _pTypes = []; // 已有的商品分类

  var _future;
  String _snackErr; // 提示信息
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _future = _fetch();

    super.initState();
  }

  _fetch() async {
    // 获取商品种类
    try {
      List<Category> res = await ApiProduct.categoryList();
      if (res != null) _pTypes = res;
    } catch (e) {
      Log.error("修改商品时，获取商品分类出现异常：$e");
    }
    // 根据id获取单个商品详情
    try {
      Product res = await ApiProduct.bProductGet(widget.id);
      if (res != null) _product = res;
    } catch (e) {
      Log.error("修改商品时，根据id获取商品出现异常：$e");
    }
    _category = Category(id: _product.cate_id, name: _product.cate_name);
    _cpList = _product.colors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CusAppBar(
        text: "修改商品",
        actions: <Widget>[
          FlatButton(
            onPressed: _verify,
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

  /// 满足新增商品条件，执行添加商品
  void _doAdd() async {
//    var s = await CusTool.assetsKeyPath(_images);
//    Debug.log("第一张图片的详情：key:${s.first['key']},path:${s.first['path']}");
//    var images = List<Map>();
//    s.forEach((e) {
//      images.add({"path": e['path'], "sort": 0});

    var m = {
      "id_of_es": _product.id_of_es,
      "M": {
        "cate_name": _category.name,
        "name": _nameCtrl.text.trim(),
        "remark": _nameCtrl.text.trim(), // 暂时先用这个
        "key_word": _category.name, // 关键词先用商品种类
        "images": _product.images, // 更换图片暂时没做，先用已有的,
        "colors": _cpList,
      },
    };
    try {
      bool ok = await ApiProduct.productCh(m);
      if (ok) {
        CusToast.toast(context, text: "修改成功");
        // 返回给上级被修改的商品 id
        Navigator.of(context).pop(_product.id_of_es);
      }
    } catch (e) {
      Log.error("修改商品出现异常：$e");
    }
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
        children: <Widget>[
          SizedBox(height: Adapt.px(30)),
          // 修改商品名称
          ChProductName(nameCtrl: _nameCtrl, name: _product.name),
          // 修改商品种类
          ChLineProductType(
            type: _category.name,
            pTypes: _pTypes,
            fnCategory: (val) => setState(() => _category = val),
          ),
          // 修改商品图片 Todo 修改商品图片比较复杂，做了一半，该功能暂时先不做
//          ChProductImages(
//            images: _product.images,
//            fnAssets: (val) => setState(() => _images = val),
//          ),
          // 商品颜色和价格
          ChProductColor(
            colorCtrl: _colorCtrl,
            priceCtrl: _priceCtrl,
            colorPrices: _product.colors,
            fnColorPrice: (val) => setState(() => _cpList = val),
          ),
        ],
      ),
    );
  }

  /// 验证输入信息
  void _verify() {
    setState(() {
      if (_snackErr != null) _snackErr = null; // 清空错误信息
      if (_nameCtrl.text.isEmpty) {
        _snackErr = "未设置商品名称";
      } else if (_category == null) {
        _snackErr = "未选择商品种类";
      }
//      else if (_images == null) {
//        _snackErr = "未选择商品图片";
//      }
      else if (_cpList.isEmpty) {
        _snackErr = "未添加商品颜色和价格";
      }
    });
    // 不满足新增商品条件
    if (_snackErr != null) {
      CusSnackBar(
        context,
        scaffoldKey: _scaffoldKey,
        text: _snackErr,
        milliseconds: 1200,
        backgroundColor: fif_primary,
      );
    }
    // 满足新增商品条件
    else {
      _doAdd();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _colorCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }
}

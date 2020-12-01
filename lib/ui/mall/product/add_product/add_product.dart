import 'dart:math';

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
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/ui/mall/product/add_product/add_p_color.dart';
import 'package:yiapp/ui/mall/product/add_product/add_p_images.dart';
import 'package:yiapp/ui/mall/product/add_product/add_p_name.dart';
import 'package:yiapp/ui/mall/product/add_product/chose_p_type.dart';
import 'package:yiapp/util/file_util.dart';

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
  var _colorCtrl = TextEditingController(); // 商品颜色
  var _priceCtrl = TextEditingController(); // 商品价格
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Category _category; // 当前选择的商品种类详情
  List<Asset> _images; // 商品图片
  List<ProductColor> _cpList = []; // 商品的颜色和价格列表
  String _snackErr; // 提示信息
  List<Category> _pTypes = []; // 已有的商品分类
  var _future;
  bool _loading = false;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      List<Category> res = await ApiProduct.categoryList();
      if (res != null) _pTypes = res;
    } catch (e) {
      Log.error("新增商品时，获取商品分类出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CusAppBar(
        text: "新增商品",
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
    SpinKit.threeBounce(context);
    List<Map> s = await FileUtil.multipleFiles(_images);
    Navigator.pop(context);
    var res = List<ProductImage>();
    s.forEach((e) {
      res.add(ProductImage(path: e['path'], sort_no: 0));
    });
    var images = res.map((e) => e.toJson()).toList();
    var colors = _cpList.map((e) => e.toJson()).toList();
    var m = {
      "cate_id": _category.id,
      "cate_name": _category.name,
      "name": _nameCtrl.text.trim(),
      "remark": _nameCtrl.text.trim(), // 商品备注暂时用商品名称代替
      "key_word": _category.name, // 关键词先用商品种类
      "enabled": true,
      "images": images,
      "colors": colors,
      "image_main": res.first.path, // 商品主图片暂时使用第一张
    };
    try {
      if (_loading) {}
      Product res = await ApiProduct.productAdd(m);
      setState(() {
        _loading = res == null ? true : false;
      });

      if (res != null) {
        CusToast.toast(context, text: "添加成功");
        Navigator.of(context).pop(res);
      }
    } catch (e) {
      Log.error("新增商品出现异常：$e");
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
          AddProductName(nameCtrl: _nameCtrl), // 商品名称
          // 选择商品种类
          ChoseProductType(
            pTypes: _pTypes,
            fnCategory: (val) => setState(() => _category = val),
          ),
          // 添加商品图片
          AddProductImages(
            fnAssets: (val) => setState(() => _images = val),
          ),
          // 商品颜色和价格
          ProductColorPrice(
            colorCtrl: _colorCtrl,
            priceCtrl: _priceCtrl,
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
      } else if (_images == null) {
        _snackErr = "未选择商品图片";
      } else if (_cpList.isEmpty) {
        _snackErr = "未添加商品颜色和价格";
      }
      if (_images.length != _cpList.length) {
        _snackErr = "商品图片个数与颜色价格表个数不相同";
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

import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/5 14:49
// usage ：新增和修改商品种类共用页面
// ------------------------------------------------------

class AddChProductType extends StatefulWidget {
  final Category category;

  AddChProductType({this.category, Key key}) : super(key: key);

  @override
  _AddChProductTypeState createState() => _AddChProductTypeState();
}

class _AddChProductTypeState extends State<AddChProductType> {
  bool _isAdd = false; // 是否为新增商品分类
  var _nameCtrl = TextEditingController(); // 商品名称
  String _err; // 错误提示信息

  @override
  void initState() {
    _isAdd = widget.category == null ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: _isAdd ? "新增商品分类" : "修改商品分类"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
      children: <Widget>[
        SizedBox(height: Adapt.px(60)),
        CusRectField(
          controller: _nameCtrl,
          hintText: "商品类别名称",
          errorText: _err,
          fromValue: _isAdd ? null : widget.category.name,
        ),
      ],
    );
  }
}

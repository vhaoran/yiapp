import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/util/file_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/6 19:09
// usage ：新增商品种类
// ------------------------------------------------------

class AddProductType extends StatefulWidget {
  AddProductType({Key key}) : super(key: key);

  @override
  _AddProductTypeState createState() => _AddProductTypeState();
}

class _AddProductTypeState extends State<AddProductType> {
  var _nameCtrl = TextEditingController(); // 商品名称
  String _err; // 错误提示信息
  File _file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "新增商品分类",
        actions: <Widget>[
          FlatButton(
            onPressed: _doSave,
            child: CusText("保存", Colors.orangeAccent, 28),
          )
        ],
      ),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  /// 保存
  void _doSave() async {
    setState(() {
      _err = _nameCtrl.text.isEmpty ? "商品名称不能为空" : null;
      if (_err == null) {
        _err = _file == null ? "未选择商品图片" : null;
      }
    });
    if (_err == null) {
      try {
        String url = await FileUtil.singleFile(_file);
        if (url != null && url.isNotEmpty) {
          var m = {"name": _nameCtrl.text.trim(), "icon": url, "sort_no": 0};
          Category res = await ApiProduct.categoryAdd(m);
          if (res != null) {
            CusToast.toast(context, text: "添加成功");
            Navigator.of(context).pop("");
          }
        }
      } catch (e) {
        Debug.logError("新增商品分类出现异常：$e");
      }
    }
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: Adapt.px(60), bottom: Adapt.px(40)),
          child: CusRectField(
            controller: _nameCtrl,
            hintText: "设置商品名称",
            errorText: _err,
          ),
        ),
        CusRaisedBtn(
          text: "${_file == null ? '选择' : '更换'}商品图片",
          onPressed: () => CusBottomSheet(
            context,
            OnFile: (val) => setState(() {
              if (val != null) {
                _file = val;
                if (_err != null) _err = null;
              }
            }),
          ),
          textColor: Colors.black,
          backgroundColor: t_gray,
        ),
        SizedBox(height: Adapt.px(20)),
        if (_file != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.file(_file, fit: BoxFit.cover, height: 300),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}

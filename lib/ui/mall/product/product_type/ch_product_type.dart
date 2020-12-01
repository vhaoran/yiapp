import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/util/file_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/6 19:13
// usage ：修改商品种类
// ------------------------------------------------------

class ChProductType extends StatefulWidget {
  final Category category;

  ChProductType({this.category, Key key}) : super(key: key);

  @override
  _ChProductTypeState createState() => _ChProductTypeState();
}

class _ChProductTypeState extends State<ChProductType> {
  var _nameCtrl = TextEditingController(); // 商品名称
  String _err; // 错误提示信息
  File _file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "修改商品分类",
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
    });
    if (_err == null) {
      String url;
      try {
        if (_file != null) {
          url = await FileUtil.singleFile(_file);
        }
        var m = {
          "id": widget.category.id,
          "M": {
            "name": _nameCtrl.text.trim(),
            "icon": url == null ? widget.category.icon : url,
            "sort_no": "0"
          },
        };
        bool ok = await ApiProduct.categoryCh(m);
        if (ok) {
          CusToast.toast(context, text: "修改成功");
          Navigator.of(context).pop("");
        }
      } catch (e) {
        Log.error("修改商品分类出现异常：$e");
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
            fromValue: widget.category.name,
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
        if (_file == null) // 显示原来的图片
          CusAvatar(url: widget.category.icon, size: 200, rate: 8),
        if (_file != null) // 如果用户选择了图片，则预览该图
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

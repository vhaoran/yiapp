import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/fn/fn_multi_files.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/8 10:25
// usage ：添加商品图片
// ------------------------------------------------------

class AddProductImages extends StatefulWidget {
  final FnAssets fnAssets;

  AddProductImages({this.fnAssets, Key key}) : super(key: key);

  @override
  _AddProductImagesState createState() => _AddProductImagesState();
}

class _AddProductImagesState extends State<AddProductImages> {
  List<Asset> _images; // 返回的选择的图片

  @override
  Widget build(BuildContext context) {
    if (_images != null) {
      Debug.log("已选多少张图片：${_images.length}");
    }
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: Adapt.px(30)),
          margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
          decoration: BoxDecoration(
              color: fif_primary, borderRadius: BorderRadius.circular(10)),
          child: _buildView(),
        ),
        if (_images != null && _images.isNotEmpty)
          ShowMultiImages(images: _images),
      ],
    );
  }

  Widget _buildView() {
    return Row(
      children: <Widget>[
        CusText("商品图片", t_yi, 30),
        Expanded(
          child: CusRectField(
            hintText: "请选择商品图片",
            autofocus: false,
            hideBorder: true,
            enable: false,
          ),
        ),
        CusRaisedBtn(
          text: "选择",
          pdVer: 0,
          pdHor: 10,
          fontSize: 28,
          textColor: Colors.black,
          backgroundColor: t_gray,
          onPressed: () async {
            if (!mounted) return;
            _images = await multiImages();
            if (widget.fnAssets != null) {
              widget.fnAssets(_images);
            }
            setState(() {});
          },
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
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
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/9 15:44
// usage ：修改商品图片
// ------------------------------------------------------

class ChProductImages extends StatefulWidget {
  final FnAssets fnAssets;
  final List<ProductImage> images;

  ChProductImages({
    this.fnAssets,
    this.images,
    Key key,
  }) : super(key: key);

  @override
  _ChProductImagesState createState() => _ChProductImagesState();
}

class _ChProductImagesState extends State<ChProductImages> {
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
        if (widget.images.isNotEmpty) ...[
          CusText("当前已有图片", t_yi, 30),
          Container(
            width: double.infinity,
            child: Wrap(
              runSpacing: 5, // 上下间隔
              spacing: 5,
              children: List.generate(
                widget.images.length,
                (i) => GestureDetector(
                  onTap: () {
                    Debug.log("当前选择的图片路径:${widget.images[i].path}");
                  },
                  child: CusAvatar(
                    url: widget.images[i].path,
                    size: (MediaQuery.of(context).size.width - 60) / 3,
                    rate: 50,
                  ),
                ),
              ),
            ),
          ),
        ],
        if (_images != null && _images.isNotEmpty) ...[
          CusText("新添加图片", t_yi, 30),
          ShowMultiImages(images: _images),
        ],
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

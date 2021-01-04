import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yiapp/cus/cus_log.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/8 14:43
// usage ：显示选择的多选图片
// ------------------------------------------------------

class ShowMultiImages extends StatefulWidget {
  final List<Asset> images; // 选择的图片

  ShowMultiImages({this.images, Key key}) : super(key: key);

  @override
  _ShowMultiImagesState createState() => _ShowMultiImagesState();
}

class _ShowMultiImagesState extends State<ShowMultiImages> {
  int _width = 0; // 图片的宽高

  @override
  Widget build(BuildContext context) {
    double res = (MediaQuery.of(context).size.width - 60) / 3;
    _width = res.floor();
    if (widget.images != null)
      return Container(
        width: double.infinity,
        child: Wrap(
          runSpacing: 5, // 上下间隔
          spacing: 5,
          children: List.generate(
            widget.images.length,
            (i) => GestureDetector(
              onTap: () {
                Log.info("当前选择的图片名称:${widget.images[i].name}");
              },
              child: AssetThumb(
                  asset: widget.images[i], width: _width, height: _width),
            ),
          ),
        ),
      );
    return SizedBox.shrink();
  }
}

/// 单独封装选择图片的功能
Future<List<Asset>> multiImages() async {
  List<Asset> l = [];
  try {
    l = await MultiImagePicker.pickImages(
      maxImages: 9,
      enableCamera: true,
      cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
      materialOptions: MaterialOptions(
        actionBarTitle: "选择图片",
        allViewTitle: "所有图片",
        textOnNothingSelected: "未选择图片",
        actionBarColor: "#302E32", // AppBar 背景色
        actionBarTitleColor: "#ffffff", // AppBar 中文字颜色
        statusBarColor: "#302E32", // AppBar 顶部颜色
        useDetailsView: false,
      ),
    );
  } catch (e) {
    Log.error("设置图片异常：$e");
  }
  if (l != null && l.isNotEmpty) {
    return l;
  }
  return [];
}

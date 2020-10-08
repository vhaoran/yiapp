import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/fn/fn_single_file.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/8 10:25
// usage ：添加商品图片
// ------------------------------------------------------

class AddProductImages extends StatefulWidget {
  AddProductImages({Key key}) : super(key: key);

  @override
  _AddProductImagesState createState() => _AddProductImagesState();
}

class _AddProductImagesState extends State<AddProductImages> {
  List<File> _files = []; // 当前选择的图片

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Adapt.px(30),
        vertical: Adapt.px(20),
      ),
      margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        child: SelectFiles(fnFiles: (List<File> files) {
          if (files == null || files.isEmpty) return;
          setState(() => _files = files);
        }),
      ),
    );
  }
}

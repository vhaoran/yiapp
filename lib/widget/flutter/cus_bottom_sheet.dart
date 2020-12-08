import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/global/cus_fn.dart';

class CusBottomSheet {
  final List<String> titles;
  final double titleSize;
  final Color titleColor;
  final Color backgroundColor;
  final List<VoidCallback> fnLists;
  FnFile OnFile;

  // 能够调起相册或者摄像头的字段
  List<String> _l = ["从相册获取", "从相册添加", "拍摄", "替换"];

  CusBottomSheet(
    BuildContext context, {
    this.titles: const ["从相册获取", "拍摄", "取消"],
    this.titleSize: 28,
    this.titleColor: Colors.black,
    this.backgroundColor: tip_bg,
    this.fnLists: const [],
    this.OnFile,
  }) {
    _showBottomSheet(context);
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: backgroundColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: _co(context),
        );
      },
    );
  }

  List<Widget> _co(context) {
    return List.generate(
      titles.length,
      (i) {
        String title = titles[i];
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: Adapt.px(titleSize),
                  color: titleColor,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                if (_l.contains(title)) {
                  _selectImage(context, type: title);
                }
                if (fnLists.isNotEmpty && fnLists[i] != null) {
                  fnLists[i]();
                }
                Navigator.pop(context);
              },
            ),
            Divider(height: 0, thickness: 1),
          ],
        );
      },
    );
  }

  Future<File> _selectImage(context, {String type}) async {
    ImageSource source =
        type.contains("拍摄") ? ImageSource.camera : ImageSource.gallery;

    final picker = ImagePicker();
    var image = await picker.getImage(source: source);
    if (image != null) {
      var file = File(image.path);
      if (file != null) {
        if (this.OnFile != null) {
          this.OnFile(file);
        }
      }
    }
    return null;
  }
}

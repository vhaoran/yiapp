import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';

class CusBottomSheet {
  final List<String> titles;
  final double titleSize;
  final Color titleColor;
  final Color backgroundColor;
  FnFile fileFn;

  CusBottomSheet(
    BuildContext context, {
    this.titles: const ["更换相册封面", "拍摄", "取消"],
    this.titleSize: 28,
    this.titleColor: Colors.black,
    this.backgroundColor: Colors.white,
    this.fileFn,
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
          children: List.generate(
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
                      if (title.contains("相册") || title.contains("拍摄")) {
                        _selectImage(context, type: title);
                      }
                      Navigator.pop(context);
                    },
                  ),
                  Divider(height: 0, thickness: 1),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<File> _selectImage(context, {String type}) async {
    ImageSource source;
    if (type.contains("相册")) {
      source = ImageSource.gallery;
    } else if (type.contains("拍摄")) {
      source = ImageSource.camera;
    }

    final picker = ImagePicker();
    var image = await picker.getImage(source: source);
    var file = File(image.path);
    if (file != null && this.fileFn != null) {
      this.fileFn(file);
    }
    return null;
    if (image != null) {
      Navigator.pop(context);
//      String key = await ApiImage.uploadQiniu(image);
//      var json = {"image_path": key};
//      try {
//        var ok = await ApiCircle.chCircleCover(json);
//        if (ok) {
//          await _fetch();
//          setState(() {});
//        }
//        print(">>>设置朋友圈封面是否成功：$ok");
//      } catch (e) {
//        print("<<<设置朋友圈封面时的错误信息是：$e");
//      }
    }
  }
}

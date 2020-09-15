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
  FnFile OnFile;

  CusBottomSheet(
    BuildContext context, {
    this.titles: const ["从相册获取", "拍摄", "取消"],
    this.titleSize: 28,
    this.titleColor: Colors.black,
    this.backgroundColor: tipBg,
    @required this.OnFile,
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
    );
  }

  Future<File> _selectImage(context, {String type}) async {
    ImageSource source =
        type.contains("相册") ? ImageSource.gallery : ImageSource.camera;

    final picker = ImagePicker();
    var image = await picker.getImage(source: source);
    var file = File(image.path);
    if (file != null) {
      if (this.OnFile != null) {
        this.OnFile(file);
      }
    }
  }
}

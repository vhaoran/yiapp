import 'dart:typed_data';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yiapp/service/api/api_image.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

class CusMultiImage extends StatefulWidget {
  CusMultiImage({Key key}) : super(key: key);

  @override
  _CusMultiImageState createState() => _CusMultiImageState();
}

class _CusMultiImageState extends State<CusMultiImage> {
  List<Asset> _images = []; // 返回的选择的图片
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "测试"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Future<void> _selectImages() async {
    List<Asset> res = [];
    String error = '';
    try {
      res = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#CECECE",
          actionBarTitleColor: "#000000",
          actionBarTitle: "选择图片",
          allViewTitle: "所有图片",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      for (var i = 0; i < res.length; i++) {
        ByteData byteData = await res[i].getByteData();
        String key =
            await ApiImage.uploadQiniuData(byteData.buffer.asUint8List());
        String url = await ApiImage.GetVisitURL(key.trim());
        print(">>>菜单栏选中的图片地址是:$url");
//        await widget.onSend(MsgImage(key: key, url: url ?? key));
      }
    } catch (e) {
      print("<<<设置图片异常：$e");
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      _images = res;
    });
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[],
    );
  }
}

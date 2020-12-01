import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/8 10:52
// usage ：选择图片的回调(带加号按钮的样式)
// ------------------------------------------------------

class SelectFiles extends StatefulWidget {
  FnFiles fnFiles;
  final int crossAxisCount; // 每行显示几张图片,默认 3 张
  final int maxCount; // 最多显示多少张图片

  SelectFiles({
    this.fnFiles,
    this.crossAxisCount: 3,
    this.maxCount: 9,
    Key key,
  }) : super(key: key);

  @override
  SelectFilesState createState() => new SelectFilesState();
}

class SelectFilesState extends State<SelectFiles> {
  List<Widget> _images = [];
  List<File> _files = [];
  Widget _showSelects; // 流式布局显示当前选择的图片

  Widget build(BuildContext context) {
    getWrapList();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: _showSelects,
    );
  }

  void getWrapList() {
    var width = (MediaQuery.of(context).size.width - 100) /
        widget.crossAxisCount; // 图片的宽高
    List wrapList = <Widget>[];
    for (var i = 0; i < _images.length; i++) {
      if (_images.length <= 9) {
        wrapList.add(
          GestureDetector(
            child: Container(
              width: width,
              height: width,
              decoration: BoxDecoration(color: t_gray),
              child: Center(child: _images[i]),
            ),
            onTap: () {
//            photoList.removeAt(i);
//            getWrapList();
            },
          ),
        );
      }
    }

    // 图片数小于指定数字或者为 0 时，显示添加按钮图片
    if (_images.length != widget.maxCount || _images.isEmpty) {
      _showAdd(wrapList, width);
    }

    _showSelects = Builder(
      builder: (context) {
        return Wrap(
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children: wrapList,
        );
      },
    );

    setState(() {
      _showSelects = _showSelects;
    });
  }

  // 图片数小于指定数字或者为 0 时，显示添加按钮图片
  void _showAdd(List<Widget> wrapList, double width) {
    wrapList.add(GestureDetector(
      child: Container(
        width: width,
        height: width,
        color: t_gray, // 添加图片背景色
        child: Center(child: Icon(Icons.add, size: 50)),
      ),
      onTap: () => CusBottomSheet(
        context,
        OnFile: (File val) {
          if (val == null) return;
          setState(() {
            _images.insert(_images.length, Image.file(val));
            _files.add(val);
            if (widget.fnFiles != null) {
              widget.fnFiles(_files); // 选择图片的回调
            }
            getWrapList();
          });
        },
      ),
    ));
  }
}

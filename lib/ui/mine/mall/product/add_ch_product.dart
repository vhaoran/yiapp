import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/6 19:27
// usage ：新增商品
// ------------------------------------------------------

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var _nameCtrl = TextEditingController(); // 商品名称
  String _err; // 错误提示信息
  File _file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "新增商品",
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: CusText("保存", Colors.orangeAccent, 28),
          )
        ],
      ),
      body: Container(),
      backgroundColor: primary,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}

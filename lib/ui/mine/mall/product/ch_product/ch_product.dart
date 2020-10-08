import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/7 16:42
// usage ：修改商品
// ------------------------------------------------------

class ChProduct extends StatefulWidget {
  final Product product;

  ChProduct({this.product, Key key}) : super(key: key);

  @override
  _ChProductState createState() => _ChProductState();
}

class _ChProductState extends State<ChProduct> {
  var _future;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "新增商品"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[],
    );
  }
}

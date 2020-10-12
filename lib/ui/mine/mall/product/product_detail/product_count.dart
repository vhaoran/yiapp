import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/12 19:12
// usage ：单个商品的购买数量
// ------------------------------------------------------

class ProductCount extends StatefulWidget {
  ProductCount({Key key}) : super(key: key);

  @override
  _ProductCountState createState() => _ProductCountState();
}

class _ProductCountState extends State<ProductCount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: fif_primary,
      padding: EdgeInsets.all(Adapt.px(20)),
      child: Row(
        children: <Widget>[
          CusText("购买数量", t_gray, 30),
          Spacer(),
          _doReduce(), // 减少数量
          _showCount(), // 显示购买数量
          _doAdd(), // 增加数量
        ],
      ),
    );
  }

  /// 显示购买数量
  Widget _showCount() {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: CusText("1", Colors.white, 28),
      ),
    );
  }

  /// 减少数量
  Widget _doReduce() {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: CusText("-", t_gray, 28),
      ),
    );
  }

  /// 增加数量
  Widget _doAdd() {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: CusText("+", t_gray, 28),
      ),
    );
  }
}

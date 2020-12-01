import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/12 19:12
// usage ：单个商品的购买数量
// ------------------------------------------------------

class ProductCount extends StatefulWidget {
  final FnInt OnChanged;
  final int count;

  ProductCount({this.OnChanged, this.count, Key key}) : super(key: key);

  @override
  _ProductCountState createState() => _ProductCountState();
}

class _ProductCountState extends State<ProductCount> {
  int _count = 1; // 购买数量

  @override
  Widget build(BuildContext context) {
    _count = widget.count;
    return Container(
      color: fif_primary,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
        width: Adapt.px(100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey),
        ),
        padding: EdgeInsets.symmetric(vertical: 5),
        child: CusText("$_count", Colors.white, 28),
      ),
    );
  }

  /// 减少数量
  Widget _doReduce() {
    return InkWell(
      onTap: () {
        _count--;
        if (_count < 1) {
          _count = 1;
          CusToast.toast(context, text: "亲，不能再减少了");
        }
        if (widget.OnChanged != null) {
          widget.OnChanged(_count);
        }
        setState(() {});
      },
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
      onTap: () {
        _count++;
        if (widget.OnChanged != null) {
          widget.OnChanged(_count);
        }
        setState(() {});
      },
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

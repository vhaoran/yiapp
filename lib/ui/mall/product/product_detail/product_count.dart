import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/12 19:12
// usage ：单个商品的购买数量
// ------------------------------------------------------

class ProductCount extends StatefulWidget {
  final FnInt onChanged;
  final int count;

  ProductCount({this.onChanged, this.count, Key key}) : super(key: key);

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
          Text("购买数量", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
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
    return Container(
      width: S.w(50),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
      ),
      constraints: BoxConstraints(minHeight: S.h(30)),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        "$_count",
        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
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
        if (widget.onChanged != null) {
          widget.onChanged(_count);
        }
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey),
        ),
        constraints: BoxConstraints(minHeight: S.h(30)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text("-", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
      ),
    );
  }

  /// 增加数量
  Widget _doAdd() {
    return InkWell(
      onTap: () {
        _count++;
        if (widget.onChanged != null) {
          widget.onChanged(_count);
        }
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey),
        ),
        constraints: BoxConstraints(minHeight: S.h(30)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text("+", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/orders/productOrder-item.dart';
import 'package:yiapp/model/orders/productOrder.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/14 17:13
// usage ：通用的订单封面
// ------------------------------------------------------

class ComOrderCover extends StatefulWidget {
  final ProductOrder order;
  final VoidCallback onTap;
  final Widget child;

  ComOrderCover({
    this.order,
    this.onTap,
    this.child,
    Key key,
  }) : super(key: key);

  @override
  _ComOrderCoverState createState() => _ComOrderCoverState();
}

class _ComOrderCoverState extends State<ComOrderCover> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...List.generate(
          widget.order.items.length,
          (i) => _coverItem(widget.order.items[i]),
        )
      ],
    );
  }

  /// 单个封面模板
  Widget _coverItem(ProductOrderItem e) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CusText("${e.name}x${e.qty}", t_gray, 30), // 商品名称
                    CusText("颜色：${e.color_code}", t_gray, 30), // 商品颜色
                    CusText("总价：￥${e.amt}", t_yi, 30), // 商品价格
                  ],
                ),
              ),
            ],
          ),
        ),
        color: fif_primary,
        shadowColor: t_gray,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }
}

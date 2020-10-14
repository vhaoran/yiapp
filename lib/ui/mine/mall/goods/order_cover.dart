import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/model/orders/productOrder-item.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/service/api/api-product-order.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/14 17:13
// usage ：通用的订单封面
// ------------------------------------------------------

class ComOrderCover extends StatefulWidget {
  final ProductOrder order;
  final FnString OnProductId; // 返回商品的id

  ComOrderCover({
    this.order,
    this.OnProductId,
    Key key,
  }) : super(key: key);

  @override
  _ComOrderCoverState createState() => _ComOrderCoverState();
}

class _ComOrderCoverState extends State<ComOrderCover> {
  List<ProductOrderItem> _l = [];
  String _id = ""; // 当前订单的 id

  @override
  void initState() {
    _l = widget.order.items;
    _id = widget.order.id;
    super.initState();
  }

  /// 确认收货
  void _doConfirm() {
    CusDialog.normal(
      context,
      title: "您是否已确认收到货?",
      onApproval: () async {
        try {
          bool ok = await ApiProductOrder.productOrderReceive(_id);
          if (ok) {
            CusToast.toast(context, text: "收货成功");
            if (widget.OnProductId != null) {
              widget.OnProductId(_id);
            }
          }
        } catch (e) {
          Debug.logError("确认收货时出现异常：$e");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        _l.length,
        (i) => _coverItem(_l[i]),
      ),
    );
  }

  /// 单个封面模板
  Widget _coverItem(ProductOrderItem e) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: <Widget>[
            CusAvatar(url: "", rate: 20, size: 100), // 商品图片，这个后台是否应该加上图片url字段
            SizedBox(width: Adapt.px(30)),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CusText("${e.name}x${e.qty}", t_primary, 30), // 商品名称
                      Spacer(),
                      CusText("总价：￥${e.amt}", t_gray, 30), // 商品价格
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(top: 28),
                    child: CusRaisedBtn(
                      text: "确认收货",
                      pdHor: 20,
                      fontSize: 26,
                      textColor: Colors.white,
                      backgroundColor: Color(0xFFCB4031),
                      onPressed: _doConfirm,
                    ),
                  ),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/service/api/api-product-order.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/14 14:51
// usage ：发货页面
// ------------------------------------------------------

class SendGoodsPage extends StatefulWidget {
  final ProductOrder order;

  SendGoodsPage({this.order, Key key}) : super(key: key);

  @override
  _SendGoodsPageState createState() => _SendGoodsPageState();
}

class _SendGoodsPageState extends State<SendGoodsPage> {
  var _billCtrl = TextEditingController(); // 订单号输入
  String _err; // 错误提示信息

  /// 发货
  void _doSend() async {
    Debug.log("id：${widget.order.id}");
    setState(() => _err = _billCtrl.text.isEmpty ? "未输入订单号" : null);
    if (_err != null) return;
    try {
      bool ok = await ApiProductOrder.productOrderDelivery(
          widget.order.id, _billCtrl.text.trim());
      if (ok) {
        CusToast.toast(context, text: "发货成功");
        Navigator.of(context).pop("");
      }
    } catch (e) {
      Debug.logError("发货出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "发货"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
            child: CusText("收货人", t_primary, 30),
          ),
          _addrCtr(), // 收货人
          Padding(
            padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
            child: CusText("填写订单号", t_primary, 30),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 40),
            child: CusRectField(
              controller: _billCtrl,
              hintText: "请输入订单号",
              errorText: _err,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
            child: CusRaisedBtn(
              text: "发货",
              backgroundColor: Colors.blueGrey,
              borderRadius: 30,
              onPressed: _doSend,
            ),
          ),
        ],
      ),
    );
  }

  /// 收货人
  Widget _addrCtr() {
    return Card(
      color: fif_primary,
      shadowColor: t_gray,
      child: Padding(
        padding: EdgeInsets.all(Adapt.px(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CusText(widget.order.contact, t_primary, 30), // 收件人
                SizedBox(width: Adapt.px(30)),
                CusText(widget.order.addr.mobile, t_primary, 30), // 手机号
              ],
            ),
            SizedBox(height: Adapt.px(10)),
            Text(
              widget.order.addr.detail, // 收货地址
              style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _billCtrl.dispose();
    super.dispose();
  }
}

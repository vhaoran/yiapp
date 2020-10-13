import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/small/cus_loading.dart';
import 'package:yiapp/model/complex/address_result.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/service/api/api-product-order.dart';
import 'package:yiapp/ui/mine/address/user_addr.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/13 14:22
// usage ：商品订单详情
// ------------------------------------------------------

class ProductOrder extends StatefulWidget {
  final Product product;
  final AddressResult firstAddr; // 所有的收货地址
  final ProductColor color;
  final String path;
  final int count;

  ProductOrder({
    this.product,
    this.firstAddr,
    this.color,
    this.path,
    this.count,
    Key key,
  }) : super(key: key);

  @override
  _ProductOrderState createState() => _ProductOrderState();
}

class _ProductOrderState extends State<ProductOrder> {
  AddressResult _addr; // 收货地址

  @override
  void initState() {
    _addr = _addr == null ? widget.firstAddr : _addr;
    super.initState();
  }

  /// 提交订单
  void _doBuy() async {
    var m = {
      "items": [
        {
          "product_id": widget.product.id_of_es,
          "name": widget.product.name,
          "color_code": widget.color.code,
          "price": widget.color.price, // 单价
          "qty": widget.count, // 购买个数
//          "amt":50 // 总价，这个我不需要传给后台
        }
      ],
    };
    try {
      var res = await ApiProductOrder.productOrderAdd(m);

      if (res != null) {
        CusToast.toast(context, text: "订单提交成功");
      }
    } catch (e) {
      Debug.logError("提交订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "确认订单"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(height: Adapt.px(10)),
                _address(
                  res: _addr,
                  isDefault: _addr.is_default == 1,
                ),
                _colorPrice(widget.color), // 商品的颜色和价格
                CusRaisedBtn(
                  onPressed: () {
                    CusLoading(context);
                    Future.delayed(Duration(milliseconds: 2000))
                        .then((value) => CusToast.toast(context, text: "提价陈宫"));
                  },
                ),
              ],
            ),
          ),
          _bottomArea(),
        ],
      ),
    );
  }

  /// 商品的颜色和价格
  Widget _colorPrice(ProductColor e) {
    return Card(
      color: fif_primary,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          children: <Widget>[
            CusAvatar(url: widget.path, rate: 20, size: 100),
            SizedBox(width: Adapt.px(Adapt.px(50))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CusText("颜色：${e.code}", t_gray, 28), // 商品颜色
                    SizedBox(width: Adapt.px(30)),
                    CusText("价格：${e.price}", t_gray, 28), // 商品价格
                  ],
                ),
                SizedBox(height: Adapt.px(30)),
                // 商品购买数量
                CusText("购买数量：${widget.count}", t_gray, 28),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 收货地址
  Widget _address({AddressResult res, bool isDefault = false}) {
    return InkWell(
      onTap: () => CusRoutes.push(
        context,
        UserAddressPage(),
      ).then((val) => setState(() => _addr = val)),
      child: Container(
        color: fif_primary,
        padding: EdgeInsets.all(Adapt.px(20)),
        child: Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.mapMarker, color: t_yi),
            SizedBox(width: Adapt.px(40)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CusText(res.contact_person, t_gray, 30), // 收件人
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
                        child: CusText(res.mobile, t_gray, 30),
                      ), // 手机号
                      if (isDefault) // 显示默认收件地址
                        CusText("默认", t_primary, 28)
                    ],
                  ),
                  Text(
                    res.detail, // 收货地址
                    style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 底部结算区域
  Widget _bottomArea() {
    return Container(
      color: fif_primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          CusText("共${widget.count}件，合计:", t_gray, 28),
          CusText("￥${widget.color.price * widget.count}", t_yi, 32),
          InkWell(
            onTap: () {},
            child: Container(
              child: CusText("提交订单", Colors.white, 28),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xFFEA6A2C),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

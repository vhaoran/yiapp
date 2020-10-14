import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/gather/net_photoview.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_count.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/12 16:30
// usage ：选择商品的颜色和价格
// ------------------------------------------------------

class ProductColorShow extends StatefulWidget {
  final Product product;
  final bool shopCart; // 是否为加入购物车
  final FnColorPrice fnColor;
  final FnString OnPath; // 图片路径
  final FnInt OnCount; // 选择商品的数量

  ProductColorShow({
    this.product,
    this.shopCart: false,
    this.fnColor,
    this.OnPath,
    this.OnCount,
    Key key,
  }) : super(key: key);

  @override
  _ProductColorShowState createState() => _ProductColorShowState();
}

class _ProductColorShowState extends State<ProductColorShow> {
  int _curSelect = -1; // 当前选择的哪一个
  int _count = 1; // 购买的数量
  List _l = []; // 图片地址列表
  ProductColor _color; // 当前选择的商品颜色和价格
  String _path; // 选择图片的路径

  @override
  void initState() {
    _l = widget.product.images.map((e) => e.toJson()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "商品可选颜色", actions: <Widget>[_doSure()]),
      body: ScrollConfiguration(
        behavior: CusBehavior(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: Adapt.px(10)),
                  ...List.generate(
                    widget.product.colors.length,
                    (i) => _productItem(widget.product.colors[i], i),
                  ),
                  ProductCount(
                    OnChanged: (val) => setState(() => _count = val),
                  ),
                ],
              ),
            ),
            widget.shopCart
                ? _comBtn("加入购物车", onPressed: () {})
                : _comBtn("立即购买", onPressed: () {})
          ],
        ),
      ),
      backgroundColor: primary,
    );
  }

  /// 单个商品的价格和颜色
  Widget _productItem(ProductColor e, int i) {
    String path = widget.product.images[i].path;
    return InkWell(
      onTap: () => setState(() {
        _curSelect = i;
        _color = e;
        _path = path;
      }),
      child: Card(
        color: fif_primary,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () => CusRoutes.push(
                  context,
                  NetPhotoView(imageList: _l, index: i),
                ),
                child: CusAvatar(url: path, rate: 20, size: 100),
              ),
              SizedBox(width: Adapt.px(Adapt.px(50))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CusText("颜色：${e.code}", t_gray, 28),
                  SizedBox(height: Adapt.px(30)),
                  CusText("价格：${e.price}", t_gray, 28),
                ],
              ),
              Spacer(),
              if (_curSelect == i)
                Image.asset(
                  'assets/images/icon_selected_20x20.png',
                  scale: Adapt.px(2.5),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 确定按钮
  Widget _doSure() {
    return FlatButton(
      onPressed: () {
        // 购买的数量不用判断，因为至少为1
        if (_color == null) {
          CusToast.toast(context, text: "未选择商品");
        } else {
          if (widget.fnColor != null) widget.fnColor(_color);
          if (widget.OnPath != null) widget.OnPath(_path);
          if (widget.OnCount != null) widget.OnCount(_count);
          Navigator.pop(context);
        }
      },
      child: CusText("确定", Colors.orangeAccent, 28),
    );
  }

  Widget _comBtn(String text, {VoidCallback onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: CusRaisedBtn(
        text: text,
        pdVer: 15,
        borderRadius: 100,
        minWidth: double.infinity,
        textColor: Colors.black,
        backgroundColor: Color(0xFFEB7E31),
        fontSize: 28,
        onPressed: onPressed,
      ),
    );
  }
}

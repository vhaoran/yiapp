import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/function/shopcart_func.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/gather/net_photoview.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/model/orders/cus_order_data.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_count.dart';
import 'product_order.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/15 11:08
// usage ：选择商品的颜色和价格
// ------------------------------------------------------

class ProductColorShow extends StatefulWidget {
  final Product product;
  final bool shopCart; // 是否为加入购物车

  ProductColorShow({this.product, this.shopCart: false, Key key})
      : super(key: key);

  @override
  _ProductColorShowState createState() => _ProductColorShowState();
}

class _ProductColorShowState extends State<ProductColorShow> {
  int _curSelect = -1; // 当前选择的哪一个
  int _count = 1; // 购买的数量
  List _l = []; // 图片地址列表,用于滑动查看图片
  ProductColor _color; // 当前选择的商品颜色和价格
  String _path; // 选择图片的url
  SingleShopData _order; // 当前选择的单个订单详情
  AllShopData _allShop; // 所有订单详情

  @override
  void initState() {
    _l = widget.product.images.map((e) => e.toJson()).toList();
    super.initState();
  }

  /// 立即购买
  void _doBuyNow() async {
    _allShop = AllShopData(shops: [_order]);
    CusRoutes.push(
      context,
      ProductOrderPage(allShop: _allShop),
    ).then((val) => {if (val != null) Navigator.pop(context)});
  }

  /// 添加进购物车
  void _doAddShopCart() async {
    String res = await ShopKV.load();
    _allShop = res == null
        ? AllShopData(shops: [_order]) // 第一次添加
        : await ShopKV.add(res, _order); // 后续添加
    bool ok = await ShopKV.refresh(_allShop);
    if (ok) {
      CusToast.toast(context, text: "添加成功，在购物车等亲~", showChild: true);
      _clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "商品可选颜色"),
      body: _co(),
      backgroundColor: primary,
    );
  }

  Widget _co() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: ListView(
              children: <Widget>[
                SizedBox(height: Adapt.px(10)),
                // 商品的图片,价格和颜色
                ...List.generate(
                  widget.product.colors.length,
                  (i) => _productItem(widget.product.colors[i], i),
                ),
                // 购买数量
                ProductCount(
                  count: _count,
                  OnChanged: (val) => setState(() => _count = val),
                ),
              ],
            ),
          ),
        ),
        // 加入购物车和立即购买
        widget.shopCart
            ? _bottomBtn("加入购物车", onPressed: _doAddShopCart)
            : _bottomBtn("立即购买", onPressed: _doBuyNow),
      ],
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
              if (_curSelect == i) // 显示已选择
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

  Widget _bottomBtn(String text, {VoidCallback onPressed}) {
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
        onPressed: () {
          // 购买的数量不用判断，因为至少为1
          if (_color == null) {
            CusToast.toast(context, text: "未选择商品");
            return;
          }
          _order = SingleShopData(
            product: widget.product,
            color: _color,
            path: _path,
            count: _count,
          );
          onPressed();
        },
      ),
    );
  }

  /// 清空数据
  void _clear() {
    setState(() {
      _curSelect = -1;
      _count = 1;
      _color = _path = _order = null;
    });
  }
}

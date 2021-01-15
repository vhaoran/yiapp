import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/temp/shopcart_func.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/gather/net_photoview.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/model/complex/cus_order_data.dart';
import 'package:yiapp/ui/mall/product/product_detail/product_count.dart';
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
  List _urls = []; // 图片地址列表,用于滑动查看图片
  String _path; // 选择图片的url
  Map<String, ProductColor> _select = {}; // 当前选择的商品颜色和价格
  SingleShopData _order; // 当前选择的单个订单详情
  AllShopData _allShop; // 所有订单详情

  @override
  void initState() {
    _urls = widget.product.images.map((e) => e.toJson()).toList();
    super.initState();
  }

  /// 立即购买
  void _doBuyNow() async {
    _allShop = AllShopData(shops: [_order]);
    CusRoute.push(
      context,
      ProductOrderPage(allShop: _allShop, isShop: false),
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
      appBar: CusAppBar(text: "选择商品"),
      body: _co(),
      backgroundColor: primary,
    );
  }

  Widget _co() {
    Product p = widget.product;
    // 这里如果颜色和图片保持一致的话，这个判断就不需要了
    return Column(
      children: <Widget>[
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: ListView(
              children: <Widget>[
                SizedBox(height: S.h(5)),
                // 商品的图片,价格和颜色
                ...List.generate(
                  p.colors.length <= p.images.length
                      ? p.colors.length
                      : p.images.length,
                  (i) => _productItem(p.colors[i], i),
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
        SizedBox(height: S.h(5)),
      ],
    );
  }

  /// 单个商品的价格和颜色
  Widget _productItem(ProductColor e, int i) {
    if (i > widget.product.images.length) {
      Log.error("i > product.images.length");
      i = widget.product.images.length;
    }
    String path = widget.product.images[i]?.path ?? "";
    return InkWell(
      onTap: () => setState(() {
        _curSelect = i;
        _path = path;
        print(">>>颜色：${e.code}");
        if (_select.isEmpty) {
          _select.addAll({"$i": e});
        } else {
          if (_select.containsKey("$i")) {
            _select.remove("$i");
          } else {
            _select.clear();
            _select.addAll({"$i": e});
          }
        }
      }),
      child: Card(
        color: fif_primary,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () => CusRoute.push(
                  context,
                  NetPhotoView(imageList: _urls, index: i),
                ),
                child: CusAvatar(url: path, rate: 20, size: 100),
              ),
              SizedBox(width: S.w(20)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "颜色：${e.code}",
                    style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                  ),
                  SizedBox(height: S.h(15)),
                  Text(
                    "价格：${e.price}",
                    style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                  ),
                ],
              ),
              Spacer(),
              if (_select.containsKey("$i")) // 显示已选择
                Image.asset(
                  'assets/images/icon_selected_20x20.png',
                  scale: 1.4,
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
      child: CusRaisedButton(
        child: Text(text, style: TextStyle(fontSize: S.sp(14))),
        padding:
            EdgeInsets.symmetric(horizontal: S.screenW() / 4, vertical: S.h(5)),
        borderRadius: 50,
        onPressed: () {
          // 购买的数量不用判断，因为至少为1
          if (_select.isEmpty) {
            CusToast.toast(context, text: "未选择商品");
            return;
          }
          _order = SingleShopData(
            product: widget.product,
            color: _select['$_curSelect'],
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
      _path = _order = null;
      _select.clear();
    });
  }
}

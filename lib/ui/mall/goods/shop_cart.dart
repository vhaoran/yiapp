import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/temp/shopcart_func.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/model/complex/cus_order_data.dart';
import 'package:yiapp/ui/mall/product/product_detail/product_details.dart';
import 'package:yiapp/ui/mall/product/product_detail/product_order.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/15 11:18
// usage ：用户购物车页面
// ------------------------------------------------------

class ShopCartPage extends StatefulWidget {
  ShopCartPage({Key key}) : super(key: key);

  @override
  _ShopCartPageState createState() => _ShopCartPageState();
}

class _ShopCartPageState extends State<ShopCartPage> {
  var _future;
  List<SingleShopData> _l = []; // 购物车数据
  var _m = Map<String, SingleShopData>(); // 选中商品
  AllShopData _allShop; // 所有的订单详情
  bool _selectAll = false; // 是否全选

  @override
  void initState() {
    _future = _localData();
    super.initState();
  }

  /// 获取本地购物车数据
  _localData() async {
    String res = await ShopKV.load();
    if (res != null) {
      AllShopData r = await ShopKV.from(res);
      _l = r.shops;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "购物车",
        actions: <Widget>[
          FlatButton(
            onPressed: _clearShopCart, // 清空购物车
            child: Text(
              "清空购物车",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          )
        ],
      ),
      body: _buildFb(),
      backgroundColor: primary,
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(
            child: Text(
              "购物车竟然是空的~",
              style: TextStyle(color: t_gray, fontSize: S.sp(16)),
            ),
          );
        }
        return Column(
          children: <Widget>[
            Expanded(
              child: ScrollConfiguration(
                behavior: CusBehavior(),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    ...List.generate(_l.length, (i) => _shopItem(_l[i], i)),
                  ],
                ),
              ),
            ),
            _bottomArea(), // 底部结算区域
          ],
        );
      },
    );
  }

  /// 底部结算区域
  Widget _bottomArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: fif_primary,
      child: Row(
        children: <Widget>[
          _checkItem(
              checked: _selectAll, // 全选/取消全选
              onTap: () {
                _selectAll = !_selectAll;
                if (_selectAll) {
                  for (var i = 0; i < _l.length; i++) {
                    _m.addAll({"$i": _l[i]});
                  }
                } else {
                  _m.clear();
                }
                _allShop = AllShopData(shops: _m.values.toList());
                if (_allShop.shops.isEmpty) _allShop = null;
                setState(() {});
              }),
          CusText("全选", t_gray, 28),
          SizedBox(width: Adapt.px(30)),
          if (_m.isNotEmpty) // 删除购物车商品
            InkWell(
              onTap: () async {
                CusDialog.err(context,
                    title: "确认将这${_allShop.shops.length}个宝贝删除吗",
                    textCancel: "我再想想", onApproval: () async {
                  AllShopData data = await ShopKV.remove(_allShop);
                  bool ok = await ShopKV.refresh(data);
                  if (ok) {
                    _refresh();
                    CusToast.toast(context, text: "移除成功");
                  }
                });
              },
              child: CusText("删除", t_yi, 28),
            ),
          Spacer(),
          CusText("合计:", t_gray, 28),
          CusText("￥${_allShop == null ? 0 : _allShop.amt}", t_yi, 28),
          SizedBox(width: Adapt.px(30)),
          CusBtn(
            text: "结算${_allShop == null ? '' : '(${_allShop.counts})'}",
            pdHor: 40,
            borderRadius: 100,
            backgroundColor: Color(0xFFEA6F30),
            onPressed: () {
              if (_m.isEmpty) {
                CusToast.toast(context, text: "至少选择一个商品");
              } else {
                CusRoute.push(
                  context,
                  ProductOrderPage(allShop: _allShop, isShop: true),
                ).then((val) {
                  if (val != null) _refresh();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _shopItem(SingleShopData e, int i) {
    bool checked = _m.containsKey("$i");
    return InkWell(
      onTap: () => CusRoute.push(
        context,
        ProductDetails(id_of_es: e.product.id_of_es),
      ).then((val) {
        if (val != null) _refresh();
      }),
      child: Card(
        color: fif_primary,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              _checkItem(
                checked: checked,
                onTap: () {
                  // 已经选中则取消，未选中则添加
                  checked ? _m.remove("$i") : _m.addAll({"$i": e});
                  // 点击时如果处于全选状态，则设置false
                  if (_selectAll) _selectAll = false;
                  // 当手动点选的和购物车长度一样时，自动开启全选
                  if (_m.length == _l.length) _selectAll = true;
                  _allShop = AllShopData(shops: _m.values.toList());
                  if (_allShop.shops.isEmpty) _allShop = null;
                  setState(() {});
                },
              ), //  已选中商品的标识
              CusAvatar(url: e.path, rate: 20, size: 100),
              SizedBox(width: Adapt.px(Adapt.px(50))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CusText("颜色：${e.color.code}", t_gray, 28),
                  SizedBox(height: Adapt.px(30)),
                  Row(
                    children: <Widget>[
                      CusText("价格：${e.color.price}", t_yi, 28),
                      SizedBox(width: Adapt.px(60)),
                      CusText("数量：${e.count}", t_gray, 28),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 是否选中的组件
  Widget _checkItem({bool checked, VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: checked ? Color(0xFFEA742E) : Colors.grey,
        ),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: checked
            ? Icon(FontAwesomeIcons.check, size: 12, color: Colors.white)
            : null,
      ),
    );
  }

  /// 清空购物车
  void _clearShopCart() async {
    // 如果购物车是空的，则不做任何操作
    if (await ShopKV.load() == null) return;
    CusDialog.err(context, title: "确定清空购物车吗?", onApproval: () async {
      await ShopKV.clear();
      _m.clear();
      _l.clear();
      await _localData();
      setState(() {});
      CusToast.toast(context, text: "购物车已清空~");
    });
  }

  /// 刷新数据
  void _refresh() async {
    _l.clear();
    _m.clear();
    _allShop = null;
    _selectAll = false;
    await _localData();
    setState(() {});
  }
}

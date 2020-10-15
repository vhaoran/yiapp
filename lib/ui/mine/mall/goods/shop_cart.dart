import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/model/orders/cus_order_data.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/mine/mall/product/product_detail/product_details.dart';

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
  List<SingleShopData> _l = []; // 购物车数据
  var _future;
  List<String> _tl = [];

  @override
  void initState() {
    _future = _localData();
    super.initState();
  }

  /// 获取本地购物车数据
  _localData() async {
    String res = await KV.getStr(kv_shop);
    if (res != null) {
      AllShopData r = AllShopData.fromJson(json.decode(res));
      _l = r.shops;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(child: CusText("购物车竟然是空的~", t_gray, 30));
        }
        return Scaffold(
          appBar: CusAppBar(
            text: "购物车(${_l.length})",
            actions: <Widget>[
              FlatButton(
                onPressed: () {},
                child: CusText("管理", t_gray, 28),
              )
            ],
          ),
          body: _lv(),
          backgroundColor: primary,
        );
      },
    );
  }

  Widget _lv() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                ...List.generate(
                  _l.length,
                  (i) => _shopItem(_l[i], i),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          child: Row(
            children: <Widget>[
              Spacer(),
              CusText("合计", t_gray, 28),
              CusRaisedBtn(
                text: "结算",
                pdHor: 40,
                borderRadius: 100,
                backgroundColor: Color(0xFFEA6F30),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shopItem(SingleShopData e, int i) {
    bool check = _tl.contains(e.product.id_of_es + e.color.code);
    return InkWell(
      onTap: () {
        Debug.log("点了第几个：${i + 1}");
        CusRoutes.push(
          context,
          ProductDetails(id_of_es: e.product.id_of_es),
        ).then((val) {
          if (val != null) _refresh();
        });
      },
      child: Card(
        color: fif_primary,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (_tl.contains(e.product.id_of_es + e.color.code)) {
                    _tl.remove(e.product.id_of_es + e.color.code);
                  } else {
                    _tl.add(e.product.id_of_es + e.color.code);
                  }
                  Debug.log("购物详情：${e.color.toJson()}");
                  setState(() {});
                },
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: check ? Color(0xFFEA742E) : Colors.grey,
                  ),
                  margin: EdgeInsets.only(right: 15),
                  child: check
                      ? Icon(FontAwesomeIcons.check,
                          size: 12, color: Colors.white)
                      : Container(),
                ),
              ),
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
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  /// 刷新数据
  void _refresh() async {
    _l.clear();
    await _localData();
    setState(() {});
  }
}

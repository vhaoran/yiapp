import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-product-order.dart';
import 'package:yiapp/ui/mine/mall/goods/send_good_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/14 14:09
// usage ：管理员查看待发货记录
// ------------------------------------------------------

class AdminSendGoodsPage extends StatefulWidget {
  AdminSendGoodsPage({Key key}) : super(key: key);

  @override
  _AdminSendGoodsPageState createState() => _AdminSendGoodsPageState();
}

class _AdminSendGoodsPageState extends State<AdminSendGoodsPage> {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<ProductOrder> _l = []; // 待发货订单列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询待发货订单
  _fetch() async {
    if (_pageNo * _rows_per_page > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rows_per_page,
      "where": {"stat": 1},
    };
    try {
      PageBean pb = await ApiProductOrder.bOProductOrderPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as ProductOrder).toList();
      Debug.log("总的待发货订单个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Debug.log("当前已查询待发货订单多少条：${_l.length}");
    } catch (e) {
      Debug.logError("分页查询待发货订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "待发货订单"),
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
          return Center(child: CusText("暂没有待发货订单", t_gray, 28));
        }
        return EasyRefresh(
          header: CusHeader(),
          footer: CusFooter(),
          child: ListView(
            children: <Widget>[
              ...List.generate(
                _l.length,
                (i) => _goodsItem(_l[i], i + 1),
              ),
            ],
          ),
          onLoad: () async {
            await _fetch();
            setState(() {});
          },
          onRefresh: () async {
            await _refresh();
          },
        );
      },
    );
  }

  Widget _goodsItem(ProductOrder e, int i) {
    return InkWell(
      onTap: () => CusRoutes.push(context, SendGoodsPage(order: e)).then((val) {
        if (val != null) _refresh();
      }),
      child: Card(
        color: fif_primary,
        shadowColor: t_gray,
        child: Padding(
          padding: EdgeInsets.all(Adapt.px(25)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CusText(e.contact, t_primary, 30), // 收件人
                  SizedBox(width: Adapt.px(30)),
                  CusText(e.addr.mobile, t_primary, 30), // 手机号
                  Spacer(),
                  CusText("$i", t_primary, 30), // 序号
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  e.addr.detail, // 收货地址
                  style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              ...e.items.map(
                (e) => Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CusText(e.name, t_gray, 30), // 商        品名称
                        SizedBox(width: Adapt.px(30)),
                        CusText("${e.color_code}x${e.qty}", t_gray, 30), // 商品颜色
                        SizedBox(width: Adapt.px(30)),
                        CusText("总价：${e.amt}", t_gray, 30), // 商品总价
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 刷新数据
  void _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }
}

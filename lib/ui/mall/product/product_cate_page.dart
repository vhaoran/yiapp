import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/model/bo/broker_product_res.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/ui/mall/product/product_detail/product_details.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/21 下午5:50
// usage ：根据 cate_id，查询商品分类中的商品
// ------------------------------------------------------

class ProductCatePage extends StatefulWidget {
  final int cate_id;

  ProductCatePage({this.cate_id, Key key}) : super(key: key);

  @override
  _ProductCatePageState createState() => _ProductCatePageState();
}

class _ProductCatePageState extends State<ProductCatePage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _page_no = 0;
  int _rows_count = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<BrokerProductRes> _l = []; // 商品列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询运营商商品分类中的商品
  _fetch() async {
    String str = "商品分类id为 ${widget.cate_id} 的商品总个数";
    if (_page_no * _rows_per_page > _rows_count) return;
    _page_no++;
    var m = {
      "cate_id": widget.cate_id,
      "page_no": _page_no,
      "rows_per_page": _rows_per_page
    };
    try {
      PageBean pb = await ApiBo.brokerProductUserPage(m);
      if (_rows_count == 0) _rows_count = pb.rowsCount;
      var l = pb.data.map((e) => e as BrokerProductRes).toList();
      Log.info("$str：$_rows_count");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Log.info("当前已查询$str：${_l.length}");
    } catch (e) {
      Log.error("分页查询$str出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(
              child: Text(
            "暂无商品",
            style: TextStyle(color: t_gray, fontSize: S.sp(18)),
          ));
        }
        return _productShow();
      },
    );
  }

  /// 展示商品的图片，名字，价格
  Widget _productShow() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: EasyRefresh(
          header: CusHeader(),
          footer: CusFooter(),
          onLoad: () async => await _fetch(),
          onRefresh: () async => await _refresh(),
          child: ListView(
            children: <Widget>[
              SizedBox(height: S.h(10)),
              Wrap(
                children: <Widget>[
                  ..._l.map(
                    (e) => Container(
                      width: S.screenW() / 2,
                      child: Card(child: _productInfo(e)),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  /// 查看商品详情
  Widget _productInfo(BrokerProductRes e) {
    return InkWell(
      onTap: () => CusRoute.push(context, ProductDetails(id_of_es: e.id_of_es)),
      child: Column(
        children: <Widget>[
          // 商品主图片
          CusAvatar(url: e.image_main, rate: 10, size: S.screenW() / 2),
          Container(
            color: CusColors.systemGrey6(context),
            width: S.screenW() / 2,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: S.w(5)),
            child: Text(
              "${e.name}  ￥${e.colors.first.price}", // 商品名称,价格
              style: TextStyle(color: Colors.black, fontSize: S.sp(16)),
            ),
          )
        ],
      ),
    );
  }

  /// 刷新数据
  Future<void> _refresh() async {
    _page_no = _rows_count = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/model/bo/broker_product_res.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/ui/mall/product/product_detail/product_details.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/21 下午5:50
// usage ：商品分类中对应的商品
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
  List<BrokerProductRes> _l = []; // 列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询运营商商品分类中的商品
  _fetch() async {
    String str = "分类id为 ${widget.cate_id} 的商品总个数";
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
      Log.info("当前已查询$str个数：${_l.length}");
    } catch (e) {
      Log.error("分页查询$str出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildFb();
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        return ScrollConfiguration(
          behavior: CusBehavior(),
          child: EasyRefresh(
              header: CusHeader(),
              footer: CusFooter(),
              onLoad: () async => await _fetch(),
              onRefresh: () async => await _refresh(),
              child: ListView(
                children: <Widget>[
                  if (_l.isEmpty)
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 200),
                      child: CusText("暂无相关商品", t_gray, 32),
                    ),
                  SizedBox(height: 10),
                  Wrap(
                    children: <Widget>[
                      ..._l.map(
                        (e) => Container(
                          width: Adapt.screenW() / 2,
                          child: Card(child: _jump(e)),
                        ),
                      )
                    ],
                  )
                ],
              )),
        );
      },
    );
  }

  Widget _jump(BrokerProductRes e) {
    return InkWell(
      onTap: () => CusRoute.push(
        context,
        ProductDetails(id_of_es: e.id_of_es),
      ),
      child: Column(
        children: <Widget>[
          // 商品主图片
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(10)),
            child: CusAvatar(
                url: e.image_main, rate: 10, size: Adapt.screenW() / 2),
          ),
          Container(
            color: CusColors.systemGrey6(context),
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // 商品名称
                CusText("${e.name}", Colors.black, 30),
                // 商品价格
                CusText("￥${e.colors.first.price}", t_yi, 32),
              ],
            ),
          ),
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

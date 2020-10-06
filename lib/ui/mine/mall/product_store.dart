import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'product/add_ch_product.dart';
import 'product/product_details.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/5 09:57
// usage ：商城(展示所有的商品)
// ------------------------------------------------------

class ProductStore extends StatefulWidget {
  ProductStore({Key key}) : super(key: key);

  @override
  _ProductStoreState createState() => _ProductStoreState();
}

class _ProductStoreState extends State<ProductStore> {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _pagesCount = 10; // 默认每页查询个数
  List<Product> _l = []; // 商品列表
  bool _loaded = false; //  是否已全部加载
  var _easyCtrl = EasyRefreshController();

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询商品
  _fetch() async {
    if (_pageNo * _pagesCount > _rowsCount) return;
    _pageNo++;
    var m = {"page_no": _pageNo, "rows_per_page": _pagesCount};

    try {
      PageBean pb = await ApiProduct.productPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      Debug.log("总的商品个数：$_rowsCount");
      var l = pb.data.map((e) => e as Product).toList();
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere(
          (e) => src.id_of_es == e.id_of_es,
          orElse: () => null,
        );
        if (dst == null) _l.add(src);
      });
      Debug.log("当前已查询商品个数：${_l.length}");
    } catch (e) {
      Debug.logError("分页查询商品出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "商品", actions: <Widget>[
        FlatButton(
          onPressed: () => CusRoutes.push(context, AddProduct()).then((val) {
            if (val != null) _refresh();
          }),
          child: CusText("新增", Colors.orangeAccent, 28),
        ),
      ]),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
            return Center(child: CircularProgressIndicator());
          }
          if (_l.isEmpty) {
            return Center(child: CusText("暂时没有商品", t_gray, 28));
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: EasyRefresh(
        controller: _easyCtrl,
        header: CusHeader(),
        footer: CusFooter(),
        onLoad: () async {
          _easyCtrl.finishLoad(noMore: _pageNo * _pagesCount > _rowsCount);
          await _refresh();
        },
        onRefresh: () async {
          _l.clear();
          _pageNo = _rowsCount = 0;
          await _refresh();
        },
        child: ListView(
          children: <Widget>[
            SizedBox(height: Adapt.px(15)),
            GridView.count(
              shrinkWrap: true,
              // 解决 GridView 滑动父级 Listview 无法滑动
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: List.generate(
                _l.length,
                (i) => _productCover(_l[i]),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 商品封面
  Widget _productCover(Product product) {
    return InkWell(
      onTap: () => CusRoutes.push(context, ProductDetails(product: product)),
      child: Container(
        color: fif_primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CusAvatar(url: product.image_main, rate: 8, size: 120), // 商品主图片
            SizedBox(height: Adapt.px(5)),
            CusText(
              "${product.name} (${product.cate_name}类)", // 商品名称、分类
              t_gray,
              30,
            ), // 商品名称
            CusText("￥${product.colors.first.price}", t_yi, 32), // 商品价格
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    await _fetch();
    setState(() {});
  }

  @override
  void dispose() {
    _easyCtrl.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'product_details.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/5 09:57
// usage ：商品管理
// ------------------------------------------------------

class ProductManagement extends StatefulWidget {
  ProductManagement({Key key}) : super(key: key);

  @override
  _ProductManagementState createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _count = 20; // 默认每页查询个数
  List<Product> _l = []; // 商品列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询悬赏帖
  _fetch() async {
    if (_pageNo * _count > _rowsCount) return;
    _pageNo++;
    var m = {"page_no": _pageNo, "rows_per_page": _count};

    try {
      PageBean pb = await ApiProduct.productPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as Product).toList();
      Debug.log("总的商品个数：$_rowsCount");
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
      appBar: CusAppBar(text: "商品"),
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
    return EasyRefresh(
      child: ListView(
        children: <Widget>[
          SizedBox(height: Adapt.px(15)),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            children: List.generate(
              _l.length,
              (i) => _productCover(_l[i]),
            ),
          )
        ],
      ),
      onLoad: () async {
        await _fetch();
        setState(() {});
      },
    );
  }

  /// 商品封面
  Widget _productCover(Product product) {
    return InkWell(
      onTap: () => CusRoutes.push(context, ProductDetails(product: product)),
      child: Container(
        color: fif_primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CusAvatar(url: product.image_main, rate: 8), // 商品主图片
            SizedBox(height: Adapt.px(5)),
            CusText(
              "${product.name} (${product.cate_name}类)", // 商品名称、分类
              t_gray,
              26,
            ), // 商品名称
            CusText("￥${product.colors.first.price}", t_yi, 28), // 商品价格
          ],
        ),
      ),
    );
  }
}

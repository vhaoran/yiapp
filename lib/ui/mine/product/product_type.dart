import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/service/api/api-product.dart';
import 'package:yiapp/ui/mine/product/add_ch_product_type.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/5 14:10
// usage ：商品分类
// ------------------------------------------------------

class ProductType extends StatefulWidget {
  ProductType({Key key}) : super(key: key);

  @override
  _ProductTypeState createState() => _ProductTypeState();
}

class _ProductTypeState extends State<ProductType> {
  var _future;
  List<Category> _l = []; // 商品种类列表
//  final _pops = [""];

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      List<Category> res = await ApiProduct.categoryList();
      if (res != null) _l = res;
    } catch (e) {
      Debug.logError("获取商品分类出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "商品分类",
        actions: <Widget>[
          FlatButton(
            onPressed: () => CusRoutes.push(context, AddChProductType()),
            child: CusText("新增", Colors.orangeAccent, 28),
          ),
        ],
      ),
      body: _bodyCtr(),
      backgroundColor: primary,
    );
  }

  Widget _bodyCtr() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(child: CusText("暂无分类", t_gray, 30));
        }
        return ScrollConfiguration(
          behavior: CusBehavior(),
          child: ListView(
            children: <Widget>[
              SizedBox(height: Adapt.px(15)),
//              Wrap(
//                alignment: WrapAlignment.center,
//                children: <Widget>[
//                  ..._l.sublist(0, 2).toList().map((e) => _proType(e)),
//                  ..._l.sublist(2, 4).toList().map((e) => _proType(e)),
////                  ..._l.map((e) => _proType(e)),
//                ],
//              ),
//              ..._l.map((e) => _proType(e)),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                children: <Widget>[..._l.map((e) => _proType(e))],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _proType(Category e) {
    double h = 60;
    return Card(
      child: Container(
        color: fif_primary,
        child: Column(
          children: <Widget>[
            CusAvatar(url: e.icon, rate: 8), // 商品图片
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CusText("${e.name}", t_gray, 30), // 商品类别
                PopupMenuButton<String>(
                  color: t_gray,
                  offset: Offset(0, 40),
                  onSelected: (val) {
                    Debug.log("选择了$val");
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  icon: Icon(Icons.more_horiz, color: Colors.grey),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: "修改",
                        child: CusText("修改", Colors.black, 28),
                        height: Adapt.px(h),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: "删除",
                        child: CusText("删除", Colors.red, 28),
                        height: Adapt.px(h),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: "取消",
                        child: CusText("取消", Colors.black, 28),
                        height: Adapt.px(h),
                      ),
                    ];
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  /// 移除商品分类
  void _doCategoryRm(Category e) async {
    try {
      bool ok = await ApiProduct.categoryRm(e.id);
      if (ok) {
        CusToast.toast(context, text: "移除成功");
        await _refresh();
      }
    } catch (e) {
      Debug.logError("移除商品出现异常：$e");
    }
  }

  void _refresh() async {
    await _fetch();
    setState(() {});
  }
}

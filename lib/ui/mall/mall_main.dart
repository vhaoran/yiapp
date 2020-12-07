import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/model/bo/broker_cate_res.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/ui/mall/product/product_cate_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/5 09:57
// usage ：商城
// ------------------------------------------------------

class MallPage extends StatefulWidget {
  MallPage({Key key}) : super(key: key);

  @override
  _MallPageState createState() => _MallPageState();
}

class _MallPageState extends State<MallPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  List<BrokerCateRes> _tabs = []; // 运营商商品分类数组

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取运营商商品分类
  _fetch() async {
    try {
      var res = await ApiBo.brokerCateList();
      if (res != null) {
        Log.info("运营商商品分类个数:${res.length}");
        _tabs = res;
      }
    } catch (e) {
      Log.error("获取运营商商品分类出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CusAppBar(text: "商城", showLeading: false),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (_tabs.isEmpty)
            return Center(
              child: Text(
                "运营商暂未添加商品",
                style: TextStyle(color: t_gray, fontSize: S.sp(16)),
              ),
            );
          return _productBody();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _productBody() {
    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: S.h(3)),
          TabBar(
            indicatorWeight: S.w(3),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: t_primary,
            labelPadding:
                EdgeInsets.only(bottom: S.h(6), left: S.w(8), right: S.w(8)),
            labelColor: t_primary,
            unselectedLabelColor: t_gray,
            isScrollable: true,
            tabs: List.generate(
              _tabs.length,
              (i) => Text(
                _tabs[i].cate_name,
                style: TextStyle(color: t_gray, fontSize: S.sp(16)),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: List.generate(
                _tabs.length,
                (i) => ProductCatePage(cate_id: _tabs[i].cate_id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

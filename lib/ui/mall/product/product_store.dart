import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
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

  // 获取运营商商品分类
  _fetch() async {
    try {
      var res = await ApiBo.brokerCateList();
      if (res != null) {
        Debug.log("res.length:${res.length}");
        _tabs = res;
      }
    } catch (e) {
      Debug.logError("获取运营商商品分类出现异常：$e");
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
        return _lv();
      },
    );
  }

  Widget _lv() {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: "商城", showLeading: false),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_tabs.isEmpty)
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 200),
                child: CusText("运营商暂未添加商品", t_gray, 32),
              ),
            if (_tabs.isNotEmpty) ...[
              TabBar(
                indicatorWeight: Adapt.px(6),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: t_primary,
                labelPadding: EdgeInsets.all(Adapt.px(8)),
                labelColor: t_primary,
                unselectedLabelColor: t_gray,
                tabs: List.generate(
                  _tabs.length,
                  (i) => CusText(_tabs[i].cate_name, t_gray, 28),
                ),
              ),
              SizedBox(height: Adapt.px(15)),
              Expanded(
                child: TabBarView(
                  children: [
                    ..._tabs.map((e) => ProductCatePage(cate_id: e.cate_id)),
                  ],
                ),
              ),
            ],
          ],
        ),
        backgroundColor: primary,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

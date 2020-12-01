import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import '../../widget/master/master_list.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 19:33
// usage ：底部导航栏 - 大师页面
// ------------------------------------------------------

class MasterListPage extends StatefulWidget {
  MasterListPage({Key key}) : super(key: key);
  @override
  _MasterListPageState createState() => _MasterListPageState();
}

class _MasterListPageState extends State<MasterListPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final List<String> _tabs = ["推荐榜", "好评榜", "资深榜", "订单榜"];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(title: _searchBar(), showLeading: false),
        body: _co(),
        backgroundColor: primary,
      ),
    );
  }

  Widget _co() {
    return Column(
      children: <Widget>[
        Container(
          color: ter_primary,
          child: TabBar(
            indicatorWeight: Adapt.px(6),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: t_primary,
            labelPadding: EdgeInsets.all(Adapt.px(8)),
            labelColor: t_primary,
            unselectedLabelColor: t_gray,
            tabs: List.generate(
              _tabs.length,
              (index) => Text(
                _tabs[index],
                style: TextStyle(fontSize: Adapt.px(28)),
              ),
            ),
          ),
        ),
        SizedBox(height: Adapt.px(8)),
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: TabBarView(
              children: List.generate(
                _tabs.length,
                (index) => MasterList(),
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 搜索框
  Widget _searchBar() {
    double border = 10;
    return Container(
      height: 46 - border,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(border),
        color: fou_primary,
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "搜索",
          hintStyle: TextStyle(color: t_primary),
          prefixIcon: Image.asset("assets/images/b.png"),
          contentPadding: EdgeInsets.only(left: Adapt.px(40)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(border),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: t_primary, width: 1),
            borderRadius: BorderRadius.circular(border),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

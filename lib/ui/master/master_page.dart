import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_double.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-master.dart';
import '../../complex/widgets/master/master_list.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 19:33
// usage ：底部导航栏 - 大师页面
// ------------------------------------------------------

class MasterPage extends StatefulWidget {
  MasterPage({Key key}) : super(key: key);
  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final List<String> _tabs = ["推荐榜", "好评榜", "资深榜", "订单榜"];
  final List<MasterInfo> _l = [];
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _count = 20; // 默认每页查询个数
  var _future;

  @override
  void initState() {
    Debug.log("进了大师页面");
//    _future = _fetch(); // 暂时先注释
    super.initState();
  }

  /// 分页获取数据
  _fetch() async {
    if (_pageNo * _count > _rowsCount) return; // 默认每页查询50条
    _pageNo++;
    var m = {"page_no": _pageNo, "rows_per_page": _count};
    try {
      PageBean pb = await ApiMaster.masterInfoPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as MasterInfo).toList();
      Debug.log("总的大师个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Debug.log("当前已查询多少条数据：${_tabs.length}");
    } catch (e) {
      Debug.logError("分页查询大师信息出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(title: _searchBar(), showLeading: false),
        body: _lv(),
        backgroundColor: primary,
      ),
    );
  }

  Widget _lv() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 60,
          color: Colors.grey,
          child: Text("待做区域", style: TextStyle(fontSize: 18)),
        ),
        TabBar(
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
        SizedBox(height: Adapt.px(8)),
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: TabBarView(
              children: List.generate(
                _tabs.length,
                (index) => MasterList(l: 15),
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
      height: appBarH - border,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(border),
        color: fou_primary,
      ),
      child: TextField(
        keyboardType: TextInputType.text,
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

  // 重置数据
  void _reset() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

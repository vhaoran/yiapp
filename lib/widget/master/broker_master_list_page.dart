import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bo/broker_master_res.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/master/master_rate.dart';
import 'package:yiapp/widget/master/master_com_cover.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/14 17:17
// usage ：运营商所属的全部大师
// ------------------------------------------------------

class BrokerMasterListPage extends StatefulWidget {
  final bool showLeading;
  final dynamic yiOrderData;

  BrokerMasterListPage({
    this.showLeading: false,
    this.yiOrderData,
    Key key,
  }) : super(key: key);

  @override
  _BrokerMasterListPageState createState() => _BrokerMasterListPageState();
}

class _BrokerMasterListPageState extends State<BrokerMasterListPage>
    with AutomaticKeepAliveClientMixin {
  List<BrokerMasterRes> _l = [];
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  var _future;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页获取大师信息
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"enabled": 1},
    };
    try {
      PageBean pb = await ApiBo.bMasterPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as BrokerMasterRes).toList();
      Log.info("当前运营商下总的大师个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.master_id == e.master_id,
            orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Log.info("当前已查询多少个大师：${_l.length}");
      setState(() {});
    } catch (e) {
      Log.error("分页查询运营商所属大师信息出现异常：$e");
    }
  }

  // 之所以一个 ListView 也另外定义一个Dart文件里，是因为 TabBarView 组件默认同父组件等宽高，
  // 如果指定高度，当前页面不能显示多个数据
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CusAppBar(text: "大师信息", showLeading: widget.showLeading),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
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
        header: CusHeader(),
        footer: CusFooter(),
        onLoad: () async => await _fetch(),
        onRefresh: () async => await _refresh(),
        child: ListView(
          children: <Widget>[
            if (_l.isEmpty) EmptyContainer(text: "暂无大师"),
            if (_l.isNotEmpty)
              ..._l.map(
                (e) => Column(
                  children: <Widget>[
                    // 大师列表中，每个大师的封面
                    MasterComCover(
                      masterInfo: e,
                      yiOrderData: widget.yiOrderData,
                    ),
                    // 大师好评、差评
                    MasterRate(
                      titles: [
                        "${e.best_rate}",
                        "${e.mid_rate}",
                        "${e.bad_rate}"
                      ],
                      subtitles: ["好评数", "中评数", "差评数"],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

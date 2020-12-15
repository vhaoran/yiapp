import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bo/broker_master_res.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/master/cus_number_data.dart';
import 'package:yiapp/widget/master/master_base_info.dart';
import 'package:yiapp/model/pagebean.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/14 17:17
// usage ：运营商下面的大师榜单
// ------------------------------------------------------

class MasterList extends StatefulWidget {
  MasterList({Key key}) : super(key: key);

  @override
  _MasterListState createState() => _MasterListState();
}

class _MasterListState extends State<MasterList>
    with AutomaticKeepAliveClientMixin {
  List<BrokerMasterRes> _l = []; // 大师榜单，目前只有获取所有大师的信息，没有排行榜
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
    var m = {"page_no": _pageNo, "rows_per_page": _rowsPerPage};
    try {
      PageBean pb = await ApiBo.bMasterPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as BrokerMasterRes).toList();
      Log.info("总的大师个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.broker_id != e.broker_id,
            orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Log.info("当前已查询多少条数据：${_l.length}");
      setState(() {});
    } catch (e) {
      Log.error("分页查询大师信息出现异常：$e");
    }
  }

  // 之所以一个 ListView 也另外定义一个Dart文件里，是因为 TabBarView 组件默认同父组件等宽高，
  // 如果指定高度，当前页面不能显示多个数据
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (_l.isEmpty) {
            return Center(child: CusText("暂无大师入驻", t_gray, 32));
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
          children: List.generate(_l.length, (i) {
            BrokerMasterRes e = _l[i];
            return Column(
              children: <Widget>[
                MasterCover(info: e),
                CusNumData(
                  titles: ["12345", "100%", "12888"],
                  subtitles: ["服务人数", "好评率", "粉丝数"],
                ), // 详情数据
              ],
            );
          }),
        ),
      ),
    );
  }

  /// 重置数据
  Future<void> _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/question/post_cover.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/23 上午11:22
// usage ：大师已完成的帖子订单
// ------------------------------------------------------

class MasterHisPage extends StatefulWidget {
  final bool is_vie;

  MasterHisPage({this.is_vie: false, Key key}) : super(key: key);

  @override
  _MasterHisPageState createState() => _MasterHisPageState();
}

class _MasterHisPageState extends State<MasterHisPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List _l = []; // 已完成列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 大师分页查询已完成帖子历史
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"stat": bbs_ok},
      "sort": {"create_date": -1},
    };
    widget.is_vie ? await _fetchVie(m) : await _fetchPrize(m);
  }

  /// 获取悬赏帖已完成历史
  _fetchPrize(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiBBSPrize.bbsPrizeHisPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as BBSPrize).toList();
      Log.info("总的悬赏帖已完成历史个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      if (mounted) setState(() {});
      Log.info("当前已查询悬赏帖已完成历史个数：${_l.length}");
    } catch (e) {
      Log.error("查询悬赏帖已完成历史出现异常：$e");
    }
  }

  /// 获取闪断帖已完成历史
  _fetchVie(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiBBSVie.bbsVieHisPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as BBSVie).toList();
      Log.info("总的闪断帖已完成历史个数：$_rowsCount");
      Log.info("第一个已完成帖子详情：${l.first.toJson()}");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      if (mounted) setState(() {});
      Log.info("当前已查询闪断帖已完成历史个数：${_l.length}");
    } catch (e) {
      Log.error("查询闪断帖已完成历史出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return ScrollConfiguration(
          behavior: CusBehavior(),
          child: EasyRefresh(
            header: CusHeader(),
            footer: CusFooter(),
            onLoad: () async => await _fetch(),
            onRefresh: () async => await _refresh(),
            child: _lv(),
          ),
        );
      },
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        if (_l.isEmpty)
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 200),
            child: Text(
              "暂无订单",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ),
        ..._l.map(
          (e) => PostCover(
            post: Post(
              data: e,
              is_vie: widget.is_vie,
              is_his: true,
            ),
            onChanged: _refresh,
          ),
        ),
      ],
    );
  }

  /// 刷新数据
  Future<void> _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    if (mounted) setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

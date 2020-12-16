import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
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
// date  ：2020/12/11 上午10:15
// usage ：已取消帖子历史
// ------------------------------------------------------

class PostCancelledHis extends StatefulWidget {
  final Post post;

  PostCancelledHis({this.post, Key key}) : super(key: key);

  @override
  _PostCancelledHisState createState() => _PostCancelledHisState();
}

class _PostCancelledHisState extends State<PostCancelledHis>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List _l = []; // 已取消帖子列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 已取消帖子历史分页查询
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"stat": bbs_rm},
      "sort": {"create_date": -1},
    };
    widget.post.is_vie ? await _fetchVie(m) : await _fetchPrize(m);
  }

  /// 获取悬赏帖已取消历史
  _fetchPrize(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiBBSPrize.bbsPrizeHisPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as BBSPrize).toList();
      Log.info("总的悬赏帖已取消历史个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      if (mounted) setState(() {});
      Log.info("当前已查询悬赏帖已取消历史个数：${_l.length}");
    } catch (e) {
      Log.error("查询悬赏帖已取消历史出现异常：$e");
    }
  }

  /// 获取闪断帖已取消历史
  _fetchVie(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiBBSVie.bbsVieHisPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as BBSVie).toList();
      Log.info("总的闪断帖已取消历史个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      if (mounted) setState(() {});
      Log.info("当前已查询闪断帖已取消历史个数：${_l.length}");
    } catch (e) {
      Log.error("查询闪断帖已取消历史出现异常：$e");
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
        return _lv();
      },
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
                  is_vie: widget.post.is_vie,
                  is_his: widget.post.is_his,
                ),
                onChanged: _refresh,
              ),
            ),
          ],
        ),
      ),
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

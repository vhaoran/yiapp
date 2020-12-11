import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/question/post_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/11 上午10:05
// usage ：已付款帖子历史
// ------------------------------------------------------

class PostPaidPay extends StatefulWidget {
  final bool isVie;
  final bool isHis;

  PostPaidPay({this.isVie: false, this.isHis: false, Key key})
      : super(key: key);

  @override
  _PostPaidPayState createState() => _PostPaidPayState();
}

class _PostPaidPayState extends State<PostPaidPay>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List _l = []; // 已付款列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 帖子已付款历史分页查询
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"stat": pay_paid},
      "sort": {"create_date": -1},
    };
    widget.isVie ? await _fetchVie(m) : await _fetchPrize(m);
  }

  /// 获取悬赏帖已付款历史
  _fetchPrize(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiBBSPrize.bbsPrizeHisPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as BBSPrize).toList();
      Log.info("总的悬赏帖已付款历史个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      if (mounted) setState(() {});
      Log.info("当前已查询悬赏帖已付款历史个数：${_l.length}");
    } catch (e) {
      Log.error("查询悬赏帖已付款历史出现异常：$e");
    }
  }

  /// 获取闪断帖已付款历史
  _fetchVie(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiBBSVie.bbsVieHisPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as BBSVie).toList();
      Log.info("总的闪断帖已付款历史个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      if (mounted) setState(() {});
      Log.info("当前已查询闪断帖已付款历史个数：${_l.length}");
    } catch (e) {
      Log.error("查询闪断帖已付款历史出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
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
                    child: CusText("暂无订单", t_gray, 32),
                  ),
                ..._l.map(
                  (e) => PostCover(
                    data: e,
                    isVie: widget.isVie,
                    isHis: widget.isHis,
                    onChanged: _refresh,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

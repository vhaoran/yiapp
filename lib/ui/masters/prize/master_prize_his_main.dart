import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/masters/prize/master_prize_his_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/post_com/post_com_button.dart';
import 'package:yiapp/widget/post_com/post_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 上午10:53
// usage ：大师悬赏帖已完成订单入口
// ------------------------------------------------------

class MasterPrizeHisMain extends StatefulWidget {
  MasterPrizeHisMain({Key key}) : super(key: key);

  @override
  _MasterPrizeHisMainState createState() => _MasterPrizeHisMainState();
}

class _MasterPrizeHisMainState extends State<MasterPrizeHisMain>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<BBSPrize> _l = []; // 悬赏帖已完成列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 大师分页查询悬赏帖已完成订单
  _fetch() async {
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"stat": bbs_ok, "master_reply.master_id": ApiBase.uid},
      "sort": {"create_date_int": -1},
    };
    try {
      PageBean pb = await ApiBBSPrize.bbsPrizeHisPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as BBSPrize).toList();
      Log.info("大师总的悬赏帖已完成历史个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      if (mounted) setState(() {});
      Log.info("大师当前已查询悬赏帖已完成历史个数：${_l.length}");
    } catch (e) {
      Log.error("大师查询悬赏帖已完成历史出现异常：$e");
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
            if (_l.isEmpty) EmptyContainer(text: "暂无订单"),
            if (_l.isNotEmpty) ..._l.map((e) => _coverItem(e)),
          ],
        ),
      ),
    );
  }

  Widget _coverItem(BBSPrize prize) {
    return InkWell(
      onTap: () => _lookPrizePost(prize.id),
      child: PostComCover(
        prize: prize,
        events: Row(
          children: <Widget>[
            PostComButton(
              text: "详情",
              onPressed: () => _lookPrizePost(prize.id),
            ),
          ],
        ),
      ),
    );
  }

  /// 查看悬赏帖已完成订单详情
  void _lookPrizePost(String postId) {
    CusRoute.push(context, MasterPrizeHisPage(postId: postId))
        .then((value) async {
      if (value != null) {
        await _refresh();
      }
    });
  }

  /// 刷新数据
  _refresh() async {
    _l.clear();
    setState(() {});
    await _fetch();
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/masters/prize/master_prize_doing_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/post_com/post_com_button.dart';
import 'package:yiapp/widget/post_com/post_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 下午5:23
// usage ：大师悬赏帖处理中订单入口
// ------------------------------------------------------

class MasterPrizeDoingMain extends StatefulWidget {
  MasterPrizeDoingMain({Key key}) : super(key: key);

  @override
  _MasterPrizeDoingMainState createState() => _MasterPrizeDoingMainState();
}

class _MasterPrizeDoingMainState extends State<MasterPrizeDoingMain>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<BBSPrize> _l = []; // 悬赏帖处理中列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 大师分页查询悬赏帖处理中订单
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"master_id": ApiBase.uid},
      "sort": {"last_updated": -1}
    };
    try {
      List<BBSPrize> l = await ApiBBSPrize.bbsPrizeMasterList(m);
      if (l != null) {
        _l = l;
        Log.info("大师处理中的悬赏帖个数 ${_l.length}");
        setState(() {});
      }
    } catch (e) {
      Log.error("大师查询处理中的悬赏帖出现异常：$e");
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
            PostComButton(
              text: "回复",
              onPressed: () => _lookPrizePost(prize.id),
            ),
          ],
        ),
      ),
    );
  }

  /// 查看悬赏帖处理中订单详情
  void _lookPrizePost(String postId) {
    CusRoute.push(context, MasterPrizeDoingPage(postId: postId))
        .then((value) async {
      if (value != null) {
        await _refresh();
      }
    });
  }

  /// 刷新数据
  _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    setState(() {});
    await _fetch();
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/ui/question/reward_post/reward_cover.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/21 10:18
// usage ：悬赏帖主页面
// ------------------------------------------------------

class RewardPostPage extends StatefulWidget {
  RewardPostPage({Key key}) : super(key: key);

  @override
  _RewardPostPageState createState() => _RewardPostPageState();
}

class _RewardPostPageState extends State<RewardPostPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _page_no = 0;
  int _rows_count = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<BBSPrize> _l = []; // 悬赏帖列表

  @override
  void initState() {
    Log.info("进入了悬赏帖");
    _future = _fetch();
    super.initState();
  }

  /// 悬赏帖分页查询
  _fetch() async {
    if (_page_no * _rows_per_page > _rows_count) return;
    _page_no++;
    // TODO 这里需要设置未打赏的在前面，已打赏的在后面
    var m = {
      "page_no": _page_no,
      "rows_per_page": _rows_per_page,
      "where": {
        "stat": {
          "\$in": [1, 2] // 1 已支付 和 2 已打赏
        }
      },
      "sort": {"create_date": -1}, // 按时间倒序排列
    };
    try {
      PageBean pb = await ApiBBSPrize.bbsPrizePage(m);
      if (pb != null) {
        if (_rows_count == 0) _rows_count = pb.rowsCount ?? 0;
        Log.info("总的悬赏帖个数：$_rows_count");
        var l = pb.data.map((e) => e as BBSPrize).toList();
        // 在原来的基础上继续添加新的数据
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        Log.info("当前已查询多少条悬赏帖：${_l.length}");
      }
    } catch (e) {
      Log.error("分页查询悬赏帖出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: _buildFb(),
    );
  }

  Widget _buildFb() {
    final TextStyle style = TextStyle(color: t_gray, fontSize: S.sp(15));
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(child: Text("暂无帖子", style: style));
        }
        return _lv();
      },
    );
  }

  Widget _lv() {
    return EasyRefresh(
      header: CusHeader(),
      footer: CusFooter(),
      child: ListView(
        // 显示悬赏帖
        children: <Widget>[..._l.map((e) => RewardCover(data: e))],
      ),
      onLoad: () async => _refresh(),
      onRefresh: () async {
        _page_no = _rows_count = 0;
        _l.clear();
        _refresh();
      },
    );
  }

  void _refresh() async {
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

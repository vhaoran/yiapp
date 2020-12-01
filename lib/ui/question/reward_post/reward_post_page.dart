import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
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
    // 这里应该设置已支付未打赏的在后面，已打赏的在后面，方便查看
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
        if (_rows_count == 0) {
          _rows_count = pb.rowsCount ?? 0;
        }
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
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: _buildFb(),
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        return EasyRefresh(
          header: CusHeader(),
          footer: CusFooter(),
          child: ListView(
            children: <Widget>[
              // 没有帖子
              if (_l.isEmpty)
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 200),
                  child: CusText("暂未有人发帖", t_gray, 30),
                ),
              // 有帖子，则展示所有帖子
              ..._l.map((e) => RewardCover(data: e)),
            ],
          ),
          onLoad: () async {
            await _refresh();
          },
          onRefresh: () async {
            _page_no = _rows_count = 0;
            _l.clear();
            _refresh();
          },
        );
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

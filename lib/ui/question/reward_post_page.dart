import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/ui/question/com_post/post_cover.dart';

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
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _count = 10; // 默认每页查询个数
  List<BBSPrize> _l = []; // 悬赏帖列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询悬赏帖
  _fetch() async {
    if (_pageNo * _count > _rowsCount) return; // 默认每页查询20条
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _count,
//      "where": {"stat": 1}, // 这里的 stat 应设为 1 已支付 和 2 已打赏
      "sort": {"create_date": -1},
    };
    try {
      PageBean pb = await ApiBBSPrize.bbsPrizePage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      Debug.log("总的悬赏帖个数：$_rowsCount");
      var l = pb.data.map((e) => e as BBSPrize).toList();
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Debug.log("当前已查询多少条悬赏帖：${_l.length}");
    } catch (e) {
      Debug.logError("分页查询悬赏帖出现异常：$e");
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
        if (_l.isEmpty) {
          return Center(child: CusText("暂时还没有人发帖", t_gray, 28));
        }
        return EasyRefresh(
          child: ListView(
            children: List.generate(
              _l.length,
              (i) => PostCover(data: _l[i]),
            ),
          ),
          onLoad: () {
            _refresh();
          },
          onRefresh: () async {
            _pageNo = _rowsCount = 0;
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

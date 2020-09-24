import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/ui/question/com_post/post_cover.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 14:28
// usage ：悬赏帖历史记录
// ------------------------------------------------------

class RewardPostHisPage extends StatefulWidget {
  RewardPostHisPage({Key key}) : super(key: key);

  @override
  _RewardPostHisPageState createState() => _RewardPostHisPageState();
}

class _RewardPostHisPageState extends State<RewardPostHisPage> {
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

  /// 分页查询悬赏帖历史
  _fetch() async {
    if (_pageNo * _count > _rowsCount) return;
    _pageNo++;
    var m = {"page_no": _pageNo, "rows_per_page": _count};
    try {
      PageBean pb = await await ApiBBSPrize.bbsPrizeHisPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as BBSPrize).toList();
      Debug.log("总的历史悬赏帖个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Debug.log("当前已查询历史悬赏帖多少条：${_l.length}");
    } catch (e) {
      Debug.logError("分页查询历史悬赏帖出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "悬赏帖历史"),
      body: _buildFb(),
      backgroundColor: primary,
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
          return Center(child: CusText("暂未发布帖子", t_gray, 28));
        }
        return EasyRefresh(
          child: ListView(
            children: List.generate(
              _l.length,
              (i) => PostCover(data: _l[i]),
            ),
          ),
          onLoad: () async {
            await _fetch();
            setState(() {});
          },
        );
      },
    );
  }
}

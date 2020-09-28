import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/question/reward_post/reward_cover.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/28 14:18
// usage ：悬赏帖历史
// ------------------------------------------------------

class RewardPostHis extends StatefulWidget {
  RewardPostHis({Key key}) : super(key: key);

  @override
  _RewardPostHisState createState() => _RewardPostHisState();
}

class _RewardPostHisState extends State<RewardPostHis> {
  final List<String> _tabs = ["待付款", "已付款", "已取消"];
  final List<BBSPrize> _l = []; // 悬赏帖历史全纪录
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _count = 10; // 默认每页查询个数

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询悬赏帖历史
  _fetch() async {
    if (_pageNo * _count > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _count,
      "where": {"uid": ApiBase.uid},
      "sort": {"create_date": -1},
    };
    try {
//      PageBean pb = await ApiBBSPrize.bbsPrizeHisPage(m);
      PageBean pb = await ApiBBSPrize.bbsPrizePage(m);
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
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: '悬赏帖订单'),
        body: FutureBuilder(
          future: _future,
          builder: (context, snap) {
            if (!snapDone(snap)) {
              return Center(child: CircularProgressIndicator());
            }
            return _bodyCtr();
          },
        ),
        backgroundColor: primary,
      ),
    );
  }

  Widget _bodyCtr() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          indicatorWeight: Adapt.px(6),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.all(Adapt.px(8)),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabs.length,
            (i) => CusText(_tabs[i], t_gray, 28),
          ),
        ),
        SizedBox(height: Adapt.px(15)),
        Expanded(
          child: TabBarView(
            children: List.generate(_tabs.length, (i) {
              List myList = [];
              myList = i == _tabs.length - 1
                  ? _l.where((e) => e.stat == -1).toList() // 已取消
                  : _l.where((e) => e.stat == i).toList(); // 待付款、已付款
              if (myList.isEmpty)
                return Center(child: CusText("暂时没有数据", t_gray, 28));
              return EasyRefresh(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    ...myList.map((e) => RewardCover(
                          data: e,
                          onChanged: () {
                            _pageNo = _rowsCount = 0;
                            _l.clear();
                            _refresh();
                          },
                        )),
                  ],
                ),
                onLoad: () async {
                  await _refresh();
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  void _refresh() async {
    await _fetch();
    setState(() {});
  }
}

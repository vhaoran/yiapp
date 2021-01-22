import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/ui/masters/prize/master_prize_aim_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/post_com/post_com_button.dart';
import 'package:yiapp/widget/post_com/post_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 下午7:50
// usage ：大师悬赏帖可抢单订单入口
// ------------------------------------------------------

class MasterPrizeAimMain extends StatefulWidget {
  MasterPrizeAimMain({Key key}) : super(key: key);

  @override
  _MasterPrizeAimMainState createState() => _MasterPrizeAimMainState();
}

class _MasterPrizeAimMainState extends State<MasterPrizeAimMain>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<BBSPrize> _l = []; // 悬赏帖可抢单列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 大师分页查询悬赏帖可抢单订单
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"stat": bbs_paid},
      "sort": {"create_date_int": -1},
    };
    try {
      PageBean pb = await ApiBBSPrize.bbsPrizePage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("未过滤时悬赏帖总个数 $_rowsCount");
        var l = pb.data.map((e) => e as BBSPrize).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        Log.info("已加载悬赏帖待付款个数 ${_l.length}");
        setState(() {});
      }
    } catch (e) {
      Log.error("分页查询悬赏帖待付款出现异常：$e");
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
            PostComButton(text: "抢单", onPressed: () => _doAimPrize(prize)),
          ],
        ),
      ),
    );
  }

  /// 抢悬赏帖
  void _doAimPrize(BBSPrize prize) async {
    try {
      bool ok = await ApiBBSPrize.bbsPrizeMasterAim(prize.id);
      if (ok) {
        CusToast.toast(context, text: "抢单成功");
      } else {
        CusToast.toast(context, text: "抢单失败");
      }
      _refresh();
    } catch (e) {
      Log.error("大师抢闪断帖出现异常：$e");
      if (e.toString() == "操作错误已存在，不需要再次添加") {
        CusToast.toast(context, text: "你已经抢过了");
        // 提示抢过了也刷新一下页面
        _refresh();
      }
    }
  }

  /// 查看悬赏帖可抢单订单详情
  void _lookPrizePost(String postId) {
    CusRoute.push(context, MasterPrizeAimPage(postId: postId))
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

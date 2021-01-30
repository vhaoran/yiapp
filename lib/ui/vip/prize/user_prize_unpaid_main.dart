import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/ui/vip/prize/user_prize_doing_page.dart';
import 'package:yiapp/ui/vip/prize/user_prize_unpaid_page.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/post_com/post_com_button.dart';
import 'package:yiapp/widget/post_com/post_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 上午10:18
// usage ：会员悬赏帖待付款订单入口
// ------------------------------------------------------

class UserPrizeUnpaidMain extends StatefulWidget {
  UserPrizeUnpaidMain({Key key}) : super(key: key);

  @override
  _UserPrizeUnpaidMainState createState() => _UserPrizeUnpaidMainState();
}

class _UserPrizeUnpaidMainState extends State<UserPrizeUnpaidMain>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<BBSPrize> _l = []; // 悬赏帖待付款列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 会员分页查询悬赏帖待付款订单
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"stat": bbs_unpaid, "uid": ApiBase.uid},
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
            PostComButton(
              text: "支付",
              onPressed: () {
                var pay =
                    PayData(amt: prize.amt, b_type: b_bbs_prize, id: prize.id);
                BalancePay(
                  context,
                  data: pay,
                  onSuccess: () async {
                    await _refresh();
                    CusRoute.push(
                      context,
                      UserPrizeDoingPage(postId: prize.id, backData: ""),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 查看悬赏帖待付款订单详情
  void _lookPrizePost(String postId) {
    CusRoute.push(context, UserPrizeUnpaidPage(postId: postId));
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

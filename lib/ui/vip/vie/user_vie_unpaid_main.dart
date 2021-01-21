import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/vip/vie/user_vie_unpaid_page.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/post_com/post_com_button.dart';
import 'package:yiapp/widget/post_com/post_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 下午2:59
// usage ：会员闪断帖待付款订单入口
// ------------------------------------------------------

class UserVieUnpaidMain extends StatefulWidget {
  UserVieUnpaidMain({Key key}) : super(key: key);

  @override
  _UserVieUnpaidMainState createState() => _UserVieUnpaidMainState();
}

class _UserVieUnpaidMainState extends State<UserVieUnpaidMain>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<BBSVie> _l = []; // 闪断帖待付款列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 会员分页查询闪断帖待付款订单
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"stat": bbs_unpaid, "uid": ApiBase.uid},
      "sort": {"create_date": -1},
    };
    try {
      PageBean pb = await ApiBBSVie.bbsViePage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("未过滤时闪断帖总个数 $_rowsCount");
        var l = pb.data.map((e) => e as BBSVie).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        Log.info("已加载闪断帖待付款个数 ${_l.length}");
        setState(() {});
      }
    } catch (e) {
      Log.error("分页查询闪断帖待付款出现异常：$e");
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

  Widget _coverItem(BBSVie vie) {
    return InkWell(
      onTap: () => _lookViePost(vie.id),
      child: PostComCover(
        vie: vie,
        events: Row(
          children: <Widget>[
            PostComButton(
              text: "详情",
              onPressed: () => _lookViePost(vie.id),
            ),
            PostComButton(
              text: "支付",
              onPressed: () {
                var pay = PayData(amt: vie.amt, b_type: b_bbs_vie, id: vie.id);
                BalancePay(
                  context,
                  data: pay,
                  onSuccess: () async {
                    _lookViePost(vie.id);
                    await _refresh();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 查看闪断帖待付款订单详情
  void _lookViePost(String postId) {
    CusRoute.push(context, UserVieUnpaidPage(postId: postId));
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

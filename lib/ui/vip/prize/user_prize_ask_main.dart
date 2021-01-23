import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/vip/prize/user_prize_doing_page.dart';
import 'package:yiapp/ui/vip/prize/user_prize_his_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/post_com/post_com_button.dart';
import 'package:yiapp/widget/post_com/post_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 下午3:31
// usage ：会员问命悬赏帖订单入口
// ------------------------------------------------------

class UserPrizeAskMain extends StatefulWidget {
  UserPrizeAskMain({Key key}) : super(key: key);

  @override
  _UserPrizeAskMainState createState() => _UserPrizeAskMainState();
}

class _UserPrizeAskMainState extends State<UserPrizeAskMain>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数，必须要为10，否则数据不准
  List<BBSPrize> _l = []; // 悬赏帖处理中列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 会员分页查询所属运营商下，悬赏帖已付款以及已打赏的悬赏帖订单
  _fetch() async {
    // Page2 返回数据的总个数是不准确的，直接页面加1查看即可
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {
        "broker_id": CusRole.broker_id,
        "stat": {"\$gte": bbs_paid},
      },
      "sort": {"create_date_int": -1}, // 按时间倒序排列
    };

    try {
      PageBean pb = await ApiBBSPrize.bbsPrizePage2(m);
      if (pb != null) {
        var l = pb.data.map((e) => e as BBSPrize).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        Log.info("问命页面当前已查询悬赏帖多少个：${_l.length}");
        setState(() {});
      }
    } catch (e) {
      Log.error("问命页面分页查询悬赏帖出现异常：$e");
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
      onTap: () => _lookPrizePost(prize),
      child: PostComCover(
        prize: prize,
        events: Row(
          children: <Widget>[
            PostComButton(
              text: "详情",
              onPressed: () => _lookPrizePost(prize),
            ),
            // 本人已支付的帖子，没有大师回复时，会员可以选择取消订单
            if (prize.uid == ApiBase.uid &&
                prize.stat == bbs_paid &&
                prize.master_reply.isEmpty)
              PostComButton(
                text: "取消",
                onPressed: () => _doCancel(prize.id),
              ),
            // 本人的帖子，有大师回复时，会员可点击回复
            if (prize.uid == ApiBase.uid &&
                prize.master_reply.isNotEmpty &&
                prize.stat == bbs_paid)
              PostComButton(
                text: "回复",
                onPressed: () => CusRoute.push(
                    context, UserPrizeDoingPage(postId: prize.id)),
              ),
          ],
        ),
      ),
    );
  }

  /// 取消悬赏帖订单
  void _doCancel(String postId) {
    CusDialog.normal(context, title: "确定取消订单吗?", textCancel: "再想想",
        onApproval: () async {
      try {
        bool ok = await ApiBBSPrize.bbsPrizeCancel(postId);
        if (ok) {
          Log.info("取消悬赏帖订单结果：$ok");
          CusToast.toast(context, text: "取消成功");
          await _refresh();
        }
      } catch (e) {
        CusToast.toast(context, text: "该帖子已不可取消", milliseconds: 1500);
        await _refresh();
        Log.error("取消悬赏帖订单出现异常：$e");
      }
    });
  }

  /// 查看悬赏帖处理中订单详情
  void _lookPrizePost(BBSPrize prize) {
    if (prize.stat == bbs_paid) {
      CusRoute.push(context, UserPrizeDoingPage(postId: prize.id));
    }
    if (prize.stat == bbs_ok) {
      CusRoute.push(context, UserPrizeHisPage(postId: prize.id));
    }
  }

  /// 刷新数据
  _refresh() async {
    _pageNo = 0;
    _l.clear();
    setState(() {});
    await _fetch();
  }

  @override
  bool get wantKeepAlive => true;
}

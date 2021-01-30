import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/vip/vie/user_vie_doing_page.dart';
import 'package:yiapp/ui/vip/vie/user_vie_his_page.dart';
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
// usage ：会员问命闪断帖订单入口
// ------------------------------------------------------

class UserVieAskMain extends StatefulWidget {
  UserVieAskMain({Key key}) : super(key: key);

  @override
  _UserVieAskMainState createState() => _UserVieAskMainState();
}

class _UserVieAskMainState extends State<UserVieAskMain>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数，必须要为10，否则数据不准
  List<BBSVie> _l = []; // 闪断帖处理中列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 会员分页查询所属运营商下，闪断帖已付款、已抢单、已打赏的订单
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
      PageBean pb = await ApiBBSVie.bbsViePage2(m);
      if (pb != null) {
        var l = pb.data.map((e) => e as BBSVie).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        Log.info("问命页面当前已查询闪断帖多少个：${_l.length}");
        setState(() {});
      }
    } catch (e) {
      Log.error("问命页面分页查询闪断帖出现异常：$e");
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
      onTap: () => _lookViePost(vie),
      child: PostComCover(
        vie: vie,
        events: Row(
          children: <Widget>[
            PostComButton(
              text: "详情",
              onPressed: () => _lookViePost(vie),
            ),
            // 本人已支付的帖子，没有大师回复时，会员可以选择取消订单
            // 已被抢的订单不显示取消
            if (vie.uid == ApiBase.uid &&
                vie.stat == bbs_paid &&
                vie.reply.isEmpty)
              PostComButton(
                text: "取消",
                onPressed: () => _doCancel(vie.id),
              ),
            // 本人的帖子，有大师回复时，会员可点击回复
            if (vie.uid == ApiBase.uid &&
                vie.reply.isNotEmpty &&
                vie.stat == bbs_paid)
              PostComButton(
                text: "回复",
                onPressed: () =>
                    CusRoute.push(context, UserVieDoingPage(postId: vie.id)),
              ),
          ],
        ),
      ),
    );
  }

  /// 取消闪断帖订单
  void _doCancel(String postId) {
    CusDialog.normal(context, title: "确定取消订单吗?", textCancel: "再想想",
        onApproval: () async {
      try {
        bool ok = await ApiBBSVie.bbsVieCancel(postId);
        if (ok) {
          Log.info("取消闪断帖订单结果：$ok");
          CusToast.toast(context, text: "取消成功");
          await _refresh();
        }
      } catch (e) {
        CusToast.toast(context, text: "已经有大师抢单了，快去看看吧", milliseconds: 1500);
        await _refresh();
        Log.error("取消闪断帖订单出现异常：$e");
      }
    });
  }

  /// 查看闪断帖处理中订单详情
  void _lookViePost(BBSVie vie) {
    if (vie.stat == bbs_paid || vie.stat == bbs_aim) {
      CusRoute.push(context, UserVieDoingPage(postId: vie.id));
    }
    if (vie.stat == bbs_ok) {
      CusRoute.push(context, UserVieHisPage(postId: vie.id));
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

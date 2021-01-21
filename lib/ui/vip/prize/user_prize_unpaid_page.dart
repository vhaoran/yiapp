import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/widget/post_com/post_com_button.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 上午10:18
// usage ：会员悬赏帖待付款订单页
// ------------------------------------------------------

class UserPrizeUnpaidPage extends StatefulWidget {
  UserPrizeUnpaidPage({Key key}) : super(key: key);

  @override
  _UserPrizeUnpaidPageState createState() => _UserPrizeUnpaidPageState();
}

class _UserPrizeUnpaidPageState extends State<UserPrizeUnpaidPage>
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
      "sort": {"create_date": -1},
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
            if (_l.isNotEmpty)
              ..._l.map(
                (e) => InkWell(
                  onTap: () {},
                  child: Card(
                    color: fif_primary,
                    shadowColor: Colors.white70,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: _coverItem(e),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 单个悬赏帖未付款封面
  Widget _coverItem(BBSPrize prize) {
    Map<String, Color> m = SwitchUtil.postType(prize.content_type);
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            // 头像
            CusAvatar(url: prize.icon ?? "", size: 30, circle: true),
            SizedBox(width: S.w(15)),
            Expanded(
              child: Text(
                prize.nick ?? "", // 昵称
                style: TextStyle(color: t_gray, fontSize: S.sp(15)),
              ),
            ),
            SizedBox(width: S.w(10)),
            Text(
              "悬赏 ${prize.amt ?? '***'} 元宝", // 悬赏金
              style: TextStyle(color: t_yi, fontSize: S.sp(15)),
            ),
          ],
        ),
        SizedBox(height: S.h(5)),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                prize.title ?? "", // 帖子标题
                style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: true,
              ),
            ),
            SizedBox(width: S.w(10)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: m.values.first,
              ),
              padding: EdgeInsets.all(20),
              child: Text(m.keys.first, style: TextStyle(fontSize: S.sp(16))),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              prize.create_date, // 发帖时间
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
            Spacer(),
            PostComButton(text: "详情", onPressed: () {}),
            PostComButton(text: "支付", onPressed: () {}),
          ],
        ),
      ],
    );
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

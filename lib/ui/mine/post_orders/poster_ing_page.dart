import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/question/post_cover.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/refresh_hf.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/18 下午5:30
// usage ：用户处理中的帖子订单
// ------------------------------------------------------

class PosterIngPage extends StatefulWidget {
  final bool is_vie;

  PosterIngPage({this.is_vie: false, Key key}) : super(key: key);

  @override
  _PosterIngPageState createState() => _PosterIngPageState();
}

class _PosterIngPageState extends State<PosterIngPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  List _l = []; // 用户处理中的帖子列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 用户获取处理中的帖子
  _fetch() async {
    try {
      // 用户处理中的闪断帖的状态分为1已付款和2已抢单，
      var mVie = {
        "where": {
          "uid": ApiBase.uid,
          "stat": {
            "\$in": [bbs_paid, bbs_aim]
          }
        },
        "sort": {"create_date_int": -1}
      };
      // 悬赏帖处理中的只有状态为1的
      var mPrize = {
        "where": {"uid": ApiBase.uid, "stat": bbs_paid},
        "sort": {"create_date_int": -1}
      };
      var m = widget.is_vie ? mVie : mPrize;
      Log.info("+++++++++m:$m");
      PageBean pb = widget.is_vie
          ? await ApiBBSVie.bbsViePage(m)
          : await ApiBBSPrize.bbsPrizePage(m);
      if (pb != null) {
        _l = pb.data.map((e) => e).toList();
        // 如果帖子的 last_reply 不为空，说明有大师回复了，为处理中
//        _l.retainWhere((e) => e.last_reply != null);
      }
      Log.info("用户处理中的${logVie(widget.is_vie)}个数：${_l.length}");
      setState(() {});
    } catch (e) {
      Log.error("获取用户处理中的${logVie(widget.is_vie)}出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
    );
  }

  Widget _lv() {
    return EasyRefresh(
      header: CusHeader(),
      footer: CusFooter(),
      onRefresh: () async => await _refresh(),
      child: ListView(
        children: <Widget>[
          if (_l.isEmpty) _noData(),
          ..._l.map(
            (e) => PostCover(
              post: Post(data: e, is_vie: widget.is_vie, is_ing: true),
              onChanged: _refresh,
            ),
          ),
        ],
      ),
    );
  }

  /// 显示没有帖子
  Widget _noData() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: S.screenH() / 4),
      child: Text(
        "暂无订单",
        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
      ),
    );
  }

  Future<void> _refresh() async {
    _l.clear();
    setState(() {});
    await _fetch();
  }

  @override
  bool get wantKeepAlive => true;
}

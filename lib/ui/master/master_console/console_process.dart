import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/ui/question/post_cover.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/refresh_hf.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/15 上午10:43
// usage ：处理中的悬赏帖订单
// ------------------------------------------------------

class ConsoleProcess extends StatefulWidget {
  final bool isProcessing; // 是否正在处理中的单子

  ConsoleProcess({this.isProcessing: false, Key key}) : super(key: key);

  @override
  _ConsoleProcessState createState() => _ConsoleProcessState();
}

class _ConsoleProcessState extends State<ConsoleProcess>
    with AutomaticKeepAliveClientMixin {
  var _future;
  List<BBSPrize> _l = []; // 处理中的帖子列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取正在处理中的悬赏帖
  _fetch() async {
    var m = {
      "sort": {"last_updated": 1}
    };
    try {
      var l = await ApiBBSPrize.bbsPrizeMasterList(m);
      if (l != null) {
        _l = l;
        Log.info("大师处理中的悬赏帖个数：${_l.length}");
      }
    } catch (e) {
      Log.error("获取大师处理中的订单出现异常：$e");
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
      onRefresh: () async {
        _l.clear();
        await _fetch();
        setState(() {});
      },
      child: ListView(
        children: <Widget>[
          if (_l.isEmpty) _noData(),
          ..._l.map(
            (e) => PostCover(post: Post(data: e, is_ing: true)),
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

  @override
  bool get wantKeepAlive => true;
}

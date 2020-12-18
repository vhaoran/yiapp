import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/question/post_cover.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/refresh_hf.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/15 上午10:43
// usage ：大师处理中的帖子订单
// ------------------------------------------------------

class ConsoleIngPage extends StatefulWidget {
  final bool is_vie;

  ConsoleIngPage({this.is_vie: false, Key key}) : super(key: key);

  @override
  _ConsoleIngPageState createState() => _ConsoleIngPageState();
}

class _ConsoleIngPageState extends State<ConsoleIngPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  List _l = []; // 处理中的帖子列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取正在处理中的帖子
  _fetch() async {
    try {
      if (widget.is_vie) {
        var m1 = {
          "where": {"stat": bbs_aim},
          "sort": {"last_updated": -1}
        };
        PageBean pb = await ApiBBSVie.bbsViePage(m1);

        if (pb != null) {
          _l = pb.data.map((e) => e).toList();
        }
      } else {
        var m2 = {
          "sort": {"last_updated": -1}
        };
        var res = await ApiBBSPrize.bbsPrizeMasterList(m2);
        if (res != null) _l = res;
      }
      Log.info("大师处理中的${widget.is_vie ? '闪断' : '悬赏'}帖个数：${_l.length}");
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
            (e) => PostCover(
              post: Post(data: e, is_vie: widget.is_vie, is_ing: true),
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

  @override
  bool get wantKeepAlive => true;
}

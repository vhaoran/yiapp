import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/model/orders/yiorder_exp_res.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/master/master_rate.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/24 上午11:43
// usage ：查看大师主页（用户、大师共用此页面）
// ------------------------------------------------------

class MasterHome extends StatefulWidget {
  final MasterInfo m;

  MasterHome({this.m, Key key}) : super(key: key);

  @override
  _MasterHomeState createState() => _MasterHomeState();
}

class _MasterHomeState extends State<MasterHome> {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<YiOrderExpRes> _l = []; // 大师评价列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询某个大师评价
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {"master_id": widget.m.uid},
    };
    try {
      PageBean pb = await ApiYiOrder.yiOrderExpPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as YiOrderExpRes).toList();
      Log.info("大师订单总评价个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Log.info("当前已查询大师订单评价多少条：${_l.length}");
      setState(() {});
    } catch (e) {
      Log.error("分页查询大师订单评价出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
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
            Text(
              "${widget.m.brief}",
              style: TextStyle(color: t_gray, fontSize: S.sp(16)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: S.h(5)),
            // 大师好评差评率
            MasterRate(
              titles: ["好评率", "中评率", "差评率"],
              subtitles: [
                "${widget.m.best_rate}",
                "${widget.m.mid_rate}",
                "${widget.m.bad_rate}"
              ],
            ),
            Center(
              child: Text(
                "评论区",
                style: TextStyle(color: t_primary, fontSize: S.sp(16)),
              ),
            ),
            // 大师评价区域
            ..._l.map((e) => _commentView(e)),
          ],
        ),
      ),
    );
  }

  /// 评论区域
  Widget _commentView(YiOrderExpRes r) {
    return Card(
      margin: EdgeInsets.all(2),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: S.h(5),
          horizontal: S.w(10),
        ),
        color: fif_primary,
        child: Row(
          children: <Widget>[
            // 头像
            CusAvatar(url: r.icon, rate: 20),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    r.nick, // 评论人昵称
                    style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                  ),
                  SizedBox(height: S.h(3)),
                  Text(
                    r.exp_text, // 评论内容
                    style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                  ),
                  SizedBox(height: S.h(3)),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      r.create_date, // 评论时间
                      style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _refresh() async {
    _l.clear();
    _pageNo = _rowsCount = 0;
    setState(() {});
    await _fetch();
  }
}

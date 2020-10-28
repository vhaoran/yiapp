import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/question/flash_post/flash_cover.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/28 11:07
// usage ：闪断帖 -- 待付款
// ------------------------------------------------------

class FlashAwaitPay extends StatefulWidget {
  FlashAwaitPay({Key key}) : super(key: key);

  @override
  _FlashAwaitPayState createState() => _FlashAwaitPayState();
}

class _FlashAwaitPayState extends State<FlashAwaitPay>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<BBSVie> _l = []; // 闪断帖待付款列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 闪断帖待付款分页查询
  _fetch() async {
    if (_pageNo * _rows_per_page > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rows_per_page,
      "where": {"stat": pay_await, "uid": ApiBase.uid},
      "sort": {"create_date": -1},
    };
    try {
      PageBean pb = await ApiBBSVie.bbsViePage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as BBSVie).toList();
      Debug.log("总的闪断帖待付款个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      if (mounted) setState(() {});
      Debug.log("当前已查询闪断帖待付款个数：${_l.length}");
    } catch (e) {
      Debug.logError("分页查询闪断帖待付款出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        return ScrollConfiguration(
          behavior: CusBehavior(),
          child: EasyRefresh(
            header: CusHeader(),
            footer: CusFooter(),
            onLoad: () async => await _fetch(),
            onRefresh: () async => await _refresh(),
            child: ListView(
              children: <Widget>[
                if (_l.isEmpty)
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 200),
                    child: CusText("暂无相关订单", t_gray, 32),
                  ),
                ..._l.map(
                  (e) => FlashCover(data: e, onChanged: _refresh),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 刷新数据
  Future<void> _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    if (mounted) setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

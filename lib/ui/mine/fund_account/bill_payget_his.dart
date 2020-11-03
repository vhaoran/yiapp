import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/model/pays/business.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'bill_item.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/24 18:40
// usage ：收款记录历史
// ------------------------------------------------------

class BillPayGetHisPage extends StatefulWidget {
  BillPayGetHisPage({Key key}) : super(key: key);

  @override
  _BillPayGetHisPageState createState() => _BillPayGetHisPageState();
}

class _BillPayGetHisPageState extends State<BillPayGetHisPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<Business> _l = []; // 收款记录列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询对账单
  _fetch() async {
    if (_pageNo * _rows_per_page > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rows_per_page,
      "sort": {"created_at": -1},
      "where": {
        "action": {"\$gt": 0} // 查询对账单大于0的
      },
    };
    try {
      PageBean pb = await ApiAccount.businessPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as Business).toList();
      Debug.log("总的已收款账单个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Debug.log("当前已查询收款账单多少个：${_l.length}");
    } catch (e) {
      Debug.logError("分页查询已收款账单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildFb();
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(child: CusText("您还没有收款记录", t_gray, 28));
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
                ..._l.map((e) => BillItem(business: e, isPay: false)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 刷新数据
  void _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
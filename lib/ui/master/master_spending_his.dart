import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/ui/master/master_bill_item.dart';
import 'package:yiapp/ui/mine/fund_account/bill_item.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/model/pays/business.dart';
import 'package:yiapp/service/api/api-account.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 上午11:14
// usage ：大师退款记录历史
// ------------------------------------------------------

class MasterSpendingHisPage extends StatefulWidget {
  MasterSpendingHisPage({Key key}) : super(key: key);

  @override
  _MasterSpendingHisPageState createState() => _MasterSpendingHisPageState();
}

class _MasterSpendingHisPageState extends State<MasterSpendingHisPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<Business> _l = []; // 支付记录列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询大师支出对账单
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "sort": {"created_at": -1},
      "where": {
        "action": {"\$lt": 0} // 查询对账单小于0的
      },
    };
    try {
      PageBean pb = await ApiAccount.businessPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as Business).toList();
      Log.info("总的大师支出账单个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Log.info("当前已查询大师支出账单多少个：${_l.length}");
    } catch (e) {
      Log.error("分页查询大师支出账单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildFb();
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(child: CusText("暂无支出记录", t_gray, 28));
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
                ..._l.map((e) => MasterBillItem()),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 刷新数据
  _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

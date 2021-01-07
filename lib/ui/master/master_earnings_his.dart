import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/pays/master_business_res.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'master_bill_item.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 上午11:14
// usage ：大师收益记录历史
// ------------------------------------------------------

class MasterEarningsHisPage extends StatefulWidget {
  MasterEarningsHisPage({Key key}) : super(key: key);

  @override
  _MasterEarningsHisPageState createState() => _MasterEarningsHisPageState();
}

class _MasterEarningsHisPageState extends State<MasterEarningsHisPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<MasterBusinessRes> _l = []; // 支付记录列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询大师收益对账单
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "sort": {"created_at": -1},
      "where": {
        "amt": {"\$gt": 0} // 查询对账单大于0的
      },
    };
    try {
      PageBean pb = await ApiAccount.businessMasterPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as MasterBusinessRes).toList();
      Log.info("总的大师收益账单个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Log.info("当前已查询大师收益账单多少个：${_l.length}");
    } catch (e) {
      Log.error("分页查询大师收益账单出现异常：$e");
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
          return Center(child: CusText("暂无收益记录", t_gray, 28));
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
                ..._l.map((e) => MasterBillItem(business: e, isEarnings: true)),
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

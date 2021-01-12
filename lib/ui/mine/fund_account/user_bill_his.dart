import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:secret/secret.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/model/pays/business.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'bill_item.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/12 上午10:51
// usage ：个人对账单记录
// ------------------------------------------------------

class UserBillHisPage extends StatefulWidget {
  UserBillHisPage({Key key}) : super(key: key);

  @override
  _UserBillHisPageState createState() => _UserBillHisPageState();
}

class _UserBillHisPageState extends State<UserBillHisPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<Business> _l = []; // 支付记录列表
  DateTime _time; // 当前选择的日期

  @override
  void initState() {
    _time = DateTime.now();
    _future = _fetch();
    super.initState();
  }

  /// 分页查询个人对账单
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    String start = "${_time.year}-${_time.month}-1";
    // 获取当前月的最大天数
    int day = SolarUtil.getDaysOfMonth(_time.year, _time.month);
    String end = "${_time.year}-${_time.month}-$day";
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "sort": {"created_at": -1},
      "where": {
        "uid": ApiBase.uid,
        "\$and": [
          {
            "created_at": {"\$gte": "$start 00:00:00"},
          },
          {
            "created_at": {"\$lte": "$end 23:59:59"},
          },
        ],
      },
    };
    try {
      PageBean pb = await ApiAccount.businessPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as Business).toList();
      Log.info("总的个人对账单个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Log.info("当前已查询个人对账单多少个：${_l.length}");
    } catch (e) {
      Log.error("分页查询个人对账单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CusAppBar(text: "对账单记录"),
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
      child: Column(
        children: [
          SizedBox(height: S.h(7)),
          _chTime(),
          SizedBox(height: S.h(7)),
          Expanded(
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
                      child: Text(
                        "当月暂无账单",
                        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                      ),
                    ),
                  if (_l.isNotEmpty) ..._l.map((e) => BillItem(business: e)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 更换时间以及查看月账单
  Widget _chTime() {
    return InkWell(
      onTap: () => TimePicker(
        context,
        pickMode: PickerMode.year_month,
        onConfirm: (val) async {
          DateTime dt = val.toDateTime();
          setState(() => _time = dt);
          await _refresh();
        },
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: S.w(10)),
          Text(
            "${_time.year}年${_time.month}月",
            style: TextStyle(color: t_gray, fontSize: S.sp(16)),
          ),
          Icon(FontAwesomeIcons.caretDown, color: t_gray),
        ],
      ),
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

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/master/master_approve.dart';
import 'package:yiapp/model/dicts/master-apply.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-master.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 14:52
// usage ：分页查询大师申请记录(含待审核、已审核、已拒绝)
// ------------------------------------------------------

class MasterApplyHisPage extends StatefulWidget {
  MasterApplyHisPage({Key key}) : super(key: key);

  @override
  _MasterApplyHisPageState createState() => _MasterApplyHisPageState();
}

class _MasterApplyHisPageState extends State<MasterApplyHisPage> {
  List<MasterInfoApply> _l = []; // 大师申请全记录
  List<String> _tabs = ["全部", "待审核", "已审核", "已拒绝"];
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _count = 50; // 默认每页查询个数
  var _future;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页获取数据
  _fetch() async {
    if (_pageNo * _count > _rowsCount) return; // 默认每页查询20条
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _count,
    };
    try {
      PageBean pb = await ApiMaster.masterInfoApplyPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as MasterInfoApply).toList();

      Log.info("总的大师申请记录个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Log.info("当前已查询多少条数据：${_l.length}");
    } catch (e) {
      Log.error("分页查询大师申请记录出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: "大师申请审批"),
        body: FutureBuilder(
          future: _future,
          builder: (context, snap) {
            if (!snapDone(snap)) {
              return Center(child: CircularProgressIndicator());
            }
            if (_l.isEmpty) {
              return Center(child: CusText("暂时没有大师申请", t_gray, 28));
            }
            return _lv();
          },
        ),
        backgroundColor: primary,
      ),
    );
  }

  Widget _lv() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          indicatorWeight: Adapt.px(6),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.all(Adapt.px(8)),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabs.length,
            (i) => CusText(_tabs[i], t_gray, 28),
          ),
        ),
        SizedBox(height: Adapt.px(15)),
        Expanded(
          child: TabBarView(
            children: List.generate(_tabs.length, (i) {
              bool isAll = i == 0; // 是否为全部分类
              List myList = [];
              myList = isAll ? _l : _l.where((e) => e.stat == i - 1).toList();
              return MasterApproveItem(
                l: myList,
                isAll: isAll,
                onApproval: _doDeal,
                onCancel: _doDeal,
                onLoad: () async {
                  await _fetch();
                  setState(() {});
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  /// 同意或者拒绝申请
  void _doDeal(MasterInfoApply e, int stat) async {
    if (e == null || stat == null) return;
    bool pass = stat == 1;
    try {
      bool ok = await ApiMaster.masterInfoApplyAudit(e.id, stat);
      Log.info("${pass ? '' : '拒绝'}大师申请结果：$ok");
      if (ok) {
        CusToast.toast(context, text: pass ? "已通过审批" : "已拒绝申请");
        _reset();
      }
    } catch (e) {
      Log.error("同意大师申请出现异常：$e");
    }
  }

  // 重置数据
  void _reset() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }
}

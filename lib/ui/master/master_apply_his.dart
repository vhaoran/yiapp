import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/master/com_approve.dart';
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
  int _pageNo = 0;
  int _rowsCount = 0;
  var _future;
  String _dropVal = "全部";

  List<String> _strs = ["全部", "待审核", "已审核", "已拒绝"];

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页获取数据
  _fetch() async {
    if (_pageNo * 20 > _rowsCount) return; // 默认每页查询20条
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": 20,
    };
    try {
      PageBean pb = await ApiMaster.masterInfoApplyPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as MasterInfoApply).toList();

      print(">>>总的大师申请记录个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      print(">>>当前已查询多少条数据：${_l.length}");
    } catch (e) {
      print("<<<分页查询大师申请记录出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _strs.length,
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
          tabs: List.generate(
            _strs.length,
            (i) => CusText(_strs[i], t_gray, 28),
          ),
        ),
        _buildButton(),
        Expanded(
          child: EasyRefresh(
            child: TabBarView(
              children: List.generate(_strs.length, (i) {
                var e = _l[i];
                return ApproveItem(
                  title: e.info.nick,
                  time: e.create_date,
                  brief: e.info.brief,
                  stat: e.stat,
                  onApproval: _doAgree,
                  onCancel: _doRefuse,
                );
              }),
            ),
            onLoad: () async {
              await _fetch();
              setState(() {});
            },
          ),
        ),
//        Expanded(
//          child: EasyRefresh(
//            child: ListView(
//              children: List.generate(
//                _l.length,
//                (i) {
//                  var e = _l[i];
//                  return ApproveItem(
//                    title: e.info.nick,
//                    time: e.create_date,
//                    brief: e.info.brief,
//                    stat: e.stat,
//                    onApproval: _doAgree,
//                    onCancel: _doRefuse,
//                  );
//                },
//              ),
//            ),
//            onLoad: () async {
//              await _fetch();
//              setState(() {});
//            },
//          ),
//        ),
      ],
    );
  }

  Widget _buildButton() {
    return DropdownButton(
      value: _dropVal,
      items: [
        DropdownMenuItem(child: CusText("全部", t_gray, 28), value: "全部"),
        DropdownMenuItem(child: CusText("待审核", t_gray, 28), value: "待审核"),
        DropdownMenuItem(child: CusText("已审核", t_gray, 28), value: "已审核"),
        DropdownMenuItem(child: CusText("已拒绝", t_gray, 28), value: "已拒绝"),
      ],
      onChanged: (val) {
        _dropVal = val;
        setState(() {});
      },
    );
  }

  /// 同意申请
  void _doAgree() async {
    print(">>>点了同意");
  }

  /// 拒绝申请
  void _doRefuse() async {
    print(">>>点了拒绝");
  }
}

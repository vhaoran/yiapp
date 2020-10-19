import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_divider.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/master/cus_number_data.dart';
import 'package:yiapp/complex/widgets/master/master_base_info.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/ui/master/master_order/meet_liuyao.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/19 14:42
// usage ：大师推荐页
// ------------------------------------------------------

class MasterRecommend extends StatefulWidget {
  MasterRecommend({Key key}) : super(key: key);

  @override
  _MasterRecommendState createState() => _MasterRecommendState();
}

class _MasterRecommendState extends State<MasterRecommend> {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<MasterInfo> _l = []; // 大师列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询大师信息
  _fetch() async {
    if (_pageNo * _rows_per_page > _rowsCount) return;
    _pageNo++;
    var m = {"page_no": _pageNo, "rows_per_page": _rows_per_page};
    try {
      PageBean pb = await ApiMaster.masterInfoPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as MasterInfo).toList();
      Debug.log("总的大师个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Debug.log("当前已查询大师多少个：${_l.length}");
    } catch (e) {
      Debug.logError("分页查询大师信息出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "大师推荐"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
            return Center(child: CircularProgressIndicator());
          }
          if (_l.isEmpty) {
            return Center(child: CusText("暂无", t_gray, 28));
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
          children: List.generate(_l.length, (i) {
            MasterInfo e = _l[i];
            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                children: <Widget>[
                  MasterCover(
                    info: e,
                    onPressed: () => CusRoutes.push(
                      context,
                      MeetLiuyaoPage(master_id: e.uid),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CusNumData(
                      titles: ["12345", "100%", "12888"],
                      subtitles: ["服务人数", "好评率", "粉丝数"],
                    ),
                  ), // 详情数据
                  Container(height: 10, color: fif_primary),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  /// 刷新数据
  void _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }
}

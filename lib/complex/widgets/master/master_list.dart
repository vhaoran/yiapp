import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/master/cus_number_data.dart';
import 'package:yiapp/complex/widgets/master/master_base_info.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-master.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/14 17:17
// usage ：大师榜单
// ------------------------------------------------------

class MasterList extends StatefulWidget {
  MasterList({Key key}) : super(key: key);

  @override
  _MasterListState createState() => _MasterListState();
}

class _MasterListState extends State<MasterList>
    with AutomaticKeepAliveClientMixin {
  List<MasterInfo> _l = []; // 大师榜单，目前只有获取所有大师的信息，没有排行榜
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  var _future;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页获取大师信息
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
      Debug.log("当前已查询多少条数据：${_l.length}");
      setState(() {});
    } catch (e) {
      Debug.logError("分页查询大师信息出现异常：$e");
    }
  }

  // 之所以一个 ListView 也另外定义一个Dart文件里，是因为 TabBarView 组件默认同父组件等宽高，
  // 如果指定高度，当前页面不能显示多个数据
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
            return Center(child: CircularProgressIndicator());
          }
          if (_l.isEmpty) {
            return Center(child: CusText("暂无大师入驻", t_gray, 32));
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
            return Column(
              children: <Widget>[
                MasterCover(info: e),
                CusNumData(
                  titles: ["12345", "100%", "12888"],
                  subtitles: ["服务人数", "好评率", "粉丝数"],
                ), // 详情数据
              ],
            );
          }),
        ),
      ),
    );
  }

  /// 重置数据
  void _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

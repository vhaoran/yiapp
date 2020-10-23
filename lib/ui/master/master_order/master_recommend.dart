import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/refresh_hf.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
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
import 'package:yiapp/model/orders/yiOrder-heHun.dart';
import 'package:yiapp/model/orders/yiOrder-sizhu.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/ui/master/master_order/meet_hehun.dart';
import 'package:yiapp/ui/master/master_order/meet_liuyao.dart';
import 'package:yiapp/ui/master/master_order/meet_sizhu.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/19 14:42
// usage ：大师推荐页
// ------------------------------------------------------

class MasterRecommend extends StatefulWidget {
  final int type;
  final YiOrderSiZhu siZhu; // 四柱结果
  final YiOrderHeHun heHun; // 合婚结果
  // 之所以传递时间字符串是不需要再由日期转换，也不用区分阴阳历
  final String timeSiZhu; // 四柱日期
  final String timeHunMale; // 显示合婚类型男生出生日期
  final String timeHunFemale; // 显示合婚类型女生出生日期

  MasterRecommend({
    this.type,
    this.siZhu,
    this.heHun,
    this.timeSiZhu,
    this.timeHunMale,
    this.timeHunFemale,
    Key key,
  }) : super(key: key);

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
                    onPressed: () => _pushPage(e),
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

  /// 根据类型跳转路由
  void _pushPage(MasterInfo e) {
    switch (widget.type) {
      case post_liuyao:
        CusRoutes.push(
          context,
          MeetLiuyaoPage(master_id: e.uid),
        );
        break;
      case post_sizhu:
        CusRoutes.push(
          context,
          MeetSiZhuPage(
            master_id: e.uid,
            siZhu: widget.siZhu,
            timeSiZhu: widget.timeSiZhu,
          ),
        );
        break;
      case post_hehun:
        CusRoutes.push(
          context,
          MeetHeHunPage(
            master_id: e.uid,
            heHun: widget.heHun,
            timeHunMale: widget.timeHunMale,
            timeHunFemale: widget.timeHunFemale,
          ),
        );
        break;
      default:
        break;
    }
  }

  /// 刷新数据
  void _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }
}

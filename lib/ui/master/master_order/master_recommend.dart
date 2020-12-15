import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bo/broker_master_res.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/master/cus_number_data.dart';
import 'package:yiapp/widget/master/master_base_info.dart';
import 'package:yiapp/model/orders/yiOrder-heHun.dart';
import 'package:yiapp/model/orders/yiOrder-sizhu.dart';
import 'package:yiapp/model/pagebean.dart';
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
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<BrokerMasterRes> _l = []; // 大师列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询大师信息
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {"page_no": _pageNo, "rows_per_page": _rowsPerPage};
    try {
      PageBean pb = await ApiBo.bMasterPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
      var l = pb.data.map((e) => e as BrokerMasterRes).toList();
      Log.info("总的大师个数：$_rowsCount");
      l.forEach((src) {
        // 在原来的基础上继续添加新的数据
        var dst = _l.firstWhere((e) => src.broker_id != e.broker_id,
            orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Log.info("当前已查询大师多少个：${_l.length}");
    } catch (e) {
      Log.error("分页查询大师信息出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "大师推荐"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (_l.isEmpty) {
            return Center(
              child: Text(
                "暂无",
                style: TextStyle(color: t_gray, fontSize: S.sp(15)),
              ),
            );
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
            BrokerMasterRes e = _l[i];
            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                children: <Widget>[
                  Container(height: 10, color: fif_primary),
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
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  /// 根据类型跳转路由
  void _pushPage(BrokerMasterRes e) {
    switch (widget.type) {
      case post_liuyao:
        CusRoute.push(
          context,
          MeetLiuyaoPage(master_id: e.uid),
        );
        break;
      case post_sizhu:
        CusRoute.push(
          context,
          MeetSiZhuPage(
            master_id: e.uid,
            siZhu: widget.siZhu,
            timeSiZhu: widget.timeSiZhu,
          ),
        );
        break;
      case post_hehun:
        CusRoute.push(
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
  Future<void> _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    await _fetch();
    setState(() {});
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/masters/vie/master_vie_doing_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/post_com/post_com_button.dart';
import 'package:yiapp/widget/post_com/post_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 上午9:35
// usage ：大师闪断帖处理中订单入口
// ------------------------------------------------------

class MasterVieDoingMain extends StatefulWidget {
  MasterVieDoingMain({Key key}) : super(key: key);

  @override
  _MasterVieDoingMainState createState() => _MasterVieDoingMainState();
}

class _MasterVieDoingMainState extends State<MasterVieDoingMain>
    with AutomaticKeepAliveClientMixin {
  var _future;
  List<BBSVie> _l = []; // 闪断帖处理中列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 大师分页查询闪断帖处理中订单
  _fetch() async {
    var m = {
      "where": {"master_id": ApiBase.uid, "stat": bbs_aim},
      "sort": {"last_updated": -1}
    };
    try {
      PageBean pb = await ApiBBSVie.bbsViePage(m);
      if (pb != null) {
        var l = pb.data.map((e) => e as BBSVie).toList();
        if (l != null) {
          _l = l;
          Log.info("大师处理中的闪断帖个数 ${_l.length}");
          setState(() {});
        }
      }
    } catch (e) {
      Log.error("大师查询处理中的闪断帖出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return _lv();
      },
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
          children: <Widget>[
            if (_l.isEmpty) EmptyContainer(text: "暂无订单"),
            if (_l.isNotEmpty) ..._l.map((e) => _coverItem(e)),
          ],
        ),
      ),
    );
  }

  Widget _coverItem(BBSVie vie) {
    return InkWell(
      onTap: () => _lookViePost(vie.id),
      child: PostComCover(
        vie: vie,
        events: Row(
          children: <Widget>[
            PostComButton(
              text: "详情",
              onPressed: () => _lookViePost(vie.id),
            ),
            PostComButton(
              text: "回复",
              onPressed: () => _lookViePost(vie.id),
            ),
          ],
        ),
      ),
    );
  }

  /// 查看闪断帖处理中订单详情
  void _lookViePost(String postId) {
    CusRoute.push(context, MasterVieDoingPage(postId: postId))
        .then((value) async {
      if (value != null) {
        await _refresh();
      }
    });
  }

  /// 刷新数据
  _refresh() async {
    _l.clear();
    setState(() {});
    await _fetch();
  }

  @override
  bool get wantKeepAlive => true;
}

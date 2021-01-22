import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/vip/vie/user_vie_doing_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/post_com/post_com_button.dart';
import 'package:yiapp/widget/post_com/post_com_cover.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 下午7:48
// usage ：会员闪断帖处理中订单入口
// ------------------------------------------------------

class UserVieDoingMain extends StatefulWidget {
  UserVieDoingMain({Key key}) : super(key: key);

  @override
  _UserVieDoingMainState createState() => _UserVieDoingMainState();
}

class _UserVieDoingMainState extends State<UserVieDoingMain>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<BBSVie> _l = []; // 闪断帖处理中列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 会员分页查询闪断帖处理中订单，含已付款和已抢单两种状态
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "where": {
        "stat": {
          "\$in": [bbs_paid, bbs_aim]
        },
        "uid": ApiBase.uid
      },
      "sort": {"create_date_int": -1},
    };
    try {
      PageBean pb = await ApiBBSVie.bbsViePage(m);
      if (pb != null) {
        if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
        Log.info("未过滤时闪断帖总个数 $_rowsCount");
        var l = pb.data.map((e) => e as BBSVie).toList();
        l.forEach((src) {
          var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
          if (dst == null) _l.add(src);
        });
        Log.info("已加载闪断帖处理中个数 ${_l.length}");
        setState(() {});
      }
    } catch (e) {
      Log.error("分页查询闪断帖处理中出现异常：$e");
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
            // 如果没有大师回复时，用户可以选择取消订单
            if (vie.reply.isEmpty)
              PostComButton(
                text: "取消",
                onPressed: () => _doCancel(vie.id),
              ),
            // 有大师回复时，用户可点击回复
            if (vie.reply.isNotEmpty)
              PostComButton(
                text: "回复",
                onPressed: () => _lookViePost(vie.id),
              ),
          ],
        ),
      ),
    );
  }

  /// 取消闪断帖订单
  void _doCancel(String postId) {
    CusDialog.normal(context, title: "确定取消订单吗?", textCancel: "再想想",
        onApproval: () async {
      try {
        bool ok = await ApiBBSVie.bbsVieCancel(postId);
        if (ok) {
          Log.info("取消闪断帖订单结果：$ok");
          CusToast.toast(context, text: "取消成功");
          await _refresh();
        }
      } catch (e) {
        CusToast.toast(context, text: "该帖子已不可取消", milliseconds: 1500);
        await _refresh();
        Log.error("取消闪断帖订单出现异常：$e");
      }
    });
  }

  /// 查看闪断帖处理中订单详情
  void _lookViePost(String postId) {
    CusRoute.push(context, UserVieDoingPage(postId: postId))
        .then((value) async {
      if (value != null) {
        await _refresh();
      }
    });
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

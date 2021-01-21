import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/post_com_detail.dart';
import 'package:yiapp/widget/post_com/post_com_header.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 下午7:54
// usage ：会员悬赏帖处理中订单详情
// ------------------------------------------------------

class UserPrizeDoingPage extends StatefulWidget {
  final String postId;

  UserPrizeDoingPage({this.postId, Key key}) : super(key: key);

  @override
  _UserPrizeDoingPageState createState() => _UserPrizeDoingPageState();
}

class _UserPrizeDoingPageState extends State<UserPrizeDoingPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  BBSPrize _bbsPrize; // 悬赏帖处理中详情

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      BBSPrize res = await ApiBBSPrize.bbsPrizeGet(widget.postId);
      if (res != null) {
        _bbsPrize = res;
        Log.info("当前悬赏帖处理中详情：${_bbsPrize.toJson()}");
        setState(() {});
      }
    } catch (e) {
      Log.error("查询悬赏帖处理中详情出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CusAppBar(text: "问题详情"),
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
    return EasyRefresh(
      header: CusHeader(),
      footer: CusFooter(),
      onRefresh: () async => await _fetch(),
      child: ListView(
        children: [
          if (_bbsPrize == null) EmptyContainer(text: "帖子已被删除"),
          if (_bbsPrize != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: S.w(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PostComHeader(prize: _bbsPrize), // 帖子顶部信息
                  PostComDetail(prize: _bbsPrize), // 帖子基本信息
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

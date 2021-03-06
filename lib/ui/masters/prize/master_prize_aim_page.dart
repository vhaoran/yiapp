import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/ui/masters/prize/master_prize_aim_reply_area.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/post_com_detail.dart';
import 'package:yiapp/widget/post_com/post_com_header.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 上午11:55
// usage ：大师悬赏帖可抢单订单详情
// ------------------------------------------------------

class MasterPrizeAimPage extends StatefulWidget {
  final String postId;

  MasterPrizeAimPage({this.postId, Key key}) : super(key: key);

  @override
  _MasterPrizeAimPageState createState() => _MasterPrizeAimPageState();
}

class _MasterPrizeAimPageState extends State<MasterPrizeAimPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  BBSPrize _prize; // 悬赏帖可抢单详情

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      BBSPrize res = await ApiBBSPrize.bbsPrizeGet(widget.postId);
      if (res != null) {
        _prize = res;
        Log.info("当前悬赏帖可抢单详情：${_prize.toJson()}");
        setState(() {});
      }
    } catch (e) {
      Log.error("查询悬赏帖可抢单详情出现异常：$e");
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
          if (_prize == null) EmptyContainer(text: "帖子已被删除"),
          if (_prize != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: S.w(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PostComHeader(prize: _prize), // 帖子顶部信息
                  PostComDetail(prize: _prize), // 帖子基本信息
                ],
              ),
            ),
            // 帖子评论区
            MasterPrizeAimReplyArea(prize: _prize),
          ],
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

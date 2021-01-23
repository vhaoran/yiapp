import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/ui/masters/prize/master_prize_all_reply_page.dart';
import 'package:yiapp/ui/masters/prize/master_prize_reply_area.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/post_com_detail.dart';
import 'package:yiapp/widget/post_com/post_com_header.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 上午11:00
// usage ：大师悬赏帖已完成订单详情
// ------------------------------------------------------

class MasterPrizeHisPage extends StatefulWidget {
  final String postId;

  MasterPrizeHisPage({this.postId, Key key}) : super(key: key);

  @override
  _MasterPrizeHisPageState createState() => _MasterPrizeHisPageState();
}

class _MasterPrizeHisPageState extends State<MasterPrizeHisPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  BBSPrize _prize; // 悬赏帖已完成详情

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      BBSPrize res = await ApiBBSPrize.bbsPrizeHisGet(widget.postId);
      if (res != null) {
        _prize = res;
        Log.info("当前悬赏帖已完成详情：${_prize.toJson()}");
        setState(() {});
      }
    } catch (e) {
      Log.error("大师查询悬赏帖已完成详情出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _appBarWt(),
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
    return Column(
      children: [
        Expanded(
          child: EasyRefresh(
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
                  MasterPrizeReplyArea(prize: _prize),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _appBarWt() {
    return CusAppBar(
      text: "问题详情",
      actions: [
        FlatButton(
          child:
              Text("详情", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
          onPressed: () {
            CusRoute.push(
              context,
              MasterPrizeAllReplyPage(postId: _prize.id, isHis: true),
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

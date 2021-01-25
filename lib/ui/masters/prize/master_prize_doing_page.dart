import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/ui/masters/prize/master_prize_all_reply_page.dart';
import 'package:yiapp/ui/masters/prize/master_prize_input.dart';
import 'package:yiapp/ui/masters/prize/master_prize_reply_area.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/post_com/post_com_detail.dart';
import 'package:yiapp/widget/post_com/post_com_header.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/empty_container.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 下午5:34
// usage ：大师悬赏帖处理中订单详情
// ------------------------------------------------------

class MasterPrizeDoingPage extends StatefulWidget {
  final String postId;

  MasterPrizeDoingPage({this.postId, Key key}) : super(key: key);

  @override
  _MasterPrizeDoingPageState createState() => _MasterPrizeDoingPageState();
}

class _MasterPrizeDoingPageState extends State<MasterPrizeDoingPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  BBSPrize _prize; // 悬赏帖处理中详情

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
        Log.info("大师当前悬赏帖处理中详情：${_prize.toJson()}");
        setState(() {});
      }
    } catch (e) {
      Log.error("大师查询悬赏帖处理中详情出现异常：$e");
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
        // 大师回复帖子
        if (_prize != null) MasterPrizeInput(prize: _prize, onSend: _fetch),
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
              MasterPrizeAllReplyPage(postId: _prize.id),
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/post_com/post_com_detail.dart';
import 'package:yiapp/widget/post_com/post_com_header.dart';
import 'package:yiapp/widget/post_com/post_prize_input.dart';
import 'package:yiapp/widget/post_com/post_user_prize_reply.dart';
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
  BBSPrize _prize; // 悬赏帖处理中详情
  bool _overBtn = false; // 是否隐藏结单按钮，赏金发完显示结单按钮，隐藏打赏大师按钮
  BBSPrizeReply _selectMaster; // 会员当前选择的大师

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
        Log.info("当前悬赏帖处理中详情：${_prize.toJson()}");
        num money = 0;
        res.master_reply.forEach((e) => {money += e.amt});
        _overBtn = res.amt == money;
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
                  PostUserPrizeReply(
                    prize: _prize,
                    overBtn: _overBtn,
                    fnSelectMaster: (val) {
                      setState(() => _selectMaster = val);
                    },
                    onReward: _fetch,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_prize != null)
          PostPrizeInput(
            selectMaster: _selectMaster,
            prize: _prize,
            onSend: _fetch,
          ),
      ],
    );
  }

  Widget _appBarWt() {
    return CusAppBar(
      text: "问题详情",
      actions: [
        // 本人处理中的帖子，且悬赏金已经发完，显示结单按钮
        if (_overBtn)
          FlatButton(
            child:
                Text("结单", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
            onPressed: () {
              CusDialog.normal(context, title: "确定结单吗?", onApproval: () async {
                try {
                  bool ok = await ApiBBSPrize.bbsPrizeDue(_prize.id);
                  if (ok) {
                    CusToast.toast(context, text: "已结单");
                    Navigator.of(context).pop("");
                  }
                } catch (e) {
                  Log.error("会员悬赏帖结单出现异常：$e");
                }
              });
            },
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
